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
    private let listingsService : ListingsService!
    
    var propertyTypeFilter : [PropertyType]?
    var fetchInProgress = false
    var addedListingsStartIndex = 0
    
    init() {
        listingsService = ListingsService(networkingService: NetworkingService.shared)
        propertyTypeFilter = FiltersService.shared.getFilter()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(filtersChanged(notification:)),
                                               name: Notification.Name.FiltersUpdated, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func filtersChanged(notification : Notification) {
        guard let userInfo = notification.userInfo else {
            assertionFailure("for this notification, there should always be a userinfo object with a propertyTypes key")
            return
        }
        
        let newPropertyTypeFilters = userInfo["propertyTypes"] as? [PropertyType]
        addedListingsStartIndex = 0
        propertyTypeFilter = newPropertyTypeFilters
        fetch()
    }

    func fetch(getNextPage: Bool = false) {
        guard !fetchInProgress else {
            //make sure we dont already have a fetch in progress
            return
        }
        
        fetchInProgress = true
        let startIndex = getNextPage ? listings.count : 0
        
        listingsService.getListings(startIndex: startIndex, propertyTypeFilter: propertyTypeFilter) { [weak self] (result) in
            guard let self = self else {return}
            
            switch result {
            case .success(let listingViewModels):
                let newListings = listingViewModels.map {ListingViewModel(listing: $0) }
                if getNextPage {
                    self.listings.append(contentsOf: newListings)
                }
                else {
                    self.listings = newListings
                }
                self.addedListingsStartIndex = startIndex
            case .failure(let error):
                print(error.localizedDescription)
                //we have failed to get listings from the server. for now we'll just print this
                //but we should note it in analytics and possibly raise a visual error to the screen
            }
            
            //prevent duplicate fetch calls during infinite scroll
            self.fetchInProgress = false
        }
    }
}
