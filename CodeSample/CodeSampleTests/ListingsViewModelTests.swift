//
//  ListingsViewModelTests.swift
//  CodeSampleTests
//
//  Created by Ryan Lons on 7/7/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//

import XCTest
@testable import CodeSample

class ListingsViewModelTests: XCTestCase {
    var mockListingsService : MockListingsService!
    var mockFiltersService : MockFiltersService!
    
    override func setUp() {
        mockListingsService = MockListingsService()
        mockFiltersService = MockFiltersService()
    }
    
    func testEnsureNoBouncedFetches() async throws {
        let listingsVM = ListingsViewModel(listingService: mockListingsService, filtersService: mockFiltersService)
        XCTAssert(listingsVM.fetchInProgress == false )
            
        listingsVM.fetch()
        
        XCTAssert(listingsVM.fetchInProgress == true )
    }
}
