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
    
    var mockFiltersService : MockFiltersService!
    
    override func setUp() {
        mockFiltersService = MockFiltersService()
    }

    func testBasicFetchContainsAllTypes() {
        let filtersVM = FiltersViewModel(filtersService: mockFiltersService)
        XCTAssert(filtersVM.propertyTypeFilters.count == 0)
        filtersVM.fetch()
        
        let allPropertyTypes = PropertyType.allCases
        assertFiltersVmContainsPropertyTypes(filtersVM: filtersVM, propertyType: allPropertyTypes)
    }
    
    func testUpdateSelectedPropertyTypes() {
        let filtersVM = FiltersViewModel(filtersService: mockFiltersService)
        XCTAssert(filtersVM.propertyTypeFilters.count == 0)
        filtersVM.updateSelectedPropertyTypes(selectedIndices: [0,1])
        
        let propertyTypes = Array(PropertyType.allCases[0...1])
        assertFiltersVmContainsPropertyTypes(filtersVM: filtersVM, propertyType: propertyTypes)
    }
    
    func testUpdateSelectedPropertyTypesChanged() {
        let filtersVM = FiltersViewModel(filtersService: mockFiltersService)
        XCTAssert(filtersVM.propertyTypeFilters.count == 0)
        filtersVM.updateSelectedPropertyTypes(selectedIndices: [0,1])
        filtersVM.updateSelectedPropertyTypes(selectedIndices: [1,2,4])
        
        let propertyTypes = [PropertyType.allCases[1], PropertyType.allCases[2], PropertyType.allCases[4]]
        assertFiltersVmContainsPropertyTypes(filtersVM: filtersVM, propertyType: propertyTypes)
    }
    
    func testUpdateSelectedPropertyTypesChangedToNone() {
           let filtersVM = FiltersViewModel(filtersService: mockFiltersService)
           XCTAssert(filtersVM.propertyTypeFilters.count == 0)
           filtersVM.updateSelectedPropertyTypes(selectedIndices: [0,1])
           filtersVM.updateSelectedPropertyTypes(selectedIndices: [])
           
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
