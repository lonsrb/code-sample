//
//  ListingsService.swift
//  CodeSample
//
//  Created by Ryan Lons on 7/4/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//

import Foundation
import UIKit.UIImage

protocol ListingsServiceProtocol {
    func loadListingImage(thumbnailURL : String) async throws -> UIImage
    func favoriteListing(listingId : String, isFavorite: Bool, onCompletion: @escaping (Result<Void, Error>) -> Void)
    func getListings(startIndex: Int, propertyTypeFilter: [PropertyType]?) async -> [Listing]
}

class ListingsService : ListingsServiceProtocol {
    
    private var networkingService : NetworkingServiceProtocol!
    private let pageSize = 25
    
    init(networkingService : NetworkingServiceProtocol) {
        self.networkingService = networkingService
    }
    
    func loadListingImage(thumbnailURL : String) async throws -> UIImage {
        guard let url = URL(string: thumbnailURL) else {
            throw NetworkingServiceError.invalidUrl(thumbnailURL)
        }
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        if let image = UIImage(data: data) {
            return image
        }
        else {
            let placeHolder = UIImage(named: "NoImagePlaceholder")!
            return placeHolder
        }
    }
    
    func favoriteListing(listingId : String, isFavorite: Bool, onCompletion: @escaping (Result<Void, Error>) -> Void) {
        guard let urlComponents = NSURLComponents(string: ApplicationConfiguration.hostUrl + Endpoints.favorite),
            let url = urlComponents.url else {
                assertionFailure("we control the URL, it should make sense and never be nil here")
                return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let parameters = ["listingId": listingId, "isFavorite": String(isFavorite)]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }
        catch let error {
            onCompletion(.failure(error))
        }
        
        networkingService.performUrlRequest(request) { result in
            switch result {
            case .success((_,_)):
                onCompletion(.success(()))
                break
            case .failure(let error):
                onCompletion(.failure(error))
                break
            }
        }
    }
    
    func getListings(startIndex: Int, propertyTypeFilter: [PropertyType]?) async -> [Listing] {
        
        guard let urlComponents = NSURLComponents(string: ApplicationConfiguration.hostUrl + Endpoints.listings) else {
            assertionFailure("we control the URL, it should make sense and never be nil here")
            return []
        }
        
        var queryItems = [URLQueryItem(name: "startIndex", value: String(startIndex)),
                          URLQueryItem(name: "count", value: String(pageSize))]
        
        if let propertyTypeFilter = propertyTypeFilter {
            let stringArray = propertyTypeFilter.map { $0.rawValue }
            let filterQueryItem = URLQueryItem(name: "propertyType", value: stringArray.joined(separator: ","))
            queryItems.append(filterQueryItem)
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            assertionFailure() //we control the URL, it should make sense and never be nil here
            return []
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            let listings = try decoder.decode([Listing].self, from: data)
            return listings
        }
        catch {
            return []
        }
    }
}
