//
//  MainViewController.swift
//  AnotherWeatherApp
//
//  Created by João Carreira on 21/05/2018.
//  Copyright © 2018 João Carreira. All rights reserved.
//

import UIKit


final class MainViewController: UIViewController {
    
    var summaryViewController: SummaryViewController? {
        get {
            for viewController in childViewControllers {
                if viewController is SummaryViewController {
                    return viewController as? SummaryViewController
                }
            }
            return nil
        }
    }
    
    private var locationsTableViewController: LocationsTableViewController? {
        get {
            for viewController in childViewControllers {
                if viewController is LocationsTableViewController {
                    return viewController as? LocationsTableViewController
                }
            }
            return nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchLocationSegue" {
            let navigationController = segue.destination as! UINavigationController
            if let searchLocationViewController =
                navigationController.viewControllers.first as?
                SearchLocationViewController {
                    searchLocationViewController.delegate = locationsTableViewController
            }
        }
    }
}
