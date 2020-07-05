//
//  FiltersViewModel.swift
//  CodeSample
//
//  Created by Ryan Lons on 7/5/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//

import Foundation
class FiltersViewModel {
    @Published private(set) var propertyTypeFilters = [PropertyTypeFilterViewModel]()

    func fetch() {
        var propertyTypeFilters = [PropertyTypeFilterViewModel]()
        for propertyType in PropertyType.allCases {
            propertyTypeFilters.append(PropertyTypeFilterViewModel(propertyType: propertyType))
        }
        self.propertyTypeFilters = propertyTypeFilters
    }
}
