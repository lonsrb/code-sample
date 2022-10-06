//
//  FiltersService.swift
//  CodeSample
//
//  Created by Ryan Lons on 7/6/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//

import Foundation

protocol FiltersServiceProtocol {
    func saveFilter(propertyTypes: [PropertyType])
    func getFilter() -> [PropertyType]
}

//this service is saving data locally in user defaults
//the reason its extracted out is so it could be switched
//to a GraphQL or REST implementation and the consuming code
//would need minimal refactoring
class FiltersService : FiltersServiceProtocol{
    
    private let propertyTypeKey = "PropertyType"
    
    func saveFilter(propertyTypes: [PropertyType]) {
        let rawValueArray = propertyTypes.map { $0.rawValue }
        UserDefaults.standard.set(rawValueArray, forKey: propertyTypeKey)
    }
    
    func getFilter() -> [PropertyType] {
        guard let propertyTypes = UserDefaults.standard.value(forKey: propertyTypeKey) as? [PropertyType.RawValue] else {
            return []
        }
        return propertyTypes.map { PropertyType(rawValue: $0)! }
    }
}
