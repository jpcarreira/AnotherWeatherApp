//
//  FavouriteLocation+CoreDataProperties.swift
//  AnotherWeatherApp
//
//  Created by João Carreira on 24/05/2018.
//  Copyright © 2018 João Carreira. All rights reserved.
//
//

import Foundation
import CoreData


extension FavouriteLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteLocation> {
        return NSFetchRequest<FavouriteLocation>(entityName: FavouriteLocation.entityName)
    }

    @NSManaged var location: Location?
    @NSManaged var weather: WeatherCondition?

}
