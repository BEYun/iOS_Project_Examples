//
//  ViewController.swift
//  Clock
//
//  Created by 윤병은 on 2022/02/10.
//

import UIKit

class ViewController: UIViewController {
    
    let clock = Clock()
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let form = DateFormatter()
        form.timeStyle = .short
        let stringDate = form.string(from: clock.date)
        
        timeLabel.text = stringDate
    }


}

