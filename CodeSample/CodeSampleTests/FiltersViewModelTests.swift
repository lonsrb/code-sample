//
//  FiltersViewModelTests.swift
//  CodeSampleTests
//
//  Created by Ryan Lons on 7/7/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//

import XCTest
@testable import CodeSample

class FiltersViewModelTests: XCTestCase {
    
    var mockFiltersService: MockFiltersService!
    var mockListingsService: MockListingsService!
    
    override func setUp() {
        mockFiltersService = MockFiltersService()
        mockListingsService = MockListingsService()
    }
    
    func testBasicFetchContainsAllTypes() {
        let filtersVM = FiltersViewModel(filtersService: mockFiltersService, listingsService: mockListingsService)
        XCTAssert(filtersVM.propertyTypeFilters.count == 0)
        filtersVM.fetch()
        
        let allPropertyTypes = PropertyType.allCases
        assertFiltersVmContainsPropertyTypes(filtersVM: filtersVM, propertyType: allPropertyTypes)
    }
    
    func testUpdateSelectedPropertyTypes() {
        let filtersVM = FiltersViewModel(filtersService: mockFiltersService, listingsService: mockListingsService)
        XCTAssert(filtersVM.propertyTypeFilters.count == 0)
        
        let propertyTypes = Array(PropertyType.allCases[0...1])
        
        filtersVM.selectedFilters = Set(propertyTypes)
        filtersVM.persistSelectedFilters()
        
        assertFiltersVmContainsPropertyTypes(filtersVM: filtersVM, propertyType: propertyTypes)
    }
    
    func testUpdateSelectedPropertyTypesChanged() {
        let filtersVM = FiltersViewModel(filtersService: mockFiltersService, listingsService: mockListingsService)
        XCTAssert(filtersVM.propertyTypeFilters.count == 0)
        
        var propertyTypes = [PropertyType.allCases[0], PropertyType.allCases[1]]
        filtersVM.selectedFilters = Set(propertyTypes)
        filtersVM.persistSelectedFilters()
        
        propertyTypes = [PropertyType.allCases[1], PropertyType.allCases[2], PropertyType.allCases[4]]
        filtersVM.selectedFilters = Set(propertyTypes)
        filtersVM.persistSelectedFilters()
        
        //        filtersVM.updateSelectedPropertyTypes(selectedIndices: [0,1])
        //        filtersVM.updateSelectedPropertyTypes(selectedIndices: [1,2,4])
        
        assertFiltersVmContainsPropertyTypes(filtersVM: filtersVM, propertyType: propertyTypes)
    }
    
    func testUpdateSelectedPropertyTypesChangedToNone() {
        let filtersVM = FiltersViewModel(filtersService: mockFiltersService, listingsService: mockListingsService)
        XCTAssert(filtersVM.propertyTypeFilters.count == 0)
        
        let propertyTypes = [PropertyType.allCases[0], PropertyType.allCases[1]]
        filtersVM.selectedFilters = Set(propertyTypes)
        filtersVM.persistSelectedFilters()
        
        filtersVM.selectedFilters = Set(propertyTypes)
        filtersVM.persistSelectedFilters()
        
        //           filtersVM.updateSelectedPropertyTypes(selectedIndices: [0,1])
        //           filtersVM.updateSelectedPropertyTypes(selectedIndices: [])
        
        assertFiltersVmContainsPropertyTypes(filtersVM: filtersVM, propertyType: [])
    }
    
    func assertFiltersVmContainsPropertyTypes(filtersVM : FiltersViewModel, propertyType : [PropertyType]) {
        var propertyStrings = propertyType.map { $0.presentationString() }
        for filterViewModel in filtersVM.propertyTypeFilters {
            if let index = propertyStrings.firstIndex(of: filterViewModel.propertyTypeString) {
                propertyStrings.remove(at: index)
            }
        }
        XCTAssert(propertyStrings.count == 0, "filtersVM did not have the correct number and type of property types ")
    }
}
