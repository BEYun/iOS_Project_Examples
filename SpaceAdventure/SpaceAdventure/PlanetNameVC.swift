//
//  PlanetNameVC.swift
//  SpaceAdventure
//
//  Created by 윤병은 on 2022/02/04.
//

import UIKit

class PlanetNameVC: UIViewController {
    
    let PlanetarySystem1 = PlanetarySystem(name: "Solar System", planets: [Planet]())
    
    let mercury = Planet(name: "Mercury", description: "Hot Planet")
    let venus = Planet(name: "Venus", description: "Cloudy Planet")
    let earth = Planet(name: "Earth", description: "Here")
    let mars = Planet(name: "Mars", description: "Red Planet")
    let jupyter = Planet(name: "Jupyter", description: "Gas Planet")
    let neptune = Planet(name: "Neptune", description: "Cold Planet")
    // 반복 줄이기
    
    @IBOutlet weak var planetNameTF: UITextField!
    @IBOutlet weak var planetNameTV: UITextView!
    
    @IBAction func planetNameButton(_ sender: Any) {
        
        for planet in PlanetarySystem1.planets {
            if planetNameTF.text == planet.name {
                planetNameTV.text = "Arrived at \(planet.name)"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PlanetarySystem1.planets.append(mercury)
        PlanetarySystem1.planets.append(venus)
        PlanetarySystem1.planets.append(earth)
        PlanetarySystem1.planets.append(mars)
        PlanetarySystem1.planets.append(jupyter)
        PlanetarySystem1.planets.append(neptune)

    }
    
}
