//
//  String+Extension.swift
//  AnotherWeatherApp
//
//  Created by João Carreira on 21/05/2018.
//  Copyright © 2018 João Carreira. All rights reserved.
//

import Foundation


extension String {
    
    static func currentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.string(from: Date())
    }
}
