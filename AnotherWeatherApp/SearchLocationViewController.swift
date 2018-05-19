//
//  SearchLocationViewController.swift
//  AnotherWeatherApp
//
//  Created by João Carreira on 18/05/2018.
//  Copyright © 2018 João Carreira. All rights reserved.
//

import UIKit


protocol SearchLocationViewControllerDelegate: class {
    
    func locationItemWasSelected(location: LocationItem)
}


final class SearchLocationViewController: UITableViewController {
    
    private static let cellIdentifier = "LocationSearchCell"
    
    weak var delegate: SearchLocationViewControllerDelegate?
    
    // data source for the table view
    var foundLocations = [LocationItem]() {
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
            cell.city.text = foundLocations[indexPath.row].name
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if foundLocations.indices.contains(indexPath.row) {
            delegate?.locationItemWasSelected(location: foundLocations[indexPath.row])
            searchController.isActive = false
            dismissSearchLocationViewController()
        }
    }
    
    @IBAction func closeButtonIsPressed(_ sender: UIBarButtonItem) {
        dismissSearchLocationViewController()
    }
    
    private func dismissSearchLocationViewController() {
        dismiss(animated: true, completion: nil)
    }
}


extension SearchLocationViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, searchText.count > 2 {
            LocationService.lookFor(searchText) { (success, locations) in
                if success, locations != nil {
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
