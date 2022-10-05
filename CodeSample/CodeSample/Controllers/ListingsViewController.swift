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
    var listingsViewModel : ListingsViewModel!
    private let refreshControl = UIRefreshControl()
    
    private var cancellables: Set<AnyCancellable> = []
    
    @IBOutlet weak var filtersButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        listingsViewModel = ListingsViewModel(listingService: ApplicationConfiguration.shared.listingsService,
//                                              filtersService: ApplicationConfiguration.shared.filtersService)
//        bindViewModel(viewModel: listingsViewModel!)
//        listingsViewModel!.fetch()
//
//        refreshControl.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
//        listingsTableView.refreshControl = refreshControl
//
//        listingsTableView.tableFooterView = UIView()
//
//        filtersButton.layer.borderColor = UIColor.codeSampleGrayBorder().cgColor
//        filtersButton.layer.borderWidth = 1
        
        //todo: add tests
    }
    
    @objc private func pullToRefresh(_ sender : Any){
//        listingsViewModel?.fetch()
    }
    
    private func bindViewModel(viewModel : ListingsViewModel) {
        viewModel.$listings.sink { [weak self] listings in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                defer {
                    self.refreshControl.endRefreshing()
                }
                
                let newCellsStartIndex = self.listingsViewModel.addedListingsStartIndex
                
                //if start index is equal to zero then we're not adding new cells to existing dataset
                if newCellsStartIndex == 0 {
                    self.setupTable()
                    return
                }
                
                //if the index for new cells is greater than the total dataset,
                //then there are no more cells to inifite load
                let lastListingIndex = (listings.count-1)
                guard newCellsStartIndex < lastListingIndex else {
                    return
                }
                
                //create an array of index paths to be inserted into table
                var newIndexPathArray = [IndexPath]()
                for i in newCellsStartIndex...lastListingIndex {
                    newIndexPathArray.append(IndexPath(row: i, section: 0))
                }
                self.listingsTableView.beginUpdates()
                self.listingsTableView.insertRows(at: newIndexPathArray, with: .none)
                self.listingsTableView.endUpdates()
            }
        }.store(in: &cancellables)
    }
    
    func setupTable() {
        self.listingsTableView.reloadData()
        if self.listingsViewModel.listings.count > 0 {
            self.listingsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
    
}


extension ListingsViewController :  UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listingsViewModel.listings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListingCell",
                                                       for: indexPath) as? ListingTableViewCell else {
                                                        return UITableViewCell()
        }
        
        cell.fillWithListing(listingViewModel: listingsViewModel.listings[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
}

extension ListingsViewController : UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let lastIndexPathRow = indexPaths.last?.row ?? 0
        if lastIndexPathRow > listingsViewModel.listings.count - 10 {
            print("fetch next page")
//            listingsViewModel.fetch(getNextPage: true)
        }
    }
}

