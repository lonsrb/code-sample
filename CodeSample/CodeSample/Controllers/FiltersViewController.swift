//
//  FiltersViewController.swift
//  CodeSample
//
//  Created by Ryan Lons on 7/5/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {

    @IBOutlet weak var propertyTypesTableView: UITableView!

    var filtersViewModel = FiltersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel(viewModel: filtersViewModel)
        filtersViewModel.fetch()
        propertyTypesTableView.tableFooterView = UIView()
    }
    
    private func bindViewModel(viewModel : FiltersViewModel) {
     _ = viewModel.$propertyTypeFilters.sink { [weak self] _ in
         guard let self = self else { return }
         self.propertyTypesTableView.reloadData()
        }
    }
    
    @IBAction func doneTapped(_ sender: UIButton) {
        if let selectedIndexPaths = propertyTypesTableView.indexPathsForSelectedRows {
            let selectedRows = selectedIndexPaths.map { $0.row }
            filtersViewModel.updateSelectedPropertyTypes(selectedIndices: selectedRows)
        }
        else { //no rows selected which means don't filter, show everything
            filtersViewModel.updateSelectedPropertyTypes(selectedIndices: [])
        }
        
        dismiss(animated: true) {}
    }
}

extension  FiltersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtersViewModel.propertyTypeFilters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyTypeCell", for: indexPath)
        let viewModel = filtersViewModel.propertyTypeFilters[indexPath.row]
        cell.textLabel?.text = viewModel.propertyTypeString
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let viewModel = filtersViewModel.propertyTypeFilters[indexPath.row]
        if viewModel.isSelected {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
