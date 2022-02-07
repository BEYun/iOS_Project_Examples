//
//  PlanetNameVC.swift
//  SpaceAdventure
//
//  Created by 윤병은 on 2022/02/04.
//

import UIKit

class PlanetNameVC: UIViewController {
    
    // 반복 줄이기
    
    @IBOutlet weak var planetNameTF: UITextField!
    @IBOutlet weak var planetNameTV: UITextView!
    
    @IBAction func planetNameButton(_ sender: Any) {
        
        for planet in PlanetarySystem1.planets {
            if planetNameTF.text == planet.name {
                planetNameTV.text = "Arrived at \(planet.name) , \(planet.description)"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
}
