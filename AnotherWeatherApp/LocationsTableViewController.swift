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
    
    private var weatherData = [WeatherItem]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func tableView(
            _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if weatherData.count == 0 {
            return tableView.dequeueReusableCell(
                withIdentifier: LocationsViewController.noLocationCellIdentifier, for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: LocationsViewController.locationCellIdentifier, for: indexPath)
                as! LocationTableViewCell
            
            cell.location.text = weatherData[indexPath.row].location.name
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData.count == 0 ? 1 : weatherData.count
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
        weatherData.append(WeatherItem(location: location))
    }
}
