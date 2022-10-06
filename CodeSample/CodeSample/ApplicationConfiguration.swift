//
//  ApplicationConfiguration.swift
//  CodeSample
//
//  Created by Ryan Lons on 7/7/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//

private var _shared : ApplicationConfiguration!

class ApplicationConfiguration {
    
    static let hostUrl: String = "http://127.0.0.1:8080"
//    static let hostUrl: String = "http://ryanlons.me"
    var listingsService : ListingsServiceProtocol!
    var filtersService : FiltersServiceProtocol!
    
    static func configure() {
        _shared = ApplicationConfiguration()
    }
    
    private init() {
        let networkingService = NetworkingService()
        listingsService = ListingsService(networkingService: networkingService)
        filtersService = FiltersService()
    }
    
    class var shared: ApplicationConfiguration {
        if _shared == nil {
            assertionFailure("error: shared must only be called after setup()")
        }
        return _shared
    }
}
