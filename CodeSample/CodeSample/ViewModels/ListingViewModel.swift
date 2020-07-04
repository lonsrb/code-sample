//
//  ListingViewModel.swift
//  CodeSample
//
//  Created by Ryan Lons on 7/4/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//

import Foundation
import Combine

class ListingViewModel : ObservableObject, Identifiable {
    
    @Published var subtitleString : String?
    @Published var priceString : String?
    @Published var addressLine1String : String?
    @Published var addressLine2String : String?
    @Published var bathsString : String?
    @Published var bedsString : String?
    @Published var sqFtString : String?
    
    private(set) var listing: Listing?
    
    private var currenyFormmater : NumberFormatter!
    
    init(listing : Listing) {
        self.listing = listing
        
        currenyFormmater = NumberFormatter()
        currenyFormmater.usesGroupingSeparator = true
        currenyFormmater.numberStyle = .currency
        currenyFormmater.locale = Locale.current
        update()
    }
    
    func update() {
        guard let listing = listing else { return }
        
        subtitleString = listing.subTitle
        priceString = currenyFormmater.string(from: NSNumber(integerLiteral: Int(listing.price)))
        addressLine1String = listing.address
        addressLine2String = listing.addressLine2
        
        if let beds = listing.beds {
            bedsString = "\(beds)"
        }
        else {
            bedsString = "--"
        }
        
        if let sqFt = listing.squareFootage {
            sqFtString = "\(sqFt)"
        }
        else {
            sqFtString = "--"
        }
        
        if let fullBaths = listing.baths {
            bathsString = "\(fullBaths)"
            if let halfBaths = listing.halfBaths {
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
    
    
}
