//
//  PropertyType.swift
//  CodeSample
//
//  Created by Ryan Lons on 7/4/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//

enum PropertyType : String, Codable, CaseIterable {
    case house = "House"
    case condo = "Condo"
    case townhouse = "Townhouse"
    case multiFamily = "Multi-Family"
    case land = "Lot/Land"
}
