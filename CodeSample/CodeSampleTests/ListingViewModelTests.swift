//
//  ListingViewModelTests.swift
//  CodeSampleTests
//
//  Created by Ryan Lons on 7/7/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//

import XCTest
@testable import CodeSample

class ListingViewModelTests: XCTestCase {
    
    override func setUp() {
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

    func testBathsPresentaionLogic1Full1Half() {
        let listingVM = createTestListing(baths: 1, halfBaths: 1)
        let result = listingVM.bathsString
        XCTAssert(result == "1.5", "unexpected result: \(String(describing: result))")
    }
    
    func testBathsPresentaionLogic1Full0Half() {
        let listingVM = createTestListing(baths: 1, halfBaths: 0)
        let result = listingVM.bathsString
        XCTAssert(result == "1", "unexpected result: \(String(describing: result))")
    }
    
    func testBathsPresentaionLogic0Full1Half() {
        let listingVM = createTestListing(baths: 0, halfBaths: 1)
        let result = listingVM.bathsString
        XCTAssert(result == "0.5", "unexpected result: \(String(describing: result))")
    }
    
    func testBathsPresentaionLogic1Full2Half() {
        let listingVM = createTestListing(baths: 1, halfBaths: 2)
        let result = listingVM.bathsString
        XCTAssert(result == "1f, 2h", "unexpected result: \(String(describing: result))")
    }
    
    func testBathsPresentaionLogicNilFull1Half() {
        let listingVM = createTestListing(baths: nil, halfBaths: 1)
        let result = listingVM.bathsString
        XCTAssert(result == "1 half", "unexpected result: \(String(describing: result))")
    }
    
    func testBathsPresentaionLogicNilFullNilHalf() {
        let listingVM = createTestListing(baths: nil, halfBaths: nil)
        let result = listingVM.bathsString
        XCTAssert(result == "--", "unexpected result: \(String(describing: result))")
    }
    
    func testPricePresentaion() {
        let listingVM = createTestListing(price: 1234567)
        let result = listingVM.priceString
        XCTAssert(result == "$1,234,567", "unexpected result: \(String(describing: result))")
    }
    
    func testBedsPresentaion3Beds() {
        let listingVM = createTestListing(beds: 3)
        let result = listingVM.bedsString
        XCTAssert(result == "3", "unexpected result: \(String(describing: result))")
    }
    
    func testBedsPresentaionNilBeds() {
        let listingVM = createTestListing(beds: nil)
        let result = listingVM.bedsString
        XCTAssert(result == "--", "unexpected result: \(String(describing: result))")
    }
    
    func testSqFtPresentaionNil() {
        let listingVM = createTestListing(squareFootage: nil)
        let result = listingVM.sqFtString
        XCTAssert(result == "--", "unexpected result: \(String(describing: result))")
    }
    
    func testSqFtPresentaionSub1000() {
        let listingVM = createTestListing(squareFootage: 888)
        let result = listingVM.sqFtString
        XCTAssert(result == "888", "unexpected result: \(String(describing: result))")
    }
    
    func testSqFtPresentaionOver1000() {
        let listingVM = createTestListing(squareFootage: 9001)
        let result = listingVM.sqFtString
        XCTAssert(result == "9,001", "unexpected result: \(String(describing: result))")
    }
    func testToogleFavoriteStatus() async throws {
        let listingVM = createTestListing()
        XCTAssert(listingVM.isFavorite == false)
        await listingVM.toogleFavoriteStatus()
        XCTAssert(listingVM.isFavorite == true)
        XCTAssert(listingVM.listing.isFavorited == true)
    }

    

}
