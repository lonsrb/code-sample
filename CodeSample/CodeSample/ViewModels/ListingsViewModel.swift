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
    private var loadingNextPage = false
    
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
                if !self.loadingNextPage {
                    Just(true).assign(to: &self.$shouldScrollToTop)
                }
                Just(newListings).assign(to: &self.$listings)
                self.loadingNextPage = false
                self.fetchInProgress = false
            })
            .store(in: &cancellables)
    }
    
    func loadNextPageIfNeeded(currentItem item: ListingViewModel) {
        guard !fetchInProgress else {
            //make sure we dont already have a fetch in progress
            return
        }
        
        let index = listings.firstIndex { vm in
            vm.id == item.id
        }
        guard let listingIndex = index else { return }
        
        let distanceFromEndOfList = (listings.count - listingIndex) - 1
        if distanceFromEndOfList <= 5 {
            loadingNextPage = true
            fetch(getNextPage: true)
        }
    }
    
    func fetch(getNextPage: Bool = false) {
        guard !fetchInProgress else {
            //make sure we dont already have a fetch in progress
            return
        }
        loadingNextPage = getNextPage
        fetchInProgress = true
        let startIndex = getNextPage ? listings.count : 0
        Task {
            await listingService.getListings(startIndex: startIndex, propertyTypeFilter: propertyTypeFilter)
        }
    }
}
