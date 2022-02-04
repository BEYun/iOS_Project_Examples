//
//  PlanetarySystem.swift
//  SpaceAdventure
//
//  Created by 윤병은 on 2022/02/03.
//

import Foundation

class PlanetarySystem {
    
    var name: String
    
    var planets: [Planet]
    
    
    init(name: String, planets: [Planet]) {
        self.name = name
        self.planets = planets
    }
    
    
}
