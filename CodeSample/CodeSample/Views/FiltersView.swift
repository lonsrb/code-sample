//
//  FiltersView.swift
//  CodeSample
//
//  Created by Ryan Lons on 9/30/22.
//  Copyright © 2022 Ryan Lons. All rights reserved.
//
import SwiftUI

struct Filters: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = FiltersViewModel(filtersService: ApplicationConfiguration.shared.filtersService)
    
    var body: some View {
        NavigationView {
            List {
                Section("Property Types") {
                    ForEach(viewModel.propertyTypeFilters, id:\.propertyTypeString) { filter in
                        HStack {
                            if viewModel.selectedFilters.contains(filter.propertyType) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color(.systemBlue))
                            }
                            else {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(Color(.systemBlue))
                            }
                            Text(filter.propertyTypeString)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if viewModel.selectedFilters.contains(filter.propertyType) {
                                viewModel.selectedFilters.remove(filter.propertyType)
                            }
                            else {
                                viewModel.selectedFilters.insert(filter.propertyType)
                            }
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Filters", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        viewModel.persistSelectedFilters()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .onAppear() {
                viewModel.fetch()
            }
        }
    }
}
