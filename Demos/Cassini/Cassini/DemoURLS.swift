//
//  DemoURLS.swift
//  Cassini
//
//  Created by Ryan Brazones on 10/1/18.
//  Copyright © 2018 greenred. All rights reserved.
//

import Foundation

struct DemoURL{
    static let gatech = URL(string: "http://www.gatech.edu/sites/default/files/pictures/expanded-page/visit-tech.png")
    
    static var NASA: Dictionary<String, URL> = {
        let NASAUrlStrings = [
            "Cassini" : "http://www.jpl.nasa.gov/images/cassini/20090202/pia03883-full.jpg",
            "Earth" : "http://www.nasa.gov/sites/default/files/wave_earth_mosaic_3.jpg",
            "Saturn" : "http://www.nasa.gov/sites/default/files/saturn_collage.jpg"
        ]
        
        var urls = Dictionary<String, URL>()
        for (key,value) in NASAUrlStrings {
            urls[key] = URL(string: value)
        }
        
        return urls
    }()
}
