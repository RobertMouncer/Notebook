//
//  ReturnedArticlesTableViewController.swift
//  noteBook
//
//  Created by rdm10 on 08/04/2019.
//  Copyright © 2019 rdm10. All rights reserved.
//

import UIKit
import CoreData
class ReturnedArticlesTableViewController: UITableViewController {

    var data:GuardianOpenPlatformData!
    var managedContext: NSManagedObjectContext?

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        process(data: self.data)
        
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            print("error - unable to access failure")
            exit(EXIT_FAILURE)
        }
        
        managedContext = delegate.persistentContainer.viewContext

    }

//    func process(data: GuardianOpenPlatformData) {
//        var textToDisplay = ""
//
//        textToDisplay += "Page: \(data.response.currentPage ?? 0) of \(data.response.pages ?? 0)\n"
//
//        if let results = data.response.results {
//            textToDisplay += "Found \(results.count) results\n"
//            results.forEach({ (result) in
//
//                textToDisplay += result.webTitle
//                if let url = result.webUrl {
//                    textToDisplay += "\t\(url)\n"
//                }
//            })
//        }
//
//
//    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.response.results?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ResultsCellTableViewCell
        cell.Title.text = data.response.results?[indexPath.row].webTitle
        let url = (data.response.results?[indexPath.row].webUrl)?.absoluteString
        cell.subtitle.text = url
//        cell.Url =

        return cell
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let view = segue.destination as? SingleArticleTableViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            let art = data.response.results?[indexPath.row]
            view.articleResult = art
            let entity = NSEntityDescription.entity(forEntityName: "Article", in: managedContext!)
            let singArt = Article(entity: entity!, insertInto: nil)
            
            singArt.webTitle = art?.webTitle
            singArt.webUrl = (art?.webUrl)?.absoluteString
            
            singArt.shortUrl = (art?.fields?.shortUrl)?.absoluteString
            singArt.trailText = art?.fields?.trailText
            singArt.lastModified = art?.fields?.lastModified
            
            if ((art?.fields?.wordcount) != nil) {
                let x = Int((art?.fields?.wordcount)!)
                singArt.wordCount = (Int32(x))
            }

            singArt.bodyText = art?.fields?.bodyText
            
            view.singleArticle = singArt
        }
    }
    

}
