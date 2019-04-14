//
//  AllNotesTableViewController.swift
//  noteBook
//
//  Created by rdm10 on 06/04/2019.
//  Copyright © 2019 rdm10. All rights reserved.
//





import UIKit
import CoreData

class AllNotesTableViewController: UITableViewController,UISearchBarDelegate {

    var managedContext: NSManagedObjectContext?
    var fetchedResultsController: NSFetchedResultsController<Notes>?
    
    @IBOutlet var searchBar: UISearchBar!
    
    var filteredData: [Notes]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            print("error - unable to access failure")
            exit(EXIT_FAILURE)
        }
        
        managedContext = delegate.persistentContainer.viewContext
        //from gitlab. Author - Neil Taylor
        let fetchRequest = NSFetchRequest<Notes>(entityName: "Notes")

        let sortDescriptor = NSSortDescriptor(key: "lastModified", ascending: false, selector: #selector(NSString.localizedCompare(_:)))
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        performFetchForController()
        filteredData = fetchedResultsController?.fetchedObjects
        tableView.reloadData()
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
        return 1
    }

   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //this will be called before the data has been retrieved and the tableview has been reloaded.
        if filteredData != nil {
            return filteredData.count
        }
        return 0
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath)

        let note = filteredData[indexPath.row]
        cell.textLabel?.text = note.title ?? "Unknown"
        cell.detailTextLabel?.text = note.notes ?? "Unknown"
        return cell
    }
    
    // this is needed to refresh the view
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewDidLoad()
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let view = segue.destination as? NotesDetailsTableViewController,
            let indexPath = tableView.indexPathForSelectedRow {

            view.notesItem = filteredData[indexPath.row]
        }
    }
    //https://stackoverflow.com/a/41666125
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let data = fetchedResultsController?.fetchedObjects
        filteredData = searchText.isEmpty ? data : []
        let searchTextLower = searchText.lowercased()
        for item in data! {
            if (item.notes!.lowercased()).contains(searchTextLower) || (item.title!.lowercased()).contains(searchTextLower){
                filteredData.append(item)
            }
        }
        tableView.reloadData()
    }
    
}
