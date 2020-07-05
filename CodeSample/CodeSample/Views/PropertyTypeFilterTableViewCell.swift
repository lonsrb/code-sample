//
//  FilterTableViewCell.swift
//  CodeSample
//
//  Created by Ryan Lons on 7/5/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//

import UIKit

class PropertyTypeFilterTableViewCell: UITableViewCell {
    
    var viewModel : PropertyTypeFilterViewModel? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupWithViewModel(viewModel : PropertyTypeFilterViewModel) {
        self.textLabel?.text = viewModel.propertyTypeString
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
