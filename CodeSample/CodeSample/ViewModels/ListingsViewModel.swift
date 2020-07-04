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

    func fetch() {
        listings = ListingsService.tempGetDummyListings().map({ (listing) -> ListingViewModel in
            ListingViewModel(listing: listing)
        })
        print(listings)
    }
}
