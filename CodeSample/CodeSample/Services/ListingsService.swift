//
//  ListingsService.swift
//  CodeSample
//
//  Created by Ryan Lons on 7/4/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//

import Foundation

class ListingsService {
    
    private let networkingService : NetworkingServiceProtocol!
    private let pageSize = 25
    
    init(networkingService : NetworkingServiceProtocol) {
        self.networkingService = networkingService
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
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                                       print(jsonResponse) //Response result
                    
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
