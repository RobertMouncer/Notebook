//
//  SingleArticleTableViewController.swift
//  noteBook
//
//  Created by rdm10 on 09/04/2019.
//  Copyright © 2019 rdm10. All rights reserved.
//

import UIKit
import CoreData

class SingleArticleTableViewController: UITableViewController, DataChangedDelegate {
    
    var singleArticle: Article!
    var articleResult: GuardianOpenPlatformResult!
    var headings = [String: String]()
    var order = ["webTitle","webUrl","trailText","shortUrl","lastModified","wordcount","bodyText"]
    
    var managedContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableView.automaticDimension
        removeHeadings()
        
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            print("error - unable to access failure")
            exit(EXIT_FAILURE)
        }
        
        managedContext = delegate.persistentContainer.viewContext

    }
    func removeHeadings(){

        headings["webTitle"] = singleArticle?.webTitle
        headings["webUrl"] = singleArticle?.webUrl
        
        headings["bodyText"] = singleArticle?.bodyText
        headings["trailText"] = singleArticle?.trailText
        headings["shortUrl"] = singleArticle?.shortUrl
        if let date = singleArticle?.lastModified {
            headings["lastModified"] = "\(date)"
        }
        if let count = singleArticle?.wordCount {
            if count > 0{
                headings["wordcount"] = "\(count)"
            }
        }
        //as dictionaries aren't always kept in order. Order has been used to make sure that the items are displayed in the order I want them to be. This loops through the dictionary checking if the heading exists, if not, remove it from the order
        var i = 0
        var toBeRemoved :[Int] = []
        
        for title in order{
            var found = false
            for key in Array(headings.keys) {
                if title == key || title == "webTitle" || title == "webUrl" {
                    found = true
                    
                }
            }
            if !found {
                toBeRemoved.append(i)
            }
            i = i+1
        }
        
        for item in toBeRemoved.reversed() {
            order.remove(at: item)
        }
        
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int)
        -> String? {
            return order[section]
    }
    override func numberOfSections(in tableView: UITableView) -> Int {

        return order.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! SingleArticleTableViewCell
        
        let keyToFind = order[indexPath.section]
        for (key, value) in headings {

            if key == keyToFind {
                cell.label?.text = value
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

        if order.firstIndex(of: "webUrl") == indexPath.section {
            if let url = URL(string: headings["webUrl"]!)
            {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
            }
        }
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? SelectionDoneCancelViewController {
            controller.delegate = self
        }
    }
    
    // MARK: - DataChangedDelegate
    
    func dataChanged(_ data: [Notes]) {
        if data == []{
            print("No Notes returned")
            return
        }
        let fetchRequest = NSFetchRequest<Article>(entityName: "Article")
        var found = false
        do {
            //gets results - all articles
            let results = try managedContext?.fetch(fetchRequest)
            //checks to see if there are articles
            if results?.count ?? 0 > 0 {
                
                for item in results! {
                    //if the weburl already exists just make a connection
                    // this is to prevent new article instances from being created.
                    if item.webUrl! == singleArticle.webUrl! {
                     found = true
                        item.setValue(singleArticle.webTitle, forKey: "webTitle")
                        item.setValue(singleArticle.shortUrl, forKey: "shortUrl")
                        item.setValue(singleArticle.bodyText, forKey: "bodyText")
                        item.setValue(singleArticle.trailText, forKey: "trailText")
                        item.setValue(singleArticle.lastModified, forKey: "lastModified")
                        item.setValue(singleArticle.wordCount, forKey: "wordCount")
                        
                        for note in data {
                            print("added old")
                            note.addToArticles(item)
                            note.setValue(Date(), forKey: "lastModified")
                        }
                    }
                }
            }
            
        }
        catch let error as NSError {
            print("\(error)")
        }
        
        if !found{
            let article = Article(entity: Article.entity(), insertInto: self.managedContext)
            article.webTitle = self.singleArticle.webTitle
            article.webUrl = self.singleArticle.webUrl
            article.shortUrl = self.singleArticle.shortUrl
            article.bodyText = self.singleArticle.bodyText
            article.trailText = self.singleArticle.trailText
            article.lastModified = self.singleArticle.lastModified
            article.wordCount = self.singleArticle.wordCount
            article.dateAssigned = Date()
            
            for note in data {
                print("added new")
                note.addToArticles(article)
                note.setValue(Date(), forKey: "lastModified")
            }
        }

        do {
            try self.managedContext?.save()
        }
        catch let error as NSError {
            print("Error saving note item: \(error)")
        }
        
    }
    


}
