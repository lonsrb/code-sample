//
//  ListingTableViewCell.swift
//  CodeSample
//
//  Created by Ryan Lons on 7/4/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//

import UIKit
import Combine

class ListingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var listingThumbnail: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressLine1Label: UILabel!
    @IBOutlet weak var addressLine2Label: UILabel!
    
    @IBOutlet weak var subtitleTag: UIButton!
    @IBOutlet weak var numberOfBedsLabel: UILabel!
    @IBOutlet weak var numberOfBathsLabel: UILabel!
    @IBOutlet weak var squareFootageLabel: UILabel!
    
    private var cancellables: Set<AnyCancellable> = []

    
    var listingViewModel : ListingViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        favoriteButton.layer.borderWidth = 1
        favoriteButton.layer.borderColor = UIColor.codeSampleGrayBorder().cgColor
        favoriteButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        subtitleTag.contentEdgeInsets = UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 7)
        subtitleTag.isHidden = true
        
        let gradient = CAGradientLayer()
        gradient.frame = listingThumbnail.bounds
        gradient.colors = [UIColor.clear.cgColor,
                           UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.7).cgColor]
        gradient.locations = [0.4, 1.0]
        listingThumbnail.layer.addSublayer(gradient)
    }
    
    func fillWithListing(listingViewModel : ListingViewModel) {
        
        self.listingViewModel = listingViewModel
        
        listingViewModel.$thumbnailImage.sink { [weak self] image in
            guard let self = self else { return }
            self.listingThumbnail.image = image
        }.store(in: &cancellables)
        
        priceLabel.text = listingViewModel.priceString
        
        if listingViewModel.subtitleString != nil && listingViewModel.subtitleString!.count > 0 {
            subtitleTag.isHidden = false
            subtitleTag.setTitle(listingViewModel.subtitleString?.uppercased(), for: .normal)
        }
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
