//
//  FiltersViewModel.swift
//  CodeSample
//
//  Created by Ryan Lons on 7/5/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//

import Foundation

class FiltersViewModel: ObservableObject {
    @Published var propertyTypeFilters = [PropertyTypeFilterViewModel]()
    @Published var selectedFilters = Set<PropertyType>()
    
    private var filtersService: FiltersServiceProtocol!
    private var listingsService: ListingsServiceProtocol!
    
    init(filtersService: FiltersServiceProtocol, listingsService: ListingsServiceProtocol) {
        self.filtersService = filtersService
        self.listingsService = listingsService
    }
    
    func persistSelectedFilters() {
        let selectedPropertyTypes = selectedFilters.map { $0 }//converts set to array
        let currentProptertyTypes = filtersService.getFilter()
        
        if currentProptertyTypes.elementsEqual(selectedPropertyTypes) {
            print("filters didn't really change")
            return
        }
        
        filtersService.saveFilter(propertyTypes: selectedPropertyTypes)
        fetch()
        
        Task {
            print("filters say get new listings")
            _ = await listingsService.getListings(startIndex: 0, propertyTypeFilter: selectedPropertyTypes)
        }
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
        selectedFilters = Set(self.propertyTypeFilters.compactMap { $0.isSelected ? $0.propertyType : nil })
    }
}
