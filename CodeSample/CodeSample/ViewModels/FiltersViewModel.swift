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
    private var filtersService : FiltersServiceProtocol!
    
    init(filtersService : FiltersServiceProtocol) {
        self.filtersService = filtersService
    }
    
    func updateSelectedPropertyTypes(selectedIndices: [Int]) {
        
        let selectedPropertyTypes = selectedIndices.map { PropertyType.allCases[$0] }
        let currentProptertyTypes = filtersService.getFilter()
        
        if currentProptertyTypes.elementsEqual(selectedPropertyTypes) {
            print("filters didn't really change")
            return
        }
        
        filtersService.saveFilter(propertyTypes: selectedPropertyTypes)
        fetch()
        NotificationCenter.default.post(name: NSNotification.Name.FiltersUpdated,
                                        object: nil,
                                        userInfo: ["propertyTypes" : selectedPropertyTypes])
    }
    
    func fetch() {
        var propertyTypeFilters = [PropertyTypeFilterViewModel]()
        let selectedPropertyTypes = filtersService.getFilter()
        
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
