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
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        print(singleArticle?.wordCount ?? 0)
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
        
        let article = Article(entity: Article.entity(), insertInto: self.managedContext)
        article.webTitle = singleArticle.webTitle
        article.webUrl = singleArticle.webUrl
        article.shortUrl = singleArticle.shortUrl
        article.bodyText = singleArticle.bodyText
        article.trailText = singleArticle.trailText
        article.lastModified = singleArticle.lastModified
        article.wordCount = singleArticle.wordCount
        
        
        
        for note in data {
            note.addToArticles(article)
            note.setValue(Date(), forKey: "lastModified")
        }

        do {
            try self.managedContext?.save()
        }
        catch let error as NSError {
            print("Error saving speaker item: \(error)")
        }
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}
