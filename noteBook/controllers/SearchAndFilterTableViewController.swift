//
//  SearchAndFilterTableViewController.swift
//  noteBook
//
//  Created by rdm10 on 08/04/2019.
//  Copyright © 2019 rdm10. All rights reserved.
//

import UIKit

class SearchAndFilterTableViewController: UITableViewController {

    let apiKey = "cb9a43af-3974-482a-8399-1ce3b9af475e"
    
    var client: GuardianContentClient!
    
    @IBOutlet var filtersTableView: UITableView!
    
    @IBOutlet weak var searchTerm: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        client = GuardianContentClient(apiKey: apiKey, verbose: true)
    }
    
    @IBAction func ShowFilters(_ sender: Any) {
        if filtersTableView.isHidden {
            filtersTableView.isHidden = false
        } else {
            filtersTableView.isHidden = true
        }
    }
    
    
    func showText(_ text: String) {
        DispatchQueue.main.async {
            self.textView.text = "\(text)"
        }
    }
    
    func process(data: GuardianOpenPlatformData) {
        
        var textToDisplay = ""
        
        textToDisplay += "Page: \(data.response.currentPage ?? 0) of \(data.response.pages ?? 0)\n"
        
        if let results = data.response.results {
            textToDisplay += "Found \(results.count) results\n"
            results.forEach({ (result) in
                
                textToDisplay += result.webTitle
                if let url = result.webUrl {
                    textToDisplay += "\t\(url)\n"
                }
            })
        }
        
        self.showText(textToDisplay)
    }
    
    
    @IBAction func loadContent(_ sender: UIButton) {
        
        let filters = GuardianContentFilters()
        filters.showElements = .all
        filters.pageSize = 50
        
        do {
            if let term = searchTerm.text {
                try client.searchContent(for: term, usingFilters: filters) {
                    (data) in
                    if let downloadedData = data {
                        self.process(data: downloadedData)
                    }
                    else {
                        self.showText("problem accessing the data")
                    }
                }
            }
        }
        catch let error {
            showText("\(error)")
        }
        
    }
    
    
    /**
     Queries the sections API based on the search term in the view. There are no
     filters available for the sections API.
     
     The `GuardianContentClient` is called with the specified search term. The results
     are displayed in the text view in the app.
     
     - Parameters:
     - sender: The button that started this action
     */
    @IBAction func loadSections(_ sender: UIButton) {
        do {
            if let term = searchTerm.text {
                try client.searchSections(for: term) {
                    (data) in
                    if let downloadedData = data {
                        self.process(data: downloadedData)
                    }
                    else {
                        self.showText("problem accessing the data")
                    }
                }
            }
        }
        catch let error {
            showText("\(error)")
        }
    }
    
    @IBAction func loadTags(_ sender: UIButton) {
        
        let filters = GuardianContentTagFilters()
        filters.section = "film"
        filters.pageSize = 50
        
        do {
            if let term = searchTerm.text {
                try client.searchTags(for: term, usingFilters: filters) {
                    (data) in
                    if let downloadedData = data {
                        self.process(data: downloadedData)
                    }
                    else {
                        self.showText("problem accessing the data")
                    }
                }
            }
        }
        catch let error {
            showText("\(error)")
        }
    }
    //____________________________________________TABLE FUNCTIONS_____________________
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
