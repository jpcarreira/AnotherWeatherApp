//
//  LocationsTableViewController.swift
//  AnotherWeatherApp
//
//  Created by João Carreira on 18/05/2018.
//  Copyright © 2018 João Carreira. All rights reserved.
//

import UIKit


final class LocationsViewController: UITableViewController {

    private static let locationCellIdentifier = "LocationCell"
    
    private var favouriteLocations = [WeatherItem]() {
        didSet {
            if favouriteLocations.count == 0 {
                // TODO: show view hiting to search for locations
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        refreshControl?.addTarget(
            self, action: #selector(refreshWeatherData), for: UIControlEvents.valueChanged)
    }
    
    override func tableView(
            _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteLocations.count
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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(
        _ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
        forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            favouriteLocations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
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


extension LocationsViewController: SearchLocationViewControllerDelegate {
    
    func locationItemWasSelected(location: LocationItem) {
        let weatherItem = WeatherItem(location: location)
        weatherItem.delegate = self
        favouriteLocations.append(weatherItem)
        
        tableView.reloadData()
        updateWeatherInformation()
    }
}


extension LocationsViewController: WeatherItemDelegate {
    func weatherWasUpdated(for item: WeatherItem) {
        tableView.reloadData()
    }
}
