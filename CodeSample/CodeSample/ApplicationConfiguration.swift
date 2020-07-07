//
//  ApplicationConfiguration.swift
//  CodeSample
//
//  Created by Ryan Lons on 7/7/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//

struct ApplicationConfiguration {
    
    static let hostUrl: String = "http://localhost:9292"
    
    static func setup() {
        let networkingService = NetworkingService.shared
        ListingsService.setupShared(networkingService: networkingService)
    }
}
