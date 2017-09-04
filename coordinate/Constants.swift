//
//  Constants.swift
//  coordinate
//
//  Created by Pollitt James on 23/05/2017.
//  Copyright © 2017 Pollitt James. All rights reserved.
//

import Foundation


struct WeatherURL {
    private let baseURL = "https://api.worldweatheronline.com/premium/v1/weather.ashx"
    private let key = "&key=c52db74b7d42491c8fb150119172305"
    private let numOfDaysForecast = "&num_of_days=1"
    private let format = "&format=json"
    private var coordStr = ""
       
    init (lat: String, long: String){
        self.coordStr = "?q=\(lat),\(long)"
    }
    
    func getFullURL()->String{
        return baseURL + coordStr + key + numOfDaysForecast + format
    }
}

struct OfficeTreeURL {
    private let baseURL = "http://www.chrisjhughes.co.uk/api/tree"
    private let key = "?key=KHbqJIUWcj59259278eabc9"
    private let fields = "&fields=AmbientLight|ExternalLight|SoilMoisture|HardwareTemperature|AmbientHumidity|AmbientTemperature"
    private let format = "&format=json"
    
    func getFullURL() -> String {
        return baseURL + key + fields + format
    }
}

struct NewsURL {
    private let baseURL = "https://newsapi.org/v1/articles?"
    private let key = "&apiKey=449263ed52f74b619af0fd494cbac98c"
    //private let sort = "&sortBy=latest"
    private var source = "source=techcrunch"
    
    func getFullURL() -> String {
        return baseURL + source + key
    }
    
    init(source: String){
        self.source = source
    }
}