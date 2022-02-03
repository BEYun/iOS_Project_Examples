//
//  ViewController.swift
//  SpaceAdventure
//
//  Created by 윤병은 on 2022/02/03.
//

import UIKit

class ViewController: UIViewController {
    
    let PlanetarySystem1 = PlanetarySystem(name: "Solar System")
    
    let PlanetarySystem2 = PlanetarySystem(name: "Earth")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        introduction()
        start()
        print(response(q: "Who are you?"))
        
    }

    func start() {


        secondTextView.text = "Shall I randomly choose a planet for you to a visit? (Y or N)"
    }
    
    func introduction() {
        let numberOfPlanets: Int = 0
        let diameterOfEarth: Double = 24859.82
        
        firstTextView.text = "Welcome to our \(PlanetarySystem2.name)! There are \(numberOfPlanets) planets to explore. You are currently on Earth, which has a circumference of \(diameterOfEarth) miles"
    }

    func response(q: String) -> String {
        
        myLabel.text = q
        
        return "Good"
    }
    
    
    @IBAction func firstButton(_ sender: Any) {
        let name = firstTextField.text!
        myLabel.text = "Nice to meet you, \(name)"
    }
    
    @IBAction func secondButton(_ sender: Any) {
        
        let decision = secondTextField.text
        
        if decision == "Y" {
            secondTextView.text = "OK, Traveling to..."
        }
        
        else if decision == "N" {
            secondTextView.text = "OK, name the planet you would..."
        }
        
        else {
            secondTextView.text = "Sorry, I didn't get that."
        }
    }
    
    
    @IBOutlet weak var firstTextView: UITextView!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var firstTextField: UITextField!
    
    
    @IBOutlet weak var secondTextView: UITextView!
    @IBOutlet weak var secondTextField: UITextField!
    
}

