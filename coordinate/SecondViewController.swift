//
//  SecondViewController.swift
//  coordinate
//
//  Created by Pollitt James on 19/05/2017.
//  Copyright © 2017 Pollitt James. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// Protocol for searching the map with the search bar
protocol SearchMap {
    func dropPinZoomIn(placemark: MKPlacemark)
}

class SecondViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    var resultSearchController: UISearchController? = nil
    
    var selectedPin: MKPlacemark? = nil
    
    @IBOutlet weak var mapView: MKMapView!
    
    let uniLocation = CLLocationCoordinate2DMake(53.485725, -2.273311)
    var userLoc = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    let pin = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        // Display a pin on location
        pin.coordinate = uniLocation //comment this line if you are running on physical device
        
        // uncomment the next 2 lines if you are running on physical device
        //var userLocation = CLLocationCoordinate2DMake(userLoc.latitude, userLoc.longitude)
        //dropPin.coordinate = userLocation
        
        pin.title = "You are here"
        mapView.addAnnotation(pin)
        // zoom in to map
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
        
        let locationSearchTable = storyboard!.instantiateViewControllerWithIdentifier("LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        
        locationSearchTable.mapSearchDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.localizedDescription)
    }
    
    // Need to make some changes to get it to work on simulater
    func getDirections(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMapsWithLaunchOptions(launchOptions)
        }
    }
}

// Extension for searching the map via navigation search bar
extension SecondViewController: SearchMap {
    // drop a pin on selected item from search
    func dropPinZoomIn(placemark: MKPlacemark) {
        selectedPin = placemark
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}

// Extension for working with the Apple Maps App to get directions: NEEDS CHANGES TO WORK ON SIM
extension SecondViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseIdentifier = "pin"
        var pin = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier) as? MKPinAnnotationView
        pin?.pinTintColor = UIColor.cyanColor()
        pin?.canShowCallout = true
        let square = CGSize(width: 50, height: 50)
        let button = UIButton(frame: CGRect(origin: CGPointZero, size: square))
        button.setBackgroundImage(UIImage(named: "images/car.png"), forState: .Normal)
        button.addTarget(self, action: "getDirections", forControlEvents: .TouchUpInside)
        pin?.leftCalloutAccessoryView = button
        return pin
    }
}

