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
    var currentPage = 0
    var propertyTypeFilter : [PropertyType]? //= [.house]
    
    init() {
        listingsService = ListingsService(networkingService: NetworkingService.shared)
    }

    func fetch() {
        listingsService.getListings(page: currentPage, propertyTypeFilter: propertyTypeFilter) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let listings):
                self.listings = listings.map({ (listing) -> ListingViewModel in
                                                ListingViewModel(listing: listing)
                                            })
            case .failure(let error):
                print(error.localizedDescription)
                //we have failed to get listings from the server. for now we'll just print this
                //but we should note it in analytics and possibly raise a visual error to the screen
            }
        }
        
        
//        listings = ListingsService.tempGetDummyListings().map({ (listing) -> ListingViewModel in
//            ListingViewModel(listing: listing)
//        })
//        print(listings)
    }
}
