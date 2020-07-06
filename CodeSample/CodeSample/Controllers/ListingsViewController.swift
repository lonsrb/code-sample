//
//  ListingsViewController.swift
//  CodeSample
//
//  Created by Ryan Lons on 7/4/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//

import UIKit
import Combine

class ListingsViewController: UIViewController {
    
    @IBOutlet weak var listingsTableView: UITableView!
    var listingsViewModel : ListingsViewModel?
    private var cancellables: Set<AnyCancellable> = []

    @IBOutlet weak var filtersButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listingsTableView.tableFooterView = UIView()
        listingsViewModel = ListingsViewModel()
        bindViewModel(viewModel: listingsViewModel!)
        listingsViewModel!.fetch()
        
        filtersButton.layer.borderColor = UIColor.codeSampleGrayBorder().cgColor
        filtersButton.layer.borderWidth = 1
        
        //todo: add tests
        //todo: add pull to refresh
        //todo: add paging
        //todo: POST favorite change
        
    }
    
    private func bindViewModel(viewModel : ListingsViewModel) {
        viewModel.$listings.sink { [weak self] listings in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.listingsTableView.reloadData()
            }
           }.store(in: &cancellables)
       }
}

extension ListingsViewController :  UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let listingsViewModel = listingsViewModel else { return 0 }
        return listingsViewModel.listings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListingCell",
                                                       for: indexPath) as? ListingTableViewCell,
            let listingsViewModel = listingsViewModel else {
            return UITableViewCell()
        }
        
        cell.fillWithListing(listingViewModel: listingsViewModel.listings[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    
}

