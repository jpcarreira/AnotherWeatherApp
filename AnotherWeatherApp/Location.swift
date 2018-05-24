//
//  Location.swift
//  AnotherWeatherApp
//
//  Created by João Carreira on 19/05/2018.
//  Copyright © 2018 João Carreira. All rights reserved.
//

import Foundation


class Location: NSObject, NSCoding {
    let name: String
    let latitude: Double
    let longitude: Double
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    // NSCoding
    
    private enum CodingKeys: String {
        case name
        case latitude
        case longitude
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: CodingKeys.name.rawValue)
        aCoder.encode(latitude, forKey: CodingKeys.latitude.rawValue)
        aCoder.encode(longitude, forKey: CodingKeys.longitude.rawValue)
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: CodingKeys.name.rawValue) as? String else {
            return nil
        }
        let latitude = aDecoder.decodeDouble(forKey: CodingKeys.latitude.rawValue)
        let longitude = aDecoder.decodeDouble(forKey: CodingKeys.longitude.rawValue)
        
        self.init(name: name, latitude: latitude, longitude: longitude)
    }
}
