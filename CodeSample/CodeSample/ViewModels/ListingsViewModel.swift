//
//  ListingsViewModel.swift
//  CodeSample
//
//  Created by Ryan Lons on 7/4/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//

import Foundation
import Combine

class ListingsViewModel: ObservableObject  {
    @Published private(set) var listings: [ListingViewModel] = []
    
    var propertyTypeFilter : [PropertyType]?
    var fetchInProgress = false
    var addedListingsStartIndex = 0
    
    var listingService : ListingsServiceProtocol!
    var filtersService : FiltersServiceProtocol!
    
    init(listingService : ListingsServiceProtocol, filtersService: FiltersServiceProtocol) {
        self.listingService = listingService
        propertyTypeFilter = filtersService.getFilter()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(filtersChanged(notification:)),
                                               name: Notification.Name.FiltersUpdated, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @MainActor @objc func filtersChanged(notification : Notification) async {
        guard let userInfo = notification.userInfo else {
            assertionFailure("for this notification, there should always be a userinfo object with a propertyTypes key")
            return
        }
        
        let newPropertyTypeFilters = userInfo["propertyTypes"] as? [PropertyType]
        addedListingsStartIndex = 0
        propertyTypeFilter = newPropertyTypeFilters
        await fetch()
    }

    @MainActor func fetch(getNextPage: Bool = false) async {
        guard !fetchInProgress else {
            //make sure we dont already have a fetch in progress
            return
        }
        
        fetchInProgress = true
        let startIndex = getNextPage ? listings.count : 0
        
        let listingModels = await listingService.getListings(startIndex: startIndex, propertyTypeFilter: propertyTypeFilter)
        let newListings = listingModels.map { ListingViewModel(listing: $0, listingsService: self.listingService) }
        if getNextPage {
            self.listings.append(contentsOf: newListings)
        }
        else {
            self.listings = newListings
        }
        self.fetchInProgress = false
    }
}
