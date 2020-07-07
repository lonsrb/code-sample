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

class ListingViewModel : ObservableObject, Identifiable {
    
    var subtitleString : String?
    var priceString : String?
    var addressLine1String : String?
    var addressLine2String : String?
    var bathsString : String?
    var bedsString : String?
    var sqFtString : String?
    @Published var thumbnailImage : UIImage?
    var propertyTypeString : String?
    var isFavorite : Bool = false
    
    private(set) var listing: Listing
    
    private var currenyFormmatter : NumberFormatter!
    private var sqFootageFormatter : NumberFormatter!
    
    init(listing : Listing) {
        self.listing = listing
        
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
      
        let listingService = ListingsService(networkingService: NetworkingService.shared)
        listingService.loadListingImage(thumbnailURL: listing.thumbUrl) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                self.thumbnailImage = image
                break
            case .failure(let error):
                print("Error loading image: \(error.localizedDescription)")
                //for now just print the error, ideally we'd have
                //analytics to track these internal kinds of errors
                break
            }
        }
    }
    
    func toogleFavoriteStatus() {
        
        listing.isFavorited = !listing.isFavorited
        isFavorite = listing.isFavorited
        
        let listingService = ListingsService(networkingService: NetworkingService.shared)
        listingService.favoriteListing(listingId: listing.id,
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
