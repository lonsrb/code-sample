//
//  MockNetworkingService.swift
//  CodeSample
//
//  Created by Ryan Lons on 7/5/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//

import Foundation

enum MockNetworkingServiceError: Error {
    case noMocksRegistered
    case noUrl
    case responseFailed
}

class MockNetworkingService : NetworkingServiceProtocol {
    private var jsonResponses = [String : String]()
    private var httpStatusCodeResponses = [String : Int]()
    private var latencyForRequests = [String : Int]()
    
    func performUrlRequest(_ request: URLRequest) async throws -> (Data, URLResponse) {
        guard let url = request.url else {
            throw MockNetworkingServiceError.noUrl
        }
        
        var foundMock = false
        var statusCode = 200
        
        var dataToReturn : Data = Data(count: 0)
        if let filePathString = jsonResponses[url.absoluteString] {
            let filePathArray = filePathString.split(separator: ".")
            if let path = Bundle.main.path(forResource: String(filePathArray[0]), ofType: String(filePathArray[1])),
               let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
                    foundMock = true
                    dataToReturn = data
            }
        }
        
        if let latency = latencyForRequests[url.absoluteString] {
            foundMock = true
            sleep(UInt32(latency))
        }
        
        if let mockStatusCode = httpStatusCodeResponses[url.absoluteString] {
            foundMock = true
            statusCode = mockStatusCode
        }
        
        if !foundMock {
            throw MockNetworkingServiceError.noMocksRegistered
        }
        
        guard let httpResponse = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: "1.0", headerFields: nil) else { throw MockNetworkingServiceError.responseFailed }
        return (dataToReturn, httpResponse)
    }
  
    public func registerJsonFileForUrl(url : String, filePath : String) {
        jsonResponses[url] = filePath
    }
    
    public func registerHttpStatusCodeForUrl(url : String, code : Int) {
        httpStatusCodeResponses[url] = code
    }
    
    public func registerLatencyForUrl(url : String, seconds : Int) {
        latencyForRequests[url] = seconds
    }
}
