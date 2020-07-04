//
//  ListingsService.swift
//  CodeSample
//
//  Created by Ryan Lons on 7/4/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//

import Foundation

class ListingsService {
    class func tempGetDummyListings() -> [Listing] {
        var listings = [Listing]()
        listings.append(Listing(id: 11111,
                                thumbUrl: "https://via.placeholder.com/400x200.png?text=Listing+Image+Placeholder+A",
                                address: "123 Hire Ryan Ln",
                                subTitle: "New Construction",
                                price: 1200000,
                                squareFootage: 2800,
                                beds: 4,
                                baths: 2,
                                halfBaths: 1,
                                isFavorited: false,
                                propertyType: .house))
        
        listings.append(Listing(id: 22222,
                                thumbUrl: "https://via.placeholder.com/400x200.png?text=Listing+Image+Placeholder+B",
                                address: "5432 Swift Way",
                                subTitle: "Coming Soon!",
                                price: 987000,
                                squareFootage: 2100,
                                beds: 3,
                                baths: 2,
                                halfBaths: nil,
                                isFavorited: false,
                                propertyType: .townhouse))
        
        listings.append(Listing(id: 33333,
                                thumbUrl: "https://via.placeholder.com/400x200.png?text=Listing+Image+Placeholder+C",
                                address: "987 Aloha Pkwy",
                                subTitle: nil,
                                price: 600000,
                                squareFootage: nil,
                                beds: nil,
                                baths: nil,
                                halfBaths: nil,
                                isFavorited: false,
                                propertyType: .land))
        
        return listings
    }
}
