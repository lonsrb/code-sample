//
//  Listing.swift
//  CodeSample
//
//  Created by Ryan Lons on 7/4/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//

struct Listing : Codable{
    
    var id : String
    var thumbUrl : String
    var address : String
    var addressLine2 : String
    var subTitle : String?
    var price : UInt32
    var squareFootage : UInt32?
    var beds : UInt8?
    var baths : UInt8?
    var halfBaths : UInt8?
    var isFavorited : Bool
    var propertyType : PropertyType
    
    internal init(id: String, thumbUrl: String, address: String, addressLine2: String, subTitle: String?, price: UInt32, squareFootage: UInt32?, beds: UInt8?, baths: UInt8?, halfBaths: UInt8?, isFavorited: Bool, propertyType: PropertyType) {
           self.id = id
           self.thumbUrl = thumbUrl
           self.address = address
           self.addressLine2 = addressLine2
           self.subTitle = subTitle
           self.price = price
           self.squareFootage = squareFootage
           self.beds = beds
           self.baths = baths
           self.halfBaths = halfBaths
           self.isFavorited = isFavorited
           self.propertyType = propertyType
    }
}
