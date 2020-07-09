//
//  MockFiltersService.swift
//  CodeSampleTests
//
//  Created by Ryan Lons on 7/8/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//


@testable import CodeSample

class MockFiltersService : FiltersServiceProtocol {
    func saveFilter(propertyTypes: [PropertyType]) {
        
    }
    
    func getFilter() -> [PropertyType] {
        return []
    }
}
