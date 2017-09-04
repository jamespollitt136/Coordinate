//
//  NewsViewController.swift
//  coordinate
//
//  Created by Pollitt James on 26/05/2017.
//  Copyright © 2017 Pollitt James. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var newsHeaderImage: UIImageView!
    @IBOutlet weak var sourcePicker: UIPickerView!
    @IBOutlet weak var newsTable: UITableView!
    
    let reuseIdentifier = "newsTableCell"
    
    let pickerSources = ["BBC News", "CNN", "Entertainment Weekly", "ESPN", "Independent", "Mashable", "MTV News", "Recode", "TechCrunch", "The New York Times", "The Times of India", "The Verge"]
    let sourcesURL = ["bbc-news", "cnn", "entertainment-weekly", "espn", "independent", "mashable", "mtv-news", "recode", "techcrunch", "the-new-york-times", "the-times-of-india", "the-verge"]
    
    var country: String = ""
    
    var chosenSource: String = ""
    var chosenUrl: String = ""
    
    var author: String = ""
    var articleTitleStr: String = ""
    var articleDescStr: String = ""
    var imageUrl: String = ""
    
    var titles: [String] = []
    var authors: [String] = []
    var descriptions: [String] = []
    var images: [String] = []
    var urls: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let homeController: FirstViewController = FirstViewController(nibName: nil, bundle: nil)
        self.country = homeController.getCountry()
        if(self.country.lowercaseString == "united kingdom" || self.country.lowercaseString == "uk"){
            chosenSource = "bbc-news"
            newsHeaderImage.image = UIImage(named: "images/bbcnews.png")
        }
        else if(self.country.lowercaseString == "united states" || self.country.lowercaseString == "us" || self.country.lowercaseString == "usa") {
            chosenSource = "the-new-york-times"
            newsHeaderImage.image = UIImage(named: "images/nyt.png")
        }
        else if(self.country.lowercaseString == "india") {
            chosenSource = "the-times-of-india"
            newsHeaderImage.image = UIImage(named: "images/ttoi.png")
        }
        else {
            chosenSource = ""
            newsHeaderImage.image = UIImage(named: "images/newsbg.png")
        }
        getNews()
        newsTable.reloadData()
        newsTable.dataSource = self
        newsTable.delegate = self
        sourcePicker.dataSource = self
        sourcePicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNews(){
        authors = []
        titles = []
        descriptions = []
        images = []
        urls = []
        
        let urlPath = NewsURL(source: chosenUrl).getFullURL()
        print(urlPath)
        let url: NSURL = NSURL(string: urlPath)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        let queue: NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: {(response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary{
                    if let articles = jsonResult["articles"] as? [Dictionary<String, AnyObject>]{
                        if let author1 = articles[0]["author"] as? String {
                            self.authors.append(author1)
                        }
                        if let title1 = articles[0]["title"] as? String {
                            self.articleTitleStr = title1
                            self.titles.append(title1)
                        }
                        if let desc1 = articles[0]["description"] as? String {
                            self.articleDescStr = desc1
                            self.descriptions.append(desc1)
                        }
                        if let image1 = articles[0]["urlToImage"] as? String {
                            self.images.append(image1)
                        }
                        if let url1 = articles[0]["url"] as? String {
                            self.urls.append(url1)
                        }
                        if let author2 = articles[1]["author"] as? String {
                            self.authors.append(author2)
                        }
                        if let title2 = articles[1]["title"] as? String {
                            self.articleTitleStr = title2
                            self.titles.append(title2)
                        }
                        if let desc2 = articles[1]["description"] as? String {
                            self.articleDescStr = desc2
                            self.descriptions.append(desc2)
                        }
                        if let image2 = articles[1]["urlToImage"] as? String {
                            self.images.append(image2)
                        }
                        if let url2 = articles[1]["url"] as? String {
                            self.urls.append(url2)
                        }
                        if let author3 = articles[2]["author"] as? String {
                            self.authors.append(author3)
                        }
                        if let title3 = articles[2]["title"] as? String {
                            self.articleTitleStr = title3
                            self.titles.append(title3)
                        }
                        if let desc3 = articles[2]["description"] as? String {
                            self.articleDescStr = desc3
                            self.descriptions.append(desc3)
                        }
                        if let image3 = articles[2]["urlToImage"] as? String {
                            self.images.append(image3)
                        }
                        if let url3 = articles[2]["url"] as? String {
                            self.urls.append(url3)
                        }
                        if let author4 = articles[3]["author"] as? String {
                            self.authors.append(author4)
                        }
                        if let title4 = articles[3]["title"] as? String {
                            self.articleTitleStr = title4
                            self.titles.append(title4)
                        }
                        if let desc4 = articles[3]["description"] as? String {
                            self.articleDescStr = desc4
                            self.descriptions.append(desc4)
                        }
                        if let image4 = articles[3]["urlToImage"] as? String {
                            self.images.append(image4)
                        }
                        if let url4 = articles[3]["url"] as? String {
                            self.urls.append(url4)
                        }
                    }
                }
                self.newsTable.reloadData()
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
        })
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerSources.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerSources[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosenSource = pickerSources[row]
        chosenUrl = "source=" + sourcesURL[row]
        
        if(chosenSource.lowercaseString == "bbc news"){
            newsHeaderImage.image = UIImage(named: "images/bbcnews.png")
        }
        else if(chosenSource.lowercaseString == "cnn"){
            newsHeaderImage.image = UIImage(named: "images/cnn.png")
        }
        else if(chosenSource.lowercaseString == "entertainment weekly"){
            newsHeaderImage.image = UIImage(named: "images/entw.png")
        }
        else if(chosenSource.lowercaseString == "espn"){
            newsHeaderImage.image = UIImage(named: "images/espn.png")
        }
        else if(chosenSource.lowercaseString == "independent"){
            newsHeaderImage.image = UIImage(named: "images/indy.png")
        }
        else if(chosenSource.lowercaseString == "mashable"){
            newsHeaderImage.image = UIImage(named: "images/mashable.png")
        }
        else if(chosenSource.lowercaseString == "mtv news"){
            newsHeaderImage.image = UIImage(named: "images/mtvnews.png")
        }
        else if(chosenSource.lowercaseString == "recode"){
            newsHeaderImage.image = UIImage(named: "images/recode.png")
        }
        else if(chosenSource.lowercaseString == "the new york times"){
            newsHeaderImage.image = UIImage(named: "images/nyt.png")
        }
        else if(chosenSource.lowercaseString == "the times of india"){
            newsHeaderImage.image = UIImage(named: "images/ttoi.png")
        }
        else if(chosenSource.lowercaseString == "techcrunch"){
            newsHeaderImage.image = UIImage(named: "images/techcrunch.png")
        }
        else if(chosenSource.lowercaseString == "the verge"){
            newsHeaderImage.image = UIImage(named: "images/theverge.png")
        }
        getNews()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: NewsTableViewCell = newsTable.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NewsTableViewCell
        
        cell.newsTitleLabel?.text = titles[indexPath.row]
        cell.newsAuthor?.text = authors[indexPath.row]
        cell.newsDescription?.text = descriptions[indexPath.row]
        let url = NSURL(string: images[indexPath.row])
        let image = NSData(contentsOfURL: url!)
        cell.newsImage?.image = UIImage(data: image!)
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        UIApplication.sharedApplication().openURL(NSURL(string: urls[indexPath.row])!)
    }
}
