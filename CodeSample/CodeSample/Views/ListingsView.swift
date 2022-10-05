//
//  ListingsView.swift
//  CodeSample
//
//  Created by Ryan Lons on 9/30/22.
//  Copyright © 2022 Ryan Lons. All rights reserved.
//

import Foundation
import SwiftUI

struct Listings: View {
    @State private var showingFilters = false
    @StateObject private var viewModel = ListingsViewModel(listingService: ApplicationConfiguration.shared.listingsService,
                                                           filtersService: ApplicationConfiguration.shared.filtersService)
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.listings, id:\.id) { listingViewModel in
                    ListRow(listingViewModel: listingViewModel)
                        .listRowInsets(EdgeInsets())
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Filters") {
                        showingFilters.toggle()
                    }
                    .fullScreenCover(isPresented: $showingFilters) {
                        Filters()
                    }
                }
            }
        }
        .task {
            await viewModel.fetch()
        }
    }
}

struct Listings_Previews: PreviewProvider {
    static var previews: some View {
        Listings()
    }
}

