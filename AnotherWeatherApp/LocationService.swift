//
//  LocationService.swift
//  AnotherWeatherApp
//
//  Created by João Carreira on 18/05/2018.
//  Copyright © 2018 João Carreira. All rights reserved.
//

import MapKit


final class LocationService {
    
    static func lookFor(
            _ place: String?,
            completion: @escaping (_ success: Bool, _ results: [LocationItem]?) -> Void ){
        guard let _ = place else {
           return
        }
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = place
        
        
        MKLocalSearch(request: request).start(completionHandler: { (response, error) in
            if error != nil {
                print("Error occurred in search:\(error!.localizedDescription)")
                completion(false, nil)
            } else if response!.mapItems.count == 0 {
                print("No matches found")
                completion(false, nil)
            } else {
                var locations = [LocationItem]()
                for item in response!.mapItems {
                    if let locationName = item.name {
                        let locationItem = LocationItem(
                            name: locationName,
                            latitude: item.placemark.coordinate.latitude,
                            longitude: item.placemark.coordinate.longitude)
                        
                        locations.append(locationItem)
                    }
                }
                completion(true, locations)
            }
        })
    }
}
