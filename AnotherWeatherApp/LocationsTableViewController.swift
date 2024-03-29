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
        
        loadData()
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
                cell.conditionImageView.image = UIImage(named: weather.icon)
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
        return indexPath.section == 0 ? 80.0 : 140.0
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
            reloadDataAndSave()
        }
    }
    
    override func tableView(
            _ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath,
            to destinationIndexPath: IndexPath) {
        let movedLocation = favouriteLocations[sourceIndexPath.row]
        favouriteLocations.remove(at: sourceIndexPath.row)
        favouriteLocations.insert(movedLocation, at: destinationIndexPath.row)
        reloadDataAndSave()
    }
    
    private func updateWeatherInformation() {
        for location in favouriteLocations {
            if location.delegate == nil {
                location.delegate = self
            }
            location.updateWeatherCondition()
        }
    }
    
    @objc private func refreshWeatherData() {
        updateWeatherInformation()
    }
    
    private func reloadDataAndSave() {
        tableView.reloadData()
        saveData()
    }
    
    private func loadData() {
        let fecthRequest: NSFetchRequest<FavouriteLocation> = FavouriteLocation.fetchRequest()
        do {
            let results = try managedObjectContext.fetch(fecthRequest)
            if results.count > 0 {
                favouriteLocations.removeAll()
                for favouriteLocation in results {
                    guard let location = favouriteLocation.location else {
                            return
                    }
                    
                    favouriteLocations.append(
                        LocationItem(location: location, weather: favouriteLocation.weather))
                }
            }
        } catch let error as NSError {
            fatalError("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    private func saveData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> =
            NSFetchRequest(entityName: FavouriteLocation.entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedObjectContext.persistentStoreCoordinator?.execute(
                deleteRequest, with: managedObjectContext)
        } catch let error as NSError {
             fatalError("Fetch error: \(error) description: \(error.userInfo)")
        }
        
        for location in favouriteLocations {
            let favouriteLocation = FavouriteLocation(context: managedObjectContext)
            favouriteLocation.location = location.location
            favouriteLocation.weather = location.weather
            
            do {
               try managedObjectContext.save()
            } catch let error as NSError {
                fatalError("Fetch error: \(error) description: \(error.userInfo)")
            }
        }
    }
}


extension LocationsTableViewController: SearchLocationViewControllerDelegate {
    func locationItemWasSelected(location: Location) {
        let weatherItem = LocationItem(location: location)
        weatherItem.delegate = self
        favouriteLocations.append(weatherItem)
        
        updateWeatherInformation()
        reloadDataAndSave()
    }
}


extension LocationsTableViewController: LocationItemDelegate {
    func weatherWasUpdated(for item: LocationItem) {
        DispatchQueue.main.async {
            self.reloadDataAndSave()
            if let _ = self.refreshControl?.isRefreshing {
                self.refreshControl?.endRefreshing()
            }
        }
    }
}
