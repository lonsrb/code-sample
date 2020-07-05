//
//  PropertyTypeFilterViewModel.swift
//  CodeSample
//
//  Created by Ryan Lons on 7/5/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//

import Foundation

class PropertyTypeFilterViewModel {
    private var propertyType: PropertyType
    
    var propertyTypeString : String!
    var isSelected: Bool!
    
    init(propertyType : PropertyType) {
        self.propertyType = propertyType
        propertyTypeString = propertyType.rawValue
        isSelected = false
    }
}
