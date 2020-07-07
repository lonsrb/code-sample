//
//  ListingsService.swift
//  CodeSample
//
//  Created by Ryan Lons on 7/4/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//

import Foundation
import UIKit.UIImage

class ListingsService {
    
    private let networkingService : NetworkingServiceProtocol!
    private let pageSize = 25
    
    init(networkingService : NetworkingServiceProtocol) {
        self.networkingService = networkingService
    }
    
    func loadListingImage(thumbnailURL : String, onCompletion: @escaping (Result<UIImage, Error>) -> Void ) {
        guard let url = URL(string: thumbnailURL) else {
            onCompletion(.failure(NetworkingServiceError.invalidUrl(thumbnailURL)))
            return
        }
        let request = URLRequest(url: url)
        networkingService.performUrlRequest(request) { result in
            switch result {
            case .success(_, let data):
                if let image = UIImage(data: data) {
                    onCompletion(.success(image))
                }
                else {
                    let image = UIImage(named: "NoImagePlaceholder")
                    onCompletion(.success(image!))
                }
                break
            case .failure(let error):
                onCompletion(.failure(error))
                break
            }
        }
    }
    
    func favoriteListing(listingId : String, isFavorite: Bool, onCompletion: @escaping (Result<Void, Error>) -> Void) {
        guard let urlComponents = NSURLComponents(string: "http://localhost:9292/favorite"),
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
            case .success(_,_):
                //                if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) {
                //                    print(jsonResponse) //Response result
                //                }
                
                onCompletion(.success(()))
                break
            case .failure(let error):
                onCompletion(.failure(error))
                break
            }
        }
    }
    
    func getListings(startIndex: Int, propertyTypeFilter: [PropertyType]?, onCompletion: @escaping (Result<[Listing], Error>) -> Void) {
        
        guard let urlComponents = NSURLComponents(string: "http://localhost:9292/listings") else { return }
        
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
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        networkingService.performUrlRequest(request) { result in
            switch result {
            case .success(_, let data):
                do{
                    let decoder = JSONDecoder()
                    let listings = try decoder.decode([Listing].self, from: data)
                    onCompletion(.success(listings))
                } catch let parsingError {
                    onCompletion(.failure(parsingError))
                }
                break
            case .failure(let error):
                onCompletion(.failure(error))
                break
            }
        }
    }
}
