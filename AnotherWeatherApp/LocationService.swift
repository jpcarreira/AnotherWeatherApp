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
            completion: @escaping (_ success: Bool, _ results: [String]?) -> Void ){
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
                var locations = [String]()
                for item in response!.mapItems {
                    if let locationName = item.name {
                        locations.append(locationName)
                    }
                }
                completion(true, locations)
            }
        })
    }
}