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
        listingsViewModel = ListingsViewModel()
        bindViewModel(viewModel: listingsViewModel!)
        listingsViewModel!.fetch()
        
        refreshControl.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        listingsTableView.refreshControl = refreshControl
        
        listingsTableView.tableFooterView = UIView()
        
        filtersButton.layer.borderColor = UIColor.codeSampleGrayBorder().cgColor
        filtersButton.layer.borderWidth = 1
        
        //todo: add tests
        //todo: POST favorite change
        //todo: move image load into network service
        
    }
    
    @objc private func pullToRefresh(_ sender : Any){
        listingsViewModel?.fetch()
    }
    
    private func bindViewModel(viewModel : ListingsViewModel) {
        viewModel.$listings.sink { [weak self] listings in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                defer {
                    self.refreshControl.endRefreshing()
                }
                
                guard self.listingsViewModel.addedListingsStartIndex > 0 else {
                    //we're not adding cells, its an empty table, so just create
                    self.listingsTableView.reloadData()
                    return
                }
                
                self.listingsTableView.beginUpdates()
                
                //create an array of index paths to be inserted into table
                var newIndexPathArray = [IndexPath]()
                for i in self.listingsViewModel.addedListingsStartIndex...(listings.count-1) {
                    newIndexPathArray.append(IndexPath(row: i, section: 0))
                }
                self.listingsTableView.insertRows(at: newIndexPathArray, with: .automatic)
                self.listingsTableView.endUpdates()
            }
           }.store(in: &cancellables)
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
          listingsViewModel.fetch(getNextPage: true)
        }
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= listingsViewModel.listings.count
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = listingsTableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

