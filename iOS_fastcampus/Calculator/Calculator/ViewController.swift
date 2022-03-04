//
//  ViewController.swift
//  Calculator
//
//  Created by 윤병은 on 2022/03/04.
//

import UIKit

enum Operation {
    case Add
    case Subtract
    case Multiply
    case Divide
    case unknown
}

class ViewController: UIViewController {
    
    // 계산기 Output
    var displayNumber = ""
    // 첫번째 피연산자
    var firstOperand = ""
    // 두번째 피연산자
    var secondOperand = ""
    // 결과 값 저장
    var result = ""
    // 현재 연산자의 값
    var currentOperation: Operation = .unknown

    @IBOutlet weak var numberOutputLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func tapNumberButton(_ sender: UIButton) {
        // 오류 수정 구간
        // sender.title(for:.normal)은 nil을 반환함 -> sender.titleLabel?.text로 대체
        guard let numberValue = sender.titleLabel?.text else { return }
        if self.displayNumber.count < 9 {
            self.displayNumber += numberValue
            self.numberOutputLabel.text = self.displayNumber
        }
    }
    
    @IBAction func tapClearButton(_ sender: UIButton) {
        self.displayNumber = ""
        self.firstOperand = ""
        self.secondOperand = ""
        self.result = ""
        self.currentOperation = .unknown
        self.numberOutputLabel.text = "0"
    }
    
    @IBAction func tapDotButton(_ sender: UIButton) {
        // 소수점은 숫자에 포함시키지 않는 예외 처리
        if self.displayNumber.count < 8, !self.displayNumber.contains(".") {
            self.displayNumber += self.displayNumber.isEmpty ? "0." : "."
            self.numberOutputLabel.text = self.displayNumber
        }
    }
    @IBAction func tapDivideButton(_ sender: UIButton) {
        self.operation(.Divide)
    }
    @IBAction func tapMultiplyButton(_ sender: UIButton) {
        self.operation(.Multiply)
    }
    @IBAction func tapSubtractButton(_ sender: UIButton) {
        self.operation(.Subtract)
    }
    @IBAction func tapAddButton(_ sender: UIButton) {
        self.operation(.Add)
    }
    @IBAction func tapEqualButton(_ sender: UIButton) {
        self.operation(self.currentOperation)
    }
    
    func operation(_ operation: Operation) {
        if self.currentOperation != .unknown {
            if !self.displayNumber.isEmpty {
                self.secondOperand = self.displayNumber
                self.displayNumber = ""
                
                guard let firstOperand = Double(self.firstOperand) else { return }
                guard let secondOperand = Double(self.secondOperand) else { return }
                
                switch self.currentOperation {
                case .Add:
                    self.result = "\(firstOperand + secondOperand)"
                case .Subtract:
                    self.result = "\(firstOperand - secondOperand)"
                case .Divide:
                    self.result = "\(firstOperand / secondOperand)"
                case .Multiply:
                    self.result = "\(firstOperand * secondOperand)"
                default:
                    break
                }
                
                // 소수점을 표시하지 않게 하는 코드
                if let result = Double(self.result), result.truncatingRemainder(dividingBy: 1) == 0 {
                    self.result = "\(Int(result))"
                }
                
                // 연산의 결과를 계속해서 저장
                self.firstOperand = self.result
                self.numberOutputLabel.text = self.result
            }
            self.currentOperation = operation
        } else {
            self.firstOperand = self.displayNumber
            // 선택한 연산자 저장
            self.currentOperation = operation
            // 연산자 이후의 값(secondOperand)를 저장하기 위해 displayNumber 초기화
            self.displayNumber = ""
        }
    }
}

