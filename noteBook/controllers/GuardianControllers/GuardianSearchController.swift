//
//  GuardianSearch.swift
//  noteBook
//
//  Created by rdm10 on 08/04/2019.
//  Copyright © 2019 rdm10. All rights reserved.
//

import UIKit
import CoreData
class GuardianSearchController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    var managedContext: NSManagedObjectContext?
    
    @IBOutlet weak var applyFiltersBtn: UIButton!
    @IBOutlet weak var searchTerm: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var filterView: UIScrollView!
    
    @IBOutlet weak var fromDate: UIDatePicker!
    
    @IBOutlet weak var toDate: UIDatePicker!
    
    @IBOutlet weak var orderBy: UIPickerView!
    
    var orderByData: [String] = [String]()

    var client: GuardianContentClient!
    
    var data: GuardianOpenPlatformData!
    
    var pickerSelected = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        client = GuardianContentClient(verbose: true)
        self.orderBy.delegate = self
        self.orderBy.dataSource = self
        
        orderByData = ["newest","oldest","relevance"]
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            print("error - unable to access failure")
            exit(EXIT_FAILURE)
        }
        managedContext = delegate.persistentContainer.viewContext
        

        
    }
    

    @IBAction func ShowFilters(_ sender: Any) {
        if filterView.isHidden {
            
            filterView.isHidden = false
            applyFiltersBtn.setTitle("Remove Filters", for: .normal)
            
        } else {
            
            filterView.isHidden = true
            applyFiltersBtn.setTitle("Apply Filters", for: .normal)
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerSelected = row
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return orderByData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return orderByData[row]
    }

  
    @IBOutlet weak var recentHistory: UIButton!
    @IBOutlet weak var shortUrl: UISwitch!
    @IBOutlet weak var bodyText: UISwitch!

    @IBOutlet weak var trailText: UISwitch!
    @IBOutlet weak var wordCount: UISwitch!
    @IBOutlet weak var lastModified: UISwitch!

    @IBAction func searchPresssed(_ sender: Any) {
        let filters = GuardianContentFilters()
        
        filters.showElements = .all
        filters.pageSize = 50
        
        if !filterView.isHidden {
            filters.toDate = toDate.date
            filters.fromDate = fromDate.date
            
            if let order = GuardianContentOrderFilter(rawValue: orderByData[pickerSelected]){
                filters.orderBy = order
            }
            
            var showFields:[String] = [String]()
            
            if shortUrl.isOn {
                showFields.append("shortUrl")
            }
            if bodyText.isOn {
                showFields.append("bodyText")
            }
            if trailText.isOn {
                showFields.append("trailText")
            }
            if wordCount.isOn {
                showFields.append("wordcount")
            }
            if lastModified.isOn {
                showFields.append("lastModified")
            }

            filters.showFields = showFields.joined(separator: ",")
            
        }
        
        let searchTermValue = searchTerm.text!
        
        var ping: Pinger!
        ping = Pinger()
        
        ping.pingHost(){
            (pinged) in
            if pinged ?? false {
                self.loadContent(filters: filters, searchTerm: searchTermValue){
                    success,rawData  in
                    if self.data.response.status == "ok" && self.data != nil {
                        DispatchQueue.main.async {
                            self.saveToRecentSearches(filter: filters, searchTerm: searchTermValue, rawData: rawData)
                            
                            self.performSegue(withIdentifier: "showResults", sender: sender)
                        }
                    }
                }
            } else {
                print ("internet down - use cached content")
                DispatchQueue.main.async {
                    self.recentHistory.titleLabel?.text = "Cache content"
                }
            }

        }


    }
    
    
    func loadContent(filters: GuardianContentFilters, searchTerm: String?,completionHandler: @escaping (Error?, _ rawData: Data)->())  {
        do {
            if let term = searchTerm {
                try client.searchContent(for: term, usingFilters: filters) {
                    (data,rawdata) in
                    
                    if let downloadedData = data {
                        self.data = downloadedData
 
                        completionHandler(nil,rawdata)
                    }
                    else {
                        print("problem accessing the data")
                        DispatchQueue.main.async {
                            self.recentHistory.titleLabel?.text = "Use Cached responses"
                        }
                        completionHandler(nil,rawdata)
                    }
                }
            }
        }
        catch let error {
            print("Error in load content: \(error)")
            DispatchQueue.main.async {
                self.recentHistory.titleLabel?.text = "Use Cached responses"
            }
            let d: Data? = "".data(using: .utf8)
            completionHandler(error,d!)
        }
        
    }
    
    func saveToRecentSearches(filter: GuardianContentFilters, searchTerm: String, rawData: Data){
        let search = RecentSearch(entity:RecentSearch.entity(), insertInto: managedContext)
        
        search.searchTerm = searchTerm
        search.dateOfSearch = Date()
        search.orderBy = filter.orderBy?.rawValue
        search.fromDate = filter.fromDate
        search.toDate = filter.toDate
        search.fields = filter.showFields
        search.filterUsed = !filterView.isHidden
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyHHmmss"
        
        let cacheKey = dateFormatter.string(from: Date())
            
        search.cacheKey = cacheKey
        
        let defaults = UserDefaults.standard
        defaults.set(rawData, forKey: cacheKey)
        
        do {
            try managedContext?.save()
            print("added cache")
        }
        catch let error as NSError {
            print("error with \(error)")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let view = segue.destination as? ReturnedArticlesTableViewController {
            view.data = self.data
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewDidLoad()
    }
    
}
