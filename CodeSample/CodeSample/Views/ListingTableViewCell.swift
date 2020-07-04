//
//  ListingTableViewCell.swift
//  CodeSample
//
//  Created by Ryan Lons on 7/4/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//

import UIKit

class ListingTableViewCell: UITableViewCell {

    @IBOutlet weak var listingThumbnail: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressLine1Label: UILabel!
    @IBOutlet weak var addressLine2Label: UILabel!
    
    @IBOutlet weak var numberOfBedsLabel: UILabel!
    @IBOutlet weak var numberOfBathsLabel: UILabel!
    @IBOutlet weak var squareFootageLabel: UILabel!
    
    var listingViewModel : ListingViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func fillWithListing(listingViewModel : ListingViewModel) {
        self.listingViewModel = listingViewModel
        priceLabel.text = listingViewModel.priceString
        subtitleLabel.text = listingViewModel.subtitleString
        addressLine1Label.text = listingViewModel.addressLine1String
        addressLine2Label.text = listingViewModel.addressLine2String
        numberOfBedsLabel.text = listingViewModel.bedsString
        numberOfBathsLabel.text = listingViewModel.bathsString
        squareFootageLabel.text = listingViewModel.sqFtString
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
