//
//  OfficeViewController.swift
//  coordinate
//
//  Created by Pollitt James on 23/05/2017.
//  Copyright © 2017 Pollitt James. All rights reserved.
//

import UIKit

class OfficeViewController: UIViewController {
    
    var ambientLight: String = "97.4"
    var externalLight: String = "101.2"
    var soilMoisture: String = "96.9"
    var hardwareTemp: String = "28.97"
    var ambientHumidity: String = "15"
    var ambientTemp: String = "27"
    
    var degreesSymbol: String = "℃"
    
    @IBOutlet weak var ambLightLabel: UILabel!
    @IBOutlet weak var extLightLabel: UILabel!
    @IBOutlet weak var soilMoistLabel: UILabel!
    @IBOutlet weak var hardwareTempLabel: UILabel!
    @IBOutlet weak var ambHumidLabel: UILabel!
    @IBOutlet weak var ambTempLabel: UILabel!
    @IBOutlet weak var actionsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
/*
        let officeTreeUrl = OfficeTreeURL().getFullURL()
        let url: NSURL = NSURL(string: officeTreeUrl)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        let queue: NSOperationQueue = NSOperationQueue()
        // get the tree data from www.chrisjhughes.co.uk/api/tree
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: {(response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    if let sub = jsonResult[0] as? [Dictionary<String, AnyObject>]{
                        if let ambLight = sub[0]["AmbientLight"] as? String{
                            self.ambientLight = ambLight
                                self.ambLightLabel.text = self.ambientLight + "%"
                        }
                        if let extLight = sub[0]["ExternalLight"] as? String{
                            self.externalLight = extLight
                            self.extLightLabel.text = self.externalLight + "%"
                        }
                        if let soil = sub[0]["SoilMoisture"] as? String {
                            self.soilMoisture = soil
                            self.soilMoistLabel.text = self.soilMoisture + "%"
                            let doubSoil = Double(self.soilMoisture)
                            if(doubSoil <= 25.0){
                                self.actionsLabel.text = "Please tend to the tree's soil. "
                            }
                        }
                        if let hwTemp = sub[0]["HardwareTemperature"] as? String {
                            self.hardwareTemp = hwTemp
                            self.hardwareTempLabel.text = self.hardwareTemp + self.degreesSymbol
                            let doubHwTemp = Double(self.hardwareTemp)
                            if(doubHwTemp >= 35.0){
                                self.actionsLabel.text = "Be careful of hardware overheating. "
                            }
                        }
                        if let ambHum = sub[0]["AmbientHumidity"] as? String {
                            self.ambientHumidity = ambHum
                            self.ambHumidLabel.text = self.ambientHumidity + self.degreesSymbol
                        }
                        if let ambTemp = sub[0]["AmbientTemperature"] as? String {
                            self.ambientTemp = ambTemp
                            self.ambTempLabel.text = self.ambientTemp + self.degreesSymbol
                        }
                    }
                }
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
        })
 */
        actionsLabel.text = "Tree is OK, no actions needed."
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getOfficeTreeData(){
        let url = OfficeTreeURL().getFullURL()
        print(url)
    }
}
