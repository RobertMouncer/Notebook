//
//  NotesDetailsTableViewController.swift
//  noteBook
//
//  Created by rdm10 on 07/04/2019.
//  Copyright © 2019 rdm10. All rights reserved.
//

import UIKit
import CoreData
class NotesDetailsTableViewController: UITableViewController {
    
    var notesItem: Notes?
    var articleResult: GuardianOpenPlatformResult!
     var managedContext: NSManagedObjectContext?
    
    @IBOutlet weak var titleTextView: UITextView!
    
    @IBOutlet weak var notesTextView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            print("error - unable to access failure")
            exit(EXIT_FAILURE)
        }
        
        managedContext = delegate.persistentContainer.viewContext
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        titleTextView.text = notesItem?.title
        notesTextView.text = notesItem?.notes
    }
    
    override func viewDidLayoutSubviews() {
        titleTextView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        notesTextView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notesItem?.articles?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)

        cell.textLabel?.text = (notesItem?.articles?.object(at: indexPath.row) as! Article).webTitle ?? "Unknown"

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let view = segue.destination as? SingleArticleTableViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            let articleToPass = (notesItem?.articles?.object(at: indexPath.row) as! Article)
            view.singleArticle = articleToPass
                       
            
        }
        if let view = segue.destination as? AddNotesViewController{
            view.noteToEdit = notesItem
        }
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int)
        -> String? {
            return "Article URL's"
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                notesItem?.removeFromArticles(notesItem?.articles?.object(at: indexPath.row) as! Article)
                notesItem?.setValue(Date(), forKey: "lastModified")
                try managedContext?.save()
                print("deleted url")
            }
            catch let error as NSError {
                print("error with \(error)")
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    //http://swiftdeveloperblog.com/code-examples/create-uialertcontroller-with-ok-and-cancel-buttons-in-swift/
    @IBAction func btnPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Are you sure?", message: "What would you like to do?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete Note", style: .destructive) { (action:UIAlertAction!) in
            print("Delete button tapped");
            self.deleteNote()
            
        }
        alertController.addAction(deleteAction)
    
        // Create Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button tapped");
        }
        alertController.addAction(cancelAction)
        
        // Present Dialog message
        self.present(alertController, animated: true, completion:nil)
    
    }
    
    func deleteNote(){
        do{
            self.managedContext?.delete(self.notesItem!)
            try self.managedContext?.save()
        } catch {
            
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewDidLoad()
    }

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
