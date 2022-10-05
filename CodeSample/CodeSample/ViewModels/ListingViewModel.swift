//
//  ListingViewModel.swift
//  CodeSample
//
//  Created by Ryan Lons on 7/4/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//

import Foundation
import Combine
import UIKit.UIImage

@MainActor class ListingViewModel : ObservableObject, Identifiable {
    var subtitleString : String?
    var priceString : String?
    var addressLine1String : String?
    var addressLine2String : String?
    var bathsString : String?
    var bedsString : String?
    var sqFtString : String?
    @Published var thumbnailImage: UIImage = UIImage(named: "NoImagePlaceholder")!
    var propertyTypeString : String?
    var isFavorite : Bool = false
    
    private(set) var listing: Listing
    
    private var currenyFormmatter : NumberFormatter!
    private var sqFootageFormatter : NumberFormatter!
    private var listingsService : ListingsServiceProtocol!
    
    
    init(listing : Listing, listingsService : ListingsServiceProtocol) {
        self.listing = listing
        self.listingsService = listingsService
        
        currenyFormmatter = NumberFormatter()
        currenyFormmatter.usesGroupingSeparator = true
        currenyFormmatter.numberStyle = .currency
        currenyFormmatter.locale = Locale.current
        currenyFormmatter.maximumFractionDigits = 0
        
        sqFootageFormatter = NumberFormatter()
        sqFootageFormatter.usesGroupingSeparator = true
        sqFootageFormatter.numberStyle = .decimal
        sqFootageFormatter.locale = Locale.current
        
        populateCell()
    }
    
    func populateCell() {
        propertyTypeString = listing.propertyType.presentationString()
        subtitleString = listing.subTitle
        priceString = currenyFormmatter.string(from: NSNumber(integerLiteral: Int(listing.price)))
        addressLine1String = listing.address
        addressLine2String = listing.addressLine2
        isFavorite = listing.isFavorited
        
        if let beds = listing.beds {
            bedsString = "\(beds)"
        }
        else {
            bedsString = "--"
        }
        
        if let sqFt = listing.squareFootage,
            let formattedString = sqFootageFormatter.string(from: NSNumber(integerLiteral: Int(sqFt))){
            sqFtString = formattedString
        }
        else {
            sqFtString = "--"
        }
        
        if let fullBaths = listing.baths {
            bathsString = "\(fullBaths)"
            if let halfBaths = listing.halfBaths, halfBaths > 0 {
                if halfBaths == 1 {
                    bathsString! += ".5"
                }
                else { //can you have more than one half bath? and if so, how to represent??
                    bathsString! += "f, \(halfBaths)h"
                }
            }
        }
        else if let halfBaths = listing.halfBaths {
            bathsString = "\(halfBaths) half"
        }
        else {
            bathsString = "--"
        }
    }
    
    @MainActor func loadImage() async -> UIImage {
        do {
            self.thumbnailImage = try await listingsService.loadListingImage(thumbnailURL: listing.thumbUrl)
        }
        catch {
            print("Error loading image: \(error.localizedDescription)")
            //for now just print the error, ideally we'd have
            //analytics to track these internal kinds of errors
        }
        return self.thumbnailImage
    }
    
    func toogleFavoriteStatus() {
        
        listing.isFavorited = !listing.isFavorited
        isFavorite = listing.isFavorited
        
        listingsService.favoriteListing(listingId: listing.id,
                                        isFavorite: listing.isFavorited) { (result) in
                                            switch result {
                                            case .success(()):
                                                print("toggle favorite success")
                                                break
                                            case .failure(let error):
                                                print("ERROR: while toggling favorite state:\(error.localizedDescription)")
                                                break
                                            }
        }
    }
}
