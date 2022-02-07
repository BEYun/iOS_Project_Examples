//
//  ViewController.swift
//  SpaceAdventure
//
//  Created by 윤병은 on 2022/02/03.
//

import UIKit

let PlanetarySystem1 = PlanetarySystem(name: "Solar System")

class ViewController: UIViewController {
    

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
        let diameterOfEarth: Double = 24859.82
        
        firstTextView.text = "Welcome to our \(PlanetarySystem1.name)! There are \(PlanetarySystem1.planets.count) planets to explore. You are currently on Earth, which has a circumference of \(diameterOfEarth) miles"
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
            
            if let rp = PlanetarySystem1.randomPlanet {

                secondTextView.text = "OK, Traveling to \(rp.name)"
            }
            else {
                secondTextView.text = "Sorry, There are no planets"
            }
        }
        
        else if decision == "N" {
            performSegue(withIdentifier: "show", sender: self)
            
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

