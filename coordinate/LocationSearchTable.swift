//
//  LocationSearchTable.swift
//  coordinate
//
//  Created by Pollitt James on 28/05/2017.
//  Copyright © 2017 Pollitt James. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class LocationSearchTable: UITableViewController {
    var matchingResults: [MKMapItem] = []
    var mapView: MKMapView? = nil
    
    var mapSearchDelegate: SearchMap? = nil
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        // format address from results
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(format:"%@%@%@%@%@%@%@", selectedItem.subThoroughfare ?? "", firstSpace, selectedItem.thoroughfare ?? "", comma, selectedItem.locality ?? "", secondSpace, selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
    
}

extension LocationSearchTable : UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else {
                return
        }
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { response, _ in
            guard let response = response else {
                return
            }
            self.matchingResults = response.mapItems
            self.tableView.reloadData()
    }
    }
}

extension LocationSearchTable {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingResults.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        let selectedResult = matchingResults[indexPath.row].placemark
        cell.textLabel?.text = selectedResult.name
        cell.detailTextLabel?.text = parseAddress(selectedResult)
        return cell
    }
}

extension LocationSearchTable {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedResult = matchingResults[indexPath.row].placemark
        mapSearchDelegate?.dropPinZoomIn(selectedResult)
        dismissViewControllerAnimated(true, completion: nil)
    }
}