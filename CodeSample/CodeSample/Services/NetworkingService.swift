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
}

class NetworkingService : NetworkingServiceProtocol {
    
    //this seems like a straightforward passthrough, except this is the only
    //file in the project that uses URLSession which allows us to swap our
    //URLSession responses with a mocked implementaions
    public func performUrlRequest(_ request : URLRequest, onResult: @escaping (Result<(URLResponse, Data), Error>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: request) { (dataTaskResult) in
            //maybe put analytics here since all (non-mocked) requests come through here
            onResult(dataTaskResult)
        }
        dataTask.resume()
    }
}

extension URLSession {
    
    //this extension basically overloads the "dataTask with request" to use the swift result enum
    func dataTask(with request: URLRequest,
                  result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        
        return dataTask(with: request) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "Data task's response and data are nil", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
    
}

