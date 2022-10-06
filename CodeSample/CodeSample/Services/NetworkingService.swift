//
//  NetworkingService.swift
//  CodeSample
//
//  Created by Ryan Lons on 7/4/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//

import Foundation

enum NetworkingServiceError: Error {
    case invalidUrl(String)
    case badResponse
}

class NetworkingService : NetworkingServiceProtocol {
    //this seems like a straightforward passthrough, except this is the only
    //file in the project that uses URLSession which allows us to swap our
    //URLSession responses with a mocked implementaions
    func performUrlRequest(_ request: URLRequest) async throws ->  (Data, URLResponse) {
        return try await URLSession.shared.data(for: request)
    }
}
