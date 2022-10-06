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
            ScrollViewReader { scrollViewReader in
                List {
                    ForEach(viewModel.listings, id:\.id) { listingViewModel in
                        ListRow(listingViewModel: listingViewModel)
                            .listRowInsets(EdgeInsets())
                            .id(listingViewModel.id)
                    }
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle("", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            showingFilters.toggle()
                        } label: {
                            Text("Filters")
                                .padding(EdgeInsets(top: 3, leading: 7, bottom: 3, trailing: 7))
                                .border(Color.codeSampleGrayBorder(), width: 1)
                        }
                        
                        .fullScreenCover(isPresented: $showingFilters) {
                            Filters()
                        }
                    }
                }
                .onReceive(viewModel.$shouldScrollToTop) { shouldScroll in
                    if shouldScroll, let listViewModel: ListingViewModel = viewModel.listings.first {
                        scrollViewReader.scrollTo(listViewModel.id, anchor: .top)
                    }
                }
            }//ends scroll reader
            
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

