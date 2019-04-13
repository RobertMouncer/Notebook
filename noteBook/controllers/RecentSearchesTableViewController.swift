//
//  RecentSearchesTableViewController.swift
//  noteBook
//
//  Created by rdm10 on 10/04/2019.
//  Copyright © 2019 rdm10. All rights reserved.
//

import UIKit
import CoreData
class RecentSearchesTableViewController: UITableViewController {
    
    var managedContext: NSManagedObjectContext?
    var fetchedResultsController: NSFetchedResultsController<RecentSearch>?
    
    var client: GuardianContentClient!
    
    var data: GuardianOpenPlatformData!


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        client = GuardianContentClient(verbose: true)
        //from gitlab. Author - Neil Taylor
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            print("error - unable to access failure")
            exit(EXIT_FAILURE)
        }
        
        managedContext = delegate.persistentContainer.viewContext
        
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<RecentSearch>(entityName: "RecentSearch")

        let sortDescriptor = NSSortDescriptor(key: "dateOfSearch", ascending: false, selector: #selector(NSString.localizedCompare(_:)))
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        performFetchForController()
    }
    
    //from gitlab. Author - Neil Taylor
    func performFetchForController() {
        do {
            try fetchedResultsController?.performFetch()
            tableView.reloadData()
        }
        catch let error as NSError {
            print("The error was: \(error)")
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("\(fetchedResultsController?.fetchedObjects?.count ?? 0)")
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! ResultsCellTableViewCell
        
        let search = fetchedResultsController?.object(at: indexPath)
        
        cell.Title?.text = search?.searchTerm ?? "Unknown"
        cell.subtitle?.text = "Filter Used:\((search?.filterUsed)!)"
        let cacheStored = ((search?.cacheKey) != nil) ? true : false
        cell.cached?.text = "Cache stored:\(cacheStored)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO update dateOfSearch when a search is done from cache or from HTTP request.
        fetchedResultsController?.object(at: indexPath).setValue(Date(), forKey: "dateOfSearch")
        
        do {
            try self.managedContext?.save()
        }
        catch let error as NSError {
            print("Error saving speaker item: \(error)")
        }
        
        
        
        let filters = GuardianContentFilters()
        filters.showElements = .all
        filters.pageSize = 50
        
        let search = fetchedResultsController?.object(at: indexPath)
        
        if search?.filterUsed ?? false {
            filters.toDate = search?.toDate
            filters.fromDate = search?.fromDate
            
            if let order = search?.orderBy {
                filters.orderBy = GuardianContentOrderFilter(rawValue: order)
            }
            filters.showFields = search?.fields
            
        }
        var ping: Pinger!
        ping = Pinger()
        
        ping.pingHost(){
            (pinged) in
            if pinged ?? false {
                self.loadContent(filters: filters, searchTerm: search?.searchTerm){
                    success  in
                    if self.data.response.status == "ok" && self.data != nil {
                        DispatchQueue.main.async {
                            
                            self.performSegue(withIdentifier: "showResultsFromRecent", sender: Any?.self)
                        }
                    }
                }
            } else {
                print ("internet down - use cached content")
                DispatchQueue.main.async {

                    if let cacheKey = search?.cacheKey {
                        print(cacheKey)
                        do{
                            if let cacheCopy = UserDefaults.standard.object(forKey: cacheKey) as? Data{
                                let decoder = JSONDecoder()
                                let data = try decoder.decode(GuardianOpenPlatformData.self, from: cacheCopy)
                                print(data.response.status)
                                self.data = data
                            } else {
                                print("failed to find cache")
                            }
                        } catch  {
                            print("Error when loading from cache")
                        }

                        self.performSegue(withIdentifier: "showResultsFromRecent", sender: Any?.self)
                    }
                    
                    print("must use cached content")
                }
            }
            
        }
        
    }
    
    
    func loadContent(filters: GuardianContentFilters, searchTerm: String?,completionHandler: @escaping (Bool)->())  {
        do {
            if let term = searchTerm {
                try client.searchContent(for: term, usingFilters: filters) {
                    (data, rawData) in
                    if let downloadedData = data {
                        self.data = downloadedData
                        completionHandler(true)
                    }
                    else {
                        print("problem accessing the data")
                        completionHandler(false)
                    }
                }
            }
        }
        catch let error {
            print("\(error)")
            completionHandler(false)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let view = segue.destination as? ReturnedArticlesTableViewController {
            view.data = self.data
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidLoad()
        
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
