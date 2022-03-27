//
//  ViewController.swift
//  debug_text
//
//  Created by 윤병은 on 2022/03/26.
//

import UIKit

class ViewController: UIViewController {
    var student: Student? = Student(name: "철수")
    var school: School? = School(name: "사과대학교")

    override func viewDidLoad() {
        super.viewDidLoad()
        school?.student = student
        student?.school = school
        
        student = nil
        school = nil
    }

    class Student {
        var name: String
        var school: School?
        
        init(name: String) {
            self.name = name
        }
    }
    
    class School {
        var name: String
        var student: Student?
        
        init(name: String) {
            self.name = name
        }
    }

}

