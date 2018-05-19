//
//  LocationsTableViewController.swift
//  AnotherWeatherApp
//
//  Created by João Carreira on 18/05/2018.
//  Copyright © 2018 João Carreira. All rights reserved.
//

import UIKit


final class LocationsViewController: UITableViewController {

    private static let noLocationCellIdentifier = "NoLocationCell"
    private static let locationCellIdentifier = "LocationCell"
    
    override func tableView(
            _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(
            withIdentifier: LocationsViewController.noLocationCellIdentifier, for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(
            _ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchLocationSegue" {
            let navigationController = segue.destination as! UINavigationController
            if let searchLocationViewController =
                    navigationController.viewControllers.first as? SearchLocationViewController {
                searchLocationViewController.delegate = self
            }
        }
    }
}


extension LocationsViewController: SearchLocationViewControllerDelegate {
    
    func locationItemWasSelected(location: LocationItem) {
        // TODO:
    }
}
