//
//  PropertyType.swift
//  CodeSample
//
//  Created by Ryan Lons on 7/4/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//

enum PropertyType : String, Codable, CaseIterable {
    case house
    case condo
    case townhouse
    case multiFamily
    case land
    
    
    func presentationString() -> String {
        switch self {
        case .house:
            return "House"
        case .condo:
            return "Condo"
        case .townhouse:
            return "Townhouse"
        case .multiFamily:
            return "Multi-Family"
        case .land:
            return "Lot/Land"
        }
    }
    
//    enum CodingKeys : String, CodingKey {
//        case house = "house"
//        case condo = "condo"
//        case townhouse = "townhouse"
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        if let _ = try container.decode(String?.self, forKey: .house) {
//            self = .house
//        }
//        else {
//            self = .multiFamily
//        }
//        
//    }
//    
}

