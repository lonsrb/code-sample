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
    @Published var listings: [ListingViewModel] = []
    @Published var shouldScrollToTop: Bool = false
    
    var propertyTypeFilter : [PropertyType]?
    var fetchInProgress = false
    var addedListingsStartIndex = 0
    
    var listingService : ListingsServiceProtocol!
    var filtersService : FiltersServiceProtocol!
    
    private var cancellables = Set<AnyCancellable>()
    
    init(listingService : ListingsServiceProtocol, filtersService: FiltersServiceProtocol) {
        self.listingService = listingService
        propertyTypeFilter = filtersService.getFilter()
        
        listingService.listingsSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] listingModels in
                guard let self = self else { return }
                let newListings = listingModels.map { ListingViewModel(listing: $0, listingsService: self.listingService) }
                Just(true).assign(to: &self.$shouldScrollToTop)
                Just(newListings).assign(to: &self.$listings)
            })
            .store(in: &cancellables)
    }

    @MainActor func fetch(getNextPage: Bool = false) async {
        guard !fetchInProgress else {
            //make sure we dont already have a fetch in progress
            return
        }
        
        fetchInProgress = true
        let startIndex = getNextPage ? listings.count : 0
        _ = await listingService.getListings(startIndex: startIndex, propertyTypeFilter: propertyTypeFilter)
        
        
        //todo figure inifinte scroll now that we're using a publisher
//        let listingModels = await listingService.getListings(startIndex: startIndex, propertyTypeFilter:
        
//        let startIndex = getNextPage ? listings.count : 0
//
//        let listingModels = await listingService.getListings(startIndex: startIndex, propertyTypeFilter: propertyTypeFilter)
//        let newListings = listingModels.map { ListingViewModel(listing: $0, listingsService: self.listingService) }
//        if getNextPage {
//            self.listings.append(contentsOf: newListings)
//        }
//        else {
//            self.listings = newListings
//        }
        
        self.fetchInProgress = false
    }
}
