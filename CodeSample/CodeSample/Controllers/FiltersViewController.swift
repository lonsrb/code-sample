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
        dismiss(animated: true) {
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension  FiltersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtersViewModel.propertyTypeFilters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyTypeCell", for: indexPath)
        let viewModel = filtersViewModel.propertyTypeFilters[indexPath.row]
        cell.textLabel?.text = viewModel.propertyTypeString
        cell.isSelected = viewModel.isSelected
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
