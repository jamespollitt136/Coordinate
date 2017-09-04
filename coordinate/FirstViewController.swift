//
//  FirstViewController.swift
//  coordinate
//
//  Created by Pollitt James on 19/05/2017.
//  Copyright © 2017 Pollitt James. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Outlets for user customisation options
    @IBAction func redBtn(sender: UIButton) {
        colour = "red"
        self.tableView.reloadData()
        NSUserDefaults.standardUserDefaults().setValue("red", forKey: "background")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    @IBAction func blueBtn(sender: UIButton) {
        colour = "blue"
        self.tableView.reloadData()
        NSUserDefaults.standardUserDefaults().setValue("blue", forKey: "background")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    @IBAction func greenBtn(sender: UIButton) {
        colour = "green"
        self.tableView.reloadData()
        NSUserDefaults.standardUserDefaults().setValue("green", forKey: "background")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    @IBAction func greyBtn(sender: UIButton) {
        colour = "grey"
        self.tableView.reloadData()
        NSUserDefaults.standardUserDefaults().setValue("white", forKey: "background")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    @IBAction func restoreBtn(sender: UIBarButtonItem) {
        // set the arrays to the defaults
        homeOptions = ["Location", "News", "Office", "Weather"]
        homeOptionsImages = ["images/location.png", "images/news.png", "images/office.png", "images/weather.png"]
        homeOptionsSub = [city, "Latest news", "Control your office", "\(self.temp)℃ | " + weatherType]
        NSUserDefaults.standardUserDefaults().setObject(homeOptions, forKey: "options")
        NSUserDefaults.standardUserDefaults().setObject(homeOptionsSub, forKey: "options sub")
        NSUserDefaults.standardUserDefaults().setObject(homeOptionsSub, forKey: "options images")
        NSUserDefaults.standardUserDefaults().setValue("white", forKey: "background")
        NSUserDefaults.standardUserDefaults().synchronize()
        tableView.reloadData()
    }
    @IBOutlet weak var restoreButton: UIBarButtonItem!
    
    // date label at top of home page
    @IBOutlet weak var dataLabel: UILabel!
    
    // table view cell reuse identifier
    let reuseIdentifier = "tableViewCell"
    
    // String arrays for home table view
    var homeOptions: [String] = ["Location", "News", "Office", "Weather"]
    var homeOptionsImages: [String] = ["images/location.png", "images/news.png", "images/office.png", "images/weather.png"]
    var homeOptionsSub:[String] = ["Location", "The Latest Headlines", "Control Your Office", "Weather from WorldWeatherOnline"]
    
    var locationPos: Int? = 0
    var newsPos: Int? = 1
    var officePos: Int? = 2
    var weatherPos: Int? = 3
    
    // variable for setting colour of table cells
    var colour: String = ""
    
    // get the date & format
    let date = NSDate()
    let dateFormatter = NSDateFormatter()
    var localDate: String = ""
    
    // get location
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    let geocoder = CLGeocoder()
    // Hardcoded variables due to simulator
    var city: String = "Salford"
    var country: String = "UK"
    var uniCoords = CLLocationCoordinate2D(latitude: 53.48, longitude: -2.27)
    
    var uvIndex: Int = 0
    var temp: Int = 0
    var weatherType: String = ""
    
    // Edit nav button
    @IBAction func startEditing(sender: UIBarButtonItem) {
        self.editing = !self.editing
        if(self.editing){
            tableView.setEditing(true, animated: true)
        }
        else {
            tableView.setEditing(false, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSUserDefaults.standardUserDefaults().synchronize()
        homeOptions = NSUserDefaults.standardUserDefaults().objectForKey("options") as? [String] ?? [String]()
        homeOptionsSub = NSUserDefaults.standardUserDefaults().objectForKey("options sub") as? [String] ?? [String]()
        homeOptionsImages = NSUserDefaults.standardUserDefaults().objectForKey("options images") as? [String] ?? [String]()
        if(homeOptions.count == 0){
            self.restoreBtn(restoreButton)
        }
        
        // Date code set up
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateFormatter.timeZone = NSTimeZone()
        localDate = dateFormatter.stringFromDate(date)
        dataLabel.text = localDate
        
        // Location code set up
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        //reverseGeocode()
        let urlPath = WeatherURL(lat: String(uniCoords.latitude), long: String(uniCoords.longitude)).getFullURL()
        let url: NSURL = NSURL(string: urlPath)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        let queue:NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: {(response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    //print("Async: \(jsonResult)")
                    if let data = jsonResult["data"] as? Dictionary<String, AnyObject>{
                        if let conditions = data["current_condition"] as? [Dictionary<String, AnyObject>]{
                            if let cTemp = conditions[0]["temp_C"] as? String {
                                if let cTempp = Int(cTemp){
                                    self.temp = cTempp
                                    print("cTempp = \(cTempp)")
                                    print("temp = \(self.temp)")
                                }
                            }
                            if let desc = conditions[0]["weatherDesc"] as? String {
                                self.weatherType = desc
                            }
                        }
                    }
                }
                // set array for sub headings
                self.homeOptionsSub = [self.city, "The latest news", "Control your office", "\(self.temp)℃ | Partly cloudy"]
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
        })
        
        if let key = NSUserDefaults.standardUserDefaults().objectForKey("background"){
            if key as! String == "red" {
                colour = "red"
            }
            else if key as! String == "blue" {
                colour = "blue"
            }
            else if key as! String == "green" {
                colour = "green"
            }
            else if key as! String == "white" {
                colour = "white"
            }
            else {
                colour = ""
            }
            tableView.reloadData()
        }
        
        tableView.reloadData()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        print("Location changed")
        if status == .AuthorizedAlways
        {
            print("auth")
        }
        else if status == .Denied
        {
            let alert = UIAlertController(title: "Error", message: "Go to Settings to allow this app to access your location", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: HomeTableViewCell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! HomeTableViewCell
        
        // Style table view cells to user custom
        cell.cellTitleLabel?.text = homeOptions[indexPath.row]
        cell.cellSubLabel?.text = homeOptionsSub[indexPath.row]
        cell.cellImage.image = UIImage(named: homeOptionsImages[indexPath.row])
        
        cell.selectionStyle = .None
        if(colour == "red"){
            cell.backgroundColor = UIColor.redColor()
            cell.cellTitleLabel?.textColor = UIColor.blackColor()
            cell.cellSubLabel?.textColor = UIColor.whiteColor()
        }
        else if(colour == "blue"){
            cell.backgroundColor = UIColor.blueColor()
            cell.cellTitleLabel?.textColor = UIColor.whiteColor()
            cell.cellSubLabel?.textColor = UIColor.grayColor()
        }
        else if(colour == "green"){
            cell.backgroundColor = UIColor.greenColor()
            cell.cellTitleLabel?.textColor = UIColor.blackColor()
            cell.cellSubLabel?.textColor = UIColor.darkGrayColor()
        }
        else {
            cell.backgroundColor = UIColor.clearColor()
            cell.cellTitleLabel?.textColor = UIColor.blackColor()
            cell.cellSubLabel?.textColor = UIColor.grayColor()
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        print("IndexPath = \(indexPath)")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeOptions.count
    }
    
    // Move an item in the table
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let itemToMove = homeOptions[sourceIndexPath.row]
        homeOptions.removeAtIndex(sourceIndexPath.row)
        homeOptionsImages.removeAtIndex(sourceIndexPath.row)
        homeOptionsSub.removeAtIndex(sourceIndexPath.row)
        homeOptions.insert(itemToMove, atIndex: destinationIndexPath.row)
        homeOptionsImages.insert(itemToMove, atIndex: destinationIndexPath.row)
        homeOptionsSub.insert(itemToMove, atIndex: destinationIndexPath.row)

        if(locationPos != nil){
            locationPos = homeOptions.indexOf("Location")!
        }
        if(newsPos != nil){
            newsPos = homeOptions.indexOf("News")!
        }
        if(officePos != nil){
            officePos = homeOptions.indexOf("Office")!
        }
        if(weatherPos != nil){
            weatherPos = homeOptions.indexOf("Weather")!
        }
        NSUserDefaults.standardUserDefaults().setObject(homeOptions, forKey: "options")
        NSUserDefaults.standardUserDefaults().setObject(homeOptionsSub, forKey: "options sub")
        NSUserDefaults.standardUserDefaults().setObject(homeOptionsSub, forKey: "options images")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // Delete an item from the table
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            homeOptions.removeAtIndex(indexPath.row)
            homeOptionsImages.removeAtIndex(indexPath.row)
            homeOptionsSub.removeAtIndex(indexPath.row)
            
            if(indexPath.row == locationPos) {
                locationPos = nil
            }
            else if (indexPath.row == newsPos){
                newsPos = nil
            }
            else if(indexPath.row == officePos){
                officePos = nil
            }
            else if(indexPath.row == weatherPos){
                weatherPos = nil
            }
            NSUserDefaults.standardUserDefaults().setObject(homeOptions, forKey: "options")
            NSUserDefaults.standardUserDefaults().setObject(homeOptionsSub, forKey: "options sub")
            NSUserDefaults.standardUserDefaults().setObject(homeOptionsSub, forKey: "options images")
            NSUserDefaults.standardUserDefaults().synchronize()
            self.tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // check for actual values because of edit mode
        if(indexPath.row == locationPos){
            tabBarController!.selectedIndex = 1
        }
        else if(indexPath.row == newsPos){
            tabBarController!.selectedIndex = 2
        }
        else if(indexPath.row == officePos){
            tabBarController!.selectedIndex = 3
        }
        else if(indexPath.row == weatherPos){
            tabBarController!.selectedIndex = 4
        }
    }
    
    func getCity() -> String {
        return city
    }
    
    func getCountry() -> String {
        return country
    }
    
    func getTemp() -> String {
        return "\(temp)"
    }
    
    func getTempInt() -> Int {
        return temp
    }
    
    func getWeatherData(){
        //let url = WeatherURL(lat: String(uniCoords.latitude), long: String(uniCoords.longitude)).getFullURL()
    }
    
    func reverseGeocode(){
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Authorized || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways) {
            currentLocation = locationManager.location!
            // Reverse geocode location uses the coordinates to get an actual place name
            geocoder.reverseGeocodeLocation(currentLocation, completionHandler: { (placemarks, error) -> Void in
                var placemark: CLPlacemark!
                placemark = placemarks?[0]
                self.city = (placemark.addressDictionary!["City"] as? String)!
                print(self.city)
                self.country = (placemark.addressDictionary!["Country"] as? String)!
                print(self.country)
            })
        }
    }
}
