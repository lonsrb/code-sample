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
    
    @Published var subtitleString : String?
    @Published var priceString : String?
    @Published var addressLine1String : String?
    @Published var addressLine2String : String?
    @Published var bathsString : String?
    @Published var bedsString : String?
    @Published var sqFtString : String?
    @Published var thumbnailImage : UIImage?
    @Published var propertyTypeString : String?
    
    private(set) var listing: Listing?
    
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
        
        update()
    }
    
    func update() {
        guard let listing = listing else { return }
        propertyTypeString = listing.propertyType.presentationString()
        subtitleString = listing.subTitle
        priceString = currenyFormmatter.string(from: NSNumber(integerLiteral: Int(listing.price)))
        addressLine1String = listing.address
        addressLine2String = listing.addressLine2
        
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
        
        guard let url = URL(string: listing.thumbUrl) else {
            print("no url for: \(listing.thumbUrl)")
            return
        }
        
        //TODO: move this into the Network Serivice
        DispatchQueue.global().async {
            //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            guard let data = try? Data(contentsOf: url) else {
                //should use a placeholder image here
                return
            }
            
            DispatchQueue.main.async {
                self.thumbnailImage = UIImage(data: data)
            }
        }
        
    }
    
    
}
