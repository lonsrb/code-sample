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
    
    enum CodingKeys : String, CodingKey {
        case id = "id"
        case thumbUrl = "thumbUrl"
        case address = "address"
        case addressLine2 = "addressLine2"
        case subTitle = "subTitle"
        case price = "price"
        case squareFootage = "squareFootage"
        case beds = "beds"
        case baths = "baths"
        case halfBaths = "halfBaths"
        case isFavorited = "isFavorited"
        case propertyType = "propertyType"
    }
    
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.thumbUrl = try container.decode(String.self, forKey: .thumbUrl)
        self.address = try container.decode(String.self, forKey: .address)
        self.addressLine2 = try container.decode(String.self, forKey: .addressLine2)
        
        if let subTitle = try container.decode(String?.self, forKey: .subTitle),
            subTitle.count > 0 {
            self.subTitle = subTitle
        }
        
        self.price = try container.decode(UInt32.self, forKey: .price)
        
        if let squareFootage = try container.decode(UInt32?.self, forKey: .squareFootage) {
            self.squareFootage = squareFootage
        }
        if let beds = try container.decode(UInt8?.self, forKey: .beds) {
            self.beds = beds
        }
        if let baths = try container.decode(UInt8?.self, forKey: .baths) {
            self.baths = baths
        }
        if let halfBaths = try container.decode(UInt8?.self, forKey: .halfBaths) {
            self.halfBaths = halfBaths
        }
        self.isFavorited = try container.decode(Bool.self, forKey: .isFavorited)
        self.propertyType = try container.decode(PropertyType.self, forKey: .propertyType)
        
    }
}
