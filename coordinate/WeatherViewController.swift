//
//  WeatherViewController.swift
//  coordinate
//
//  Created by Pollitt James on 23/05/2017.
//  Copyright © 2017 Pollitt James. All rights reserved.
//

import UIKit
import MapKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var weatherImageHeader: UIImageView!
    @IBOutlet weak var weatherLabelHeader: UILabel!
    @IBOutlet weak var weatherCityLabel: UILabel!
    
    @IBOutlet weak var switchBtn: UIButton! // for setting text
    @IBAction func switchToBtn(sender: UIButton) {
        weatherLabelHeader.text = ""
        if(showDegreesIn == "C"){
            showDegreesIn = "F"
            weatherLabelHeader.text = "\(fTemp)" + farenheitSymbol
            switchBtn.setTitle("Switch to " + celciusSymbol, forState: .Normal)
            
        }
        else {
            showDegreesIn = "C"
            weatherLabelHeader.text = "\(cTemp)" + celciusSymbol
            switchBtn.setTitle("Switch to " + farenheitSymbol, forState: .Normal)
        }
    }
    
    @IBOutlet weak var weatherTypeLabel: UILabel!
    @IBOutlet weak var celciusLabel: UILabel!
    @IBOutlet weak var celsFeelsLabel: UILabel!
    @IBOutlet weak var farenheitLabel: UILabel!
    @IBOutlet weak var farFeelsLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var precipLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    
    var uniCoords = CLLocationCoordinate2D(latitude: 53.48, longitude: -2.27)
    var currentLocation = CLLocation()
    
    var number: Int = 0
    var weather: String = ""
    
    var showDegreesIn: String = ""
    var celciusSymbol: String = "℃"
    var farenheitSymbol: String = "℉"
    
    var cTemp: Int = 0
    var cFeels: Int = 0
    var fTemp: Int = 0
    var fFeels: Int = 0
    var temp: Int = 0
    
    var humidity: Int = 0
    var precip: Double = 0.0
    var pressure: Int = 0
    var wind: String = ""
    
    var sunrise: String = ""
    var sunset: String = ""
    
    var city: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let homeController: FirstViewController = FirstViewController(nibName: nil, bundle: nil)
        self.city = homeController.getCity()
        self.currentLocation = homeController.currentLocation
        weatherCityLabel.text = self.city
        
        // Defaul to show in Celsius
        showDegreesIn = "C"
        switchBtn.setTitle("Switch to " + farenheitSymbol, forState: .Normal)
        
        // If running on physical device, please uncomment the following line.
        //let urlPath = WeatherURL(lat: String(currentLocation.coordinate.latitude), long: String(currentLocation.coordinate.longitude)).getFullURL()
        // If running on physical device, please comment the following line.
        let urlPath = WeatherURL(lat: String(uniCoords.latitude), long: String(uniCoords.longitude)).getFullURL()
        let url: NSURL = NSURL(string: urlPath)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        let queue:NSOperationQueue = NSOperationQueue()
        // Get current weather data from WorldWeatherOnline
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: {(response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    if let data = jsonResult["data"] as? Dictionary<String, AnyObject>{
                        if let weather = data["weather"] as? [Dictionary<String, AnyObject>]{
                            if let astro = weather[0]["astronomy"] as? [Dictionary<String, AnyObject>]{
                                if let sunr = astro[0]["sunrise"] as? String{
                                    self.sunrise = sunr
                                    self.sunriseLabel.text = "Sunrise: " + self.sunrise
                                }
                                if let suns = astro[0]["sunset"] as? String {
                                    self.sunset = suns
                                    self.sunsetLabel.text = "Sunset: " + self.sunset
                                }
                            }
                        }
                        if let conditions = data["current_condition"] as? [Dictionary<String, AnyObject>]{
                            if let weatherDesc = conditions[0]["weatherDesc"] as? [Dictionary<String, AnyObject>]{
                                if let desc = weatherDesc[0]["value"] as? String{
                                    self.weatherTypeLabel.text = desc
                                    if(desc.lowercaseString == "partly cloudy" || desc.lowercaseString.containsString("cloud")){
                                        self.weatherImageHeader.image = UIImage(named: "images/pcloudy.png")
                                    }
                                    else if(desc.lowercaseString == "sun" || desc.lowercaseString.containsString("sun")){
                                        self.weatherImageHeader.image = UIImage(named: "images/sunny.png")
                                    }
                                    else if(desc.lowercaseString == "rain" || desc.lowercaseString.containsString("rain") || desc.lowercaseString.containsString("showers")){
                                        self.weatherImageHeader.image = UIImage(named: "images/rain.png")
                                    }
                                    else if(desc.lowercaseString == "thunder" || desc.lowercaseString.containsString("lightning")){
                                        self.weatherImageHeader.image = UIImage(named: "images/lightning.png")
                                    }
                                    else if(desc.lowercaseString == "snow" || desc.lowercaseString.containsString("snow")){
                                        self.weatherImageHeader.image = UIImage(named: "images/snow.png")
                                    }
                                    else if (desc.lowercaseString == "overcast"){
                                        self.weatherImageHeader.image = UIImage(named: "images/overcast.png")
                                    }
                                    else if(desc.lowercaseString == "clear") {
                                        self.weatherImageHeader.image = UIImage(named: "images/clear.png")
                                    }
                                    else {
                                        self.weatherImageHeader.image = UIImage(named: "images/weathers.png")
                                    }
                                }
                            }
                            if let tempC = conditions[0]["temp_C"] as? String {
                                if let temppC = Int(tempC){
                                    self.cTemp = temppC
                                    self.temp = self.cTemp
                                    self.celciusLabel.text = "Celcius: \(self.cTemp)" + self.celciusSymbol
                                    self.weatherLabelHeader.text = "\(self.cTemp)" + self.celciusSymbol
                                }
                            }
                            if let cFeel = conditions[0]["FeelsLikeC"] as? String {
                                if let cFeell = Int(cFeel){
                                    self.cFeels = cFeell
                                    self.celsFeelsLabel.text = "Feels like: \(self.cFeels)" + self.celciusSymbol
                                }
                            }
                            if let tempF = conditions[0]["temp_F"] as? String {
                                if let temppF = Int(tempF){
                                    self.fTemp = temppF
                                    self.farenheitLabel.text = "Farenheit: \(self.fTemp)" + self.farenheitSymbol
                                }
                            }
                            if let fFeel = conditions[0]["FeelsLikeF"] as? String {
                                if let fFeell = Int(fFeel){
                                    self.fFeels = fFeell
                                    self.farFeelsLabel.text = "Feels like: \(self.fFeels)" + self.farenheitSymbol
                                }
                            }
                            if let hum = conditions[0]["humidity"] as? String {
                                if let humm = Int(hum){
                                    self.humidity = humm
                                    self.humidityLabel.text = "Humidity: \(self.humidity)%"
                                }
                            }
                            if let pres = conditions[0]["pressure"] as? String {
                                if let press = Int(pres){
                                    self.pressure = press
                                    self.pressureLabel.text = "Pressure: \(self.pressure)%"
                                }
                            }
                            if let prec = conditions[0]["precipMM"] as? String {
                                if let preci = Double(prec){
                                    self.precip = preci
                                    self.precipLabel.text = "Precip: \(self.precip) mm"
                                }
                            }
                            if let windDir = conditions[0]["winddir16Point"] as? String {
                                if let windDir16 = String(UTF8String: windDir){
                                    self.wind = windDir16
                                    self.windLabel.text = "Wind: \(self.wind)"
                                }
                            }
                        }
                    }
                }
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
