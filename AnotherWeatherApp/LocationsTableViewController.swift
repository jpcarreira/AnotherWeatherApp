//
//  LocationsTableViewController.swift
//  AnotherWeatherApp
//
//  Created by João Carreira on 18/05/2018.
//  Copyright © 2018 João Carreira. All rights reserved.
//

import UIKit
import CoreData


final class LocationsTableViewController: UITableViewController {

    private static let infoCellIdentifier = "InfoCell"
    private static let locationCellIdentifier = "LocationCell"
    
    var managedObjectContext: NSManagedObjectContext!
    
    private var favouriteLocations = [LocationItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        refreshControl?.addTarget(
            self, action: #selector(refreshWeatherData), for: UIControlEvents.valueChanged)
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
    
    override func tableView(
            _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: LocationsTableViewController.infoCellIdentifier, for: indexPath)
                as! InfoTableViewCell
            
            cell.infoLabel.text = favouriteLocations.count != 0 ?
                "Last update: \(String.currentDate())" :
                "No favourite locations found. " +
                "You can look for a location using the search button"
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: LocationsTableViewController.locationCellIdentifier, for: indexPath)
                as! LocationTableViewCell
            
            let weatherDataForLocation = favouriteLocations[indexPath.row]
            
            cell.location.text = weatherDataForLocation.location.name
            if let weather = weatherDataForLocation.weather {
                cell.weatherDescription.text = weather.summary
                cell.wind.text = "\(weather.windDirection) \(weather.windSpeed) km/hr"
                cell.temperature.text = "\(weather.temperature) ºC"
            } else {
                cell.weatherDescription.text = "Unknown condition"
                cell.wind.text = ""
                cell.temperature.text = ""
            }
            
            return cell
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : favouriteLocations.count
    }
    
    override func tableView(
            _ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 60.0 : 120.0
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section != 0
    }

    override func tableView(
        _ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
        forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            favouriteLocations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(
            _ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath,
            to destinationIndexPath: IndexPath) {
        let movedLocation = favouriteLocations[sourceIndexPath.row]
        favouriteLocations.remove(at: sourceIndexPath.row)
        favouriteLocations.insert(movedLocation, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    private func updateWeatherInformation() {
        for location in favouriteLocations {
            location.updateWeatherCondition()
        }
    }
    
    @objc private func refreshWeatherData() {
        updateWeatherInformation()
        refreshControl?.endRefreshing()
    }
}


extension LocationsTableViewController: SearchLocationViewControllerDelegate {
    
    func locationItemWasSelected(location: Location) {
        let weatherItem = LocationItem(location: location)
        weatherItem.delegate = self
        favouriteLocations.append(weatherItem)
        
        tableView.reloadData()
        updateWeatherInformation()
    }
}


extension LocationsTableViewController: LocationItemDelegate {
    func weatherWasUpdated(for item: LocationItem) {
        tableView.reloadData()
    }
}
