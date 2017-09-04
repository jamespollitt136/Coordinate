//
//  CalculatorViewController.swift
//  coordinate
//
//  Created by Pollitt James on 28/05/2017.
//  Copyright © 2017 Pollitt James. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    var currentOperation: Operator = Operator.nothing
    var calcState: CalculationState = CalculationState.enteringNum
    
    @IBOutlet weak var resultLbl: UILabel!
    
    var firstValue: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickedEquals(sender: UIButton) {
        calculateSum()
    }
    
    @IBAction func clickedOperator(sender: UIButton) {
        if let num = resultLbl.text {
            if num != "" {
                firstValue = num
                resultLbl.text = ""
            }
        }
        switch sender.tag {
        case 10:
            currentOperation = Operator.add
        case 11:
            currentOperation = Operator.subtract
        case 12:
            currentOperation = Operator.times
        case 13:
            currentOperation = Operator.divide
        default:
            return
        }
    }
    
    @IBAction func clickedNumber(sender: UIButton) {
        updateDisplay(String(sender.tag))
    }
    
    func updateDisplay(number: String){
        if calcState == CalculationState.newNumStarted {
            if let num = resultLbl.text {
                if num != "" {
                    firstValue = num
                    resultLbl.text = ""
                }
            }
            calcState = CalculationState.enteringNum
            resultLbl.text = number
        }
        else if calcState == CalculationState.enteringNum {
            resultLbl.text = resultLbl.text! + number
        }
    }
    
    func calculateSum(){
        if (firstValue.isEmpty){
            return
        }
        var result = ""
        if currentOperation == Operator.times {
            result = "\(Double(firstValue)! * Double(resultLbl.text!)!)"
        }
        else if currentOperation == Operator.divide {
            result = "\(Double(firstValue)! / Double(resultLbl.text!)!)"
        }
        else if currentOperation == Operator.add {
            result = "\(Double(firstValue)! + Double(resultLbl.text!)!)"
        }
        else if currentOperation == Operator.subtract {
            result = "\(Double(firstValue)! - Double(resultLbl.text!)!)"
        }
        resultLbl.text = result
        calcState = CalculationState.newNumStarted
    }
    
}
