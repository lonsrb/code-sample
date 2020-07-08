//
//  MockListingsService.swift
//  CodeSampleTests
//
//  Created by Ryan Lons on 7/8/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//


import UIKit.UIImage
@testable import CodeSample

class MockListingsService : ListingsServiceProtocol {
    func loadListingImage(thumbnailURL: String, onCompletion: @escaping (Result<UIImage, Error>) -> Void) {
        
    }
    
    func favoriteListing(listingId: String, isFavorite: Bool, onCompletion: @escaping (Result<Void, Error>) -> Void) {
        
    }
    
    func getListings(startIndex: Int, propertyTypeFilter: [PropertyType]?, onCompletion: @escaping (Result<[Listing], Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let listing = self.createTestListing()
            onCompletion(.success([listing]))
        }
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
                           propertyType: PropertyType = .house) -> Listing {
        
        let listing = Listing(id: id, thumbUrl: thumbUrl, address: address, addressLine2: addressLine2, subTitle: subTitle, price: price, squareFootage: squareFootage, beds: beds, baths: baths, halfBaths: halfBaths, isFavorited: isFavorited, propertyType: propertyType)
        return listing
    }
    
    
}
