//
//  NotesViewController.swift
//  noteBook
//
//  Created by rdm10 on 06/04/2019.
//  Copyright © 2019 rdm10. All rights reserved.
//

import UIKit
import CoreData

class AddNotesViewController: UIViewController {
    
    @IBOutlet weak var notesTV: UITextView!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet var errorLabel: UILabel!
    
    var managedContext: NSManagedObjectContext?
    var noteToEdit: Notes?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            print("error - unable to access failure")
            exit(EXIT_FAILURE)
        }
        
        managedContext = delegate.persistentContainer.viewContext
        
        // https://stackoverflow.com/a/26686986 - found this answer to get the UItextview to look like a textfield on app load
        notesTV.layer.cornerRadius = 5
        notesTV.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        notesTV.layer.borderWidth = 0.5
        notesTV.clipsToBounds = true

        if noteToEdit != nil {
            titleTF.text = noteToEdit?.title
            notesTV.text = noteToEdit?.notes
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func saveNote(_ sender: UIBarButtonItem) {
        let string = (titleTF.text)?.trimmingCharacters(in: .whitespaces)
        if (string?.isEmpty)! {
            errorLabel.isHidden = false
            return
        }
        if noteToEdit != nil {
            noteToEdit?.setValue(titleTF.text, forKey: "title")
            noteToEdit?.setValue(notesTV.text, forKey: "notes")
            noteToEdit?.setValue(Date(), forKey: "lastModified")
        }else {
            let note = Notes(entity: Notes.entity(), insertInto: managedContext)
            note.title = titleTF.text
            note.notes = notesTV.text
            note.lastModified = Date()
            note.dateCreated = Date()
        }
        
        do {
            try managedContext?.save()
            print("added note")
        }
        catch let error as NSError {
            print("error with \(error)")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelNote(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
}
