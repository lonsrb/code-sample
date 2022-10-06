//
//  ListingsService.swift
//  CodeSample
//
//  Created by Ryan Lons on 7/4/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//

import Foundation
import UIKit.UIImage
import Combine

protocol ListingsServiceProtocol {
    var listingsSubject: PassthroughSubject<[Listing], Never> { get }
    func loadListingImage(thumbnailURL : String) async throws -> UIImage
    func favoriteListing(listingId : String, isFavorite: Bool) async throws
    func getListings(startIndex: Int, propertyTypeFilter: [PropertyType]?) async -> [Listing]
}

class ListingsService : ListingsServiceProtocol {
    
    var listingsSubject = PassthroughSubject<[Listing], Never>()
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
        let (data, _) = try await networkingService.performUrlRequest(request)
        if let image = UIImage(data: data) {
            return image
        }
        else {
            let placeHolder = UIImage(named: "NoImagePlaceholder")!
            return placeHolder
        }
    }
    
    func favoriteListing(listingId : String, isFavorite: Bool) async throws {
        guard let urlComponents = NSURLComponents(string: ApplicationConfiguration.hostUrl + Endpoints.favorite),
            let url = urlComponents.url else {
                assertionFailure("we control the URL, it should make sense and never be nil here")
                return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let parameters = ["listingId": listingId, "isFavorite": String(isFavorite)]
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        _ = try await networkingService.performUrlRequest(request)
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
            let (data, _) = try await networkingService.performUrlRequest(request)
            let decoder = JSONDecoder()
            let listings = try decoder.decode([Listing].self, from: data)
            listingsSubject.send(listings)
            return listings
        }
        catch {
            print("there was an error decoding the listing results")
            return []
        }
    }
}
