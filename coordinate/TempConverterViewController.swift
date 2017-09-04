//
//  TempConverterViewController.swift
//  coordinate
//
//  Created by Pollitt James on 28/05/2017.
//  Copyright © 2017 Pollitt James. All rights reserved.
//

import UIKit

class TempConverterViewController: UIViewController {
    
    var currentTempValue: String = ""
    var currentTempInt: Int = 0

    @IBOutlet weak var tempInput: UITextField!
    
    // Convert the input to Celsius
    @IBAction func cButton(sender: UIButton) {
        if let result = tempInput.text {
            if (result == ""){
                return
            }
            else {
                if let num = Double(result) {
                    let output = num * (5/9) - 32
                    results.text = "\(output)℃"
                }
            }
        }
    }
    
    
    @IBAction func fButton(sender: UIButton) {
        if let result = tempInput.text {
            if (result == "") {
                return
            }
            else {
                if let num = Double(result) {
                    let output = num * (9/5) + 32
                    results.text = "\(output)℉"
                }
            }
        }
    }
    
    @IBOutlet weak var results: UILabel!
    
    @IBAction func currentTemp(sender: UIButton) {
       tempInput.text = String(currentTempInt)
    }
    
    @IBOutlet weak var currentTempBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        results.text = ""
        let homeController: FirstViewController = FirstViewController(nibName: nil, bundle: nil)
        currentTempValue = homeController.getTemp()
        currentTempInt = homeController.getTempInt()
        currentTempBtn.setTitle("Current Temp: " + currentTempValue + "℃", forState: .Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}
