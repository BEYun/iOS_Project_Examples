//
//  PlanetarySystem.swift
//  SpaceAdventure
//
//  Created by 윤병은 on 2022/02/03.
//

import Foundation

class PlanetarySystem {
    
    var name: String
    
    var planets = planetData.map { (name, description) in
        Planet(name: name, description: description)
    }
    
    var randomPlanet: Planet? {
        if planets.isEmpty {
            return nil
        }
        else {
            let count: Int = planets.count
            let index: Int = Int.random(in: 0...count-1)
            return planets[index]
        }
    }
    
    
    init(name: String) {
        self.name = name
        }
    
}
    
