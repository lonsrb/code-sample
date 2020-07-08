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
    
    func testEnsureNoBouncedFetches() {
        let listingsVM = ListingsViewModel(listingService: mockListingsService, filtersService: mockFiltersService)
        XCTAssert(listingsVM.fetchInProgress == false )
        listingsVM.fetch()
        XCTAssert(listingsVM.fetchInProgress == true )
        let expect = expectation(description: "AsyncAction")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssert(listingsVM.fetchInProgress == false )
            expect.fulfill()
        }
        waitForExpectations(timeout: 4, handler: nil)
    }
    
    func createTestListing(id: String = "aaa",
                           thumbUrl: String = "someUrl",
                           address: String = "1234 Qwerty Ln",
                           addressLine2: String = "Austin, TX 78701",
                           subTitle: String? = nil,
                           price: UInt32 = 1000000,
                           squareFootage: UInt32? = nil,
                           beds: UInt8? = nil,
                           baths: UInt8? = nil,
                           halfBaths: UInt8? = nil,
                           isFavorited: Bool = false,
                           propertyType: PropertyType = .house) -> ListingViewModel {
        
        let listing = Listing(id: id, thumbUrl: thumbUrl, address: address, addressLine2: addressLine2, subTitle: subTitle, price: price, squareFootage: squareFootage, beds: beds, baths: baths, halfBaths: halfBaths, isFavorited: isFavorited, propertyType: propertyType)
        return ListingViewModel(listing: listing, listingsService: MockListingsService())
    }
  

}
