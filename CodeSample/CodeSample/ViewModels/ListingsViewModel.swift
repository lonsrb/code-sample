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
    
    var propertyTypeFilter : [PropertyType]? //= [.house]
    var fetchInProgress = false
    var addedListingsStartIndex = 0
    
    init() {
        listingsService = ListingsService(networkingService: NetworkingService.shared)
    }

    func fetch(getNextPage: Bool = false) {
        fetchInProgress = true
        let startIndex = getNextPage ? listings.count : 0
        
        listingsService.getListings(startIndex: startIndex, propertyTypeFilter: propertyTypeFilter) { [weak self] (result) in
            guard let self = self else {return}
            
            switch result {
            case .success(let listingViewModels):
                let newListings = listingViewModels.map({ (listing) -> ListingViewModel in
                    ListingViewModel(listing: listing)
                })
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
        
        
//        listings = ListingsService.tempGetDummyListings().map({ (listing) -> ListingViewModel in
//            ListingViewModel(listing: listing)
//        })
//        print(listings)
    }
}
