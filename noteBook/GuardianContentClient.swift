//
//  GuardianContentApi.swift
//  ExampleNoteBook
//
//  Created by Neil Taylor on 22/03/2019.
//  Copyright © 2019 Aberystwyth University. All rights reserved.
//

import Foundation

class GuardianContentClient {
    
    var apiKey: String = "cb9a43af-3974-482a-8399-1ce3b9af475e"
    
    var verbose: Bool
    
    let session = URLSession(configuration: .default)
    
    convenience init() {
        self.init(verbose: false)
    }
    
    init(verbose: Bool) {
        self.verbose = verbose
    }
    
    func searchContent(for query: String,
                       usingFilters filters: GuardianContentFilters?,
                       withCallback callback: @escaping (_ data: GuardianOpenPlatformData?, _ downloadedData: Data) -> Void) throws  {
        
        var parameters = ""
        if let parameterValues = filters?.queryParameters() {
            parameters = "&\(parameterValues)"
        }
        
        let urlString = "https://content.guardianapis.com/search?q=\(query)\(parameters)&api-key=\(apiKey)"
        
        try performDataTask(with: urlString, withCallback: callback)
    }
    
    func searchSections(for query: String,
                        withCallback callback: @escaping (_ data: GuardianOpenPlatformData?,_ downloadedData: Data) -> Void) throws {
        
        let urlString = "https://content.guardianapis.com/sections?q=\(query)&api-key=\(apiKey)"
        try performDataTask(with: urlString, withCallback: callback)
    }
    
    func searchTags(for query: String,
                    usingFilters filters: GuardianContentTagFilters?,
                    withCallback callback: @escaping (_ data: GuardianOpenPlatformData?,_ downloadedData: Data) -> Void) throws {
        
        var parameters = ""
        if let parameterValues = filters?.queryParameters() {
            parameters = "&\(parameterValues)"
        }
        
        let urlString = "https://content.guardianapis.com/tags?q=\(query)\(parameters)&api-key=\(apiKey)"
        
        try performDataTask(with: urlString, withCallback: callback)
    }
    
    func performDataTask(with urlString: String,
                         withCallback callback: @escaping (_ data: GuardianOpenPlatformData?, _ downloadedData: Data) -> Void) throws  {
        
        guard let value = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
            let url = URL(string: value) else {
                
                if verbose {
                    print("Invalid URL has been specified: \(urlString)")
                }
                
                throw GuardianContentClientError.InvalidUrl
        }
        
        let task = session.dataTask(with: url) {
            (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if let downloadedData = data {
                
                if self.verbose {
                    let text = "Completed with response: \(String(describing: response))" +
                        "\ndata length: \(downloadedData.count)" +
                    "\nerror: \(String(describing: error))"
                    print(text)
                    
                    //print(String(describing: data))
                }
                
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(GuardianOpenPlatformData.self, from: downloadedData)
                    
                    if self.verbose {
                        //print(data)
                    }
                    
                    callback(data, downloadedData)
                }
                catch let error as NSError {
                    if self.verbose {
                        print("There was an error: \(error.localizedDescription)")
                    }
                    callback(nil, downloadedData)
                }
            }
            
        }
        
        task.resume()
        
    }
    
    
}
