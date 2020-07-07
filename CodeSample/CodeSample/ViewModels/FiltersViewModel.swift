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
    
    func updateSelectedPropertyTypes(selectedIndices: [Int]) {
        
        let selectedPropertyTypes = selectedIndices.map { PropertyType.allCases[$0] }
        FiltersService.shared.saveFilter(propertyTypes: selectedPropertyTypes)
        
        NotificationCenter.default.post(name: NSNotification.Name.FiltersUpdated,
                                        object: nil,
                                        userInfo: ["propertyTypes" : selectedPropertyTypes])
    }
    
    func fetch() {
        var propertyTypeFilters = [PropertyTypeFilterViewModel]()
        let selectedPropertyTypes = FiltersService.shared.getFilter()
        
        for propertyType in PropertyType.allCases {
            let viewModel = PropertyTypeFilterViewModel(propertyType: propertyType)
            if selectedPropertyTypes.contains(propertyType) {
                viewModel.isSelected = true
            }
            propertyTypeFilters.append(viewModel)
        }
        self.propertyTypeFilters = propertyTypeFilters
    }
}
