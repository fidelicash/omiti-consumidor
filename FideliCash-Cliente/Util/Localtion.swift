//
//  Localtion.swift
//  FideliCash-Cliente
//
//  Created by Carlos Doki on 10/06/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import CoreLocation

class Location {
    static var sharedInstance = Location()
    private init() {}
    
    var latitude: Double!
    var longitude: Double!
}
