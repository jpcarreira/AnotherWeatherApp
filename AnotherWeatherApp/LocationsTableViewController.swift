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
    
    private var favouriteLocations = [WeatherItem]() {
        didSet {
            tableView.reloadData()
            updateWeatherInformation()
        }
    }
    
    private func updateWeatherInformation() {
        for location in favouriteLocations {
            location.updateWeatherCondition()
        }
    }
    
    override func tableView(
            _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if favouriteLocations.count == 0 {
            return tableView.dequeueReusableCell(
                withIdentifier: LocationsViewController.noLocationCellIdentifier, for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: LocationsViewController.locationCellIdentifier, for: indexPath)
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteLocations.count == 0 ? 1 : favouriteLocations.count
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
        let weatherItem = WeatherItem(location: location)
        weatherItem.delegate = self
        favouriteLocations.append(weatherItem)
    }
}


extension LocationsViewController: WeatherItemDelegate {
    func weatherWasUpdated(for item: WeatherItem) {
        tableView.reloadData()
    }
}
