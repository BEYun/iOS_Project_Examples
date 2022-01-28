//
//  ViewController.swift
//  HelloWorld
//
//  Created by 윤병은 on 2022/01/26.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func changeBackgroundColorToBlack(_ sender: Any) {
        
        view.backgroundColor = UIColor.black
    }
    
    @IBAction func changeToWhite(_ sender: Any) {
        
        view.backgroundColor = UIColor.white
    }
    
    
    @IBAction func changeToBlue(_ sender: Any) {
        
        view.backgroundColor = UIColor.blue
    }
    
    
}

