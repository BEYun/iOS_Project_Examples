//
//  SeguePresentViewController.swift
//  ScreenTransitionExample
//
//  Created by 윤병은 on 2022/03/01.
//

import UIKit

class SeguePresentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func tapBackButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
