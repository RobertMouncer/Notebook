//
//  SelectionDoneCancelViewController.swift
//  PassingDataBetweenScenes
//
//  Created by Neil Taylor on 05/03/2016.
//  Copyright © 2016 Aberystwyth University. All rights reserved.
//

import UIKit
import CoreData
// This is a superclass for the two real controllers - SingleSelectionViewController
// MultipleSelectionViewController.
class SelectionDoneCancelViewController: UIViewController {
    
    struct noteSelected {
        var note: Notes
        var selected: Bool
        
    }
    // The delegate that will receive information about which data
    // items have been selected.
    var delegate: DataChangedDelegate?
    
    // A list of items that can be selected.
    var items: [noteSelected] = []
    
    var managedContext: NSManagedObjectContext?
    var fetchedResultsController: NSFetchedResultsController<Notes>?

    @IBOutlet var tableView: UITableView!
    
    
    // Called once when the view is created.
    // This method will initialise the items array with a set of data.
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            print("error - unable to access failure")
            exit(EXIT_FAILURE)
        }
        
        managedContext = delegate.persistentContainer.viewContext
        //from gitlab. Author - Neil Taylor
        let fetchRequest = NSFetchRequest<Notes>(entityName: "Notes")
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedCompare(_:)))
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        performFetchForController()
        let blankNote = Notes()
        for item in (fetchedResultsController?.fetchedObjects!)!{
            
            
            var i:noteSelected = noteSelected(note: blankNote, selected: false)

            i.note = item
            i.selected = false
            items.append(i)
        }
        
    }

    func performFetchForController() {
        do {
            try fetchedResultsController?.performFetch()
            tableView.reloadData()
        }
        catch let error as NSError {
            print("The error was: \(error)")
        }
    }
    
    // This method is responsible for passing an array of any selected
    // items back to the specified delgate.
    func dismissWithData(_ data: [noteSelected]) {
        dismiss(animated: true, completion: nil)
        
        // Two stage operation to do the following:
        // 1/ Filter the SelectionItem objects in the items array. The result
        //    of the filter is to obtain those in the array where selected is true.
        //
        // 2/ The filtered list is then processed by map. That will extract the
        //    data from the SelectionItem.
        //
        // The result is content, which is an array that contains the Data that
        // was selected. In this example, it is an array of String objects.
        var content: [Notes] = []
        if data.count > 0 {
            
            for item in items {
                if item.selected{
                    content.append(item.note)
                }
            }
            delegate?.dataChanged?(content)
        }
    }
    
    // This method will be linked to the Cancel button on the view.
    // It calls dismissWithData() to return an empty array, indicating
    // that nothing was selected.
    @IBAction func cancelOperation() {
        dismissWithData([])
    }
    
    // This method will be linked to the Done button on the view.
    // It calls dismissWithData() to return the list of items and their
    // current selection status.
    @IBAction func doneOperation() {
        dismissWithData(items)
    }
    
}
