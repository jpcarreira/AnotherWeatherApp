//
//  SearchLocationViewController.swift
//  AnotherWeatherApp
//
//  Created by João Carreira on 18/05/2018.
//  Copyright © 2018 João Carreira. All rights reserved.
//

import UIKit


final class SearchLocationViewController: UITableViewController {
    
    private static let cellIdentifier = "LocationSearchCell"
    
    // data source for the table view
    var foundLocations = [String]() {
        didSet {
           tableView.reloadData()
        }
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = searchController.searchBar
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search For Locations"
        definesPresentationContext = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundLocations.count
    }
    
    override func tableView(
            _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchLocationViewController.cellIdentifier, for: indexPath) as!
            SearchLocationTableViewCell
        
        if foundLocations.indices.contains(indexPath.row) {
            cell.city.text = foundLocations[indexPath.row]
        }
        
        return cell
    }
    
    @IBAction func closeButtonIsPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}


extension SearchLocationViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, searchText.count > 2 {
            LocationService.lookFor(searchText) { (success, locations) in
                if success, locations != nil {
                    print(locations!)
                    self.foundLocations = locations!
                } else {
                    self.foundLocations = []
                }
            }
        } else {
            self.foundLocations = []
        }
    }
}
