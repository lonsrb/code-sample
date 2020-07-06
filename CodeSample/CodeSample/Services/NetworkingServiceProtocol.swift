//
//  NetworkingServiceProtocol.swift
//  CodeSample
//
//  Created by Ryan Lons on 7/4/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//

import Foundation

protocol NetworkingServiceProtocol {
    func performUrlRequest(_ request : URLRequest,
                           onResult: @escaping (Result<(URLResponse, Data), Error>) -> Void)
}
