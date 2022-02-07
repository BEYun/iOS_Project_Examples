//
//  Planet.swift
//  SpaceAdventure
//
//  Created by 윤병은 on 2022/02/04.
//

import Foundation

class Planet {
    let name: String
    let description: String
    
    init(name: String, description: String){
        self.name = name
        self.description = description
    }
    
}
var planetData =
    [   "Mercury" : "Hot Planet",
        "Venus" : "Cloudy Planet",
        "Earth" : "Here",
        "Mars" : "Red Planet",
        "Jupyter" : "Gas Planet",
        "Neptune" : "Cold Planet" ]
