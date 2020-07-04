//
//  Listing.swift
//  CodeSample
//
//  Created by Ryan Lons on 7/4/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//

struct Listing : Codable{
    var id : UInt64
    var thumbUrl : String
    var address : String
    var subTitle : String?
    var price : UInt32
    var squareFootage : UInt32?
    var beds : UInt8?
    var baths : UInt8?
    var halfBaths : UInt8?
    var isFavorited : Bool
    var propertyType : PropertyType
}
