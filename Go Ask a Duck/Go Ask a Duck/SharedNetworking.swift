//
//  SharedNetworking.swift
//  Go Ask a Duck
//
//  Created by Michael Meyer on 8/3/17.
//  Copyright © 2017 Michael Meyer. All rights reserved.
//

import Foundation
import UIKit

class SharedNetworking {
    
    static let sharedInstance = SharedNetworking()
    
    fileprivate init() {}
    
    func searchDuck(query: String, completion: @escaping ((_ results: [[String:String]]) -> Void)) {
        
        let duckQueryUrl = self.createDuckURL(query: query)
        
        let session = URLSession.shared
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let task = session.dataTask(with: duckQueryUrl as URL, completionHandler: { (data, response, error) -> Void in
            
            // print("Response: \(String(describing: response))")
            
            guard ((response as! HTTPURLResponse).statusCode == 200) else {
                fatalError("Received bad response from server")
            }
            
            guard error == nil else {
                fatalError("Error: \(error!.localizedDescription)")
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                
                guard let results = json as? [String: AnyObject] else {
                    fatalError("We couldn't cast the JSON to an array of dictionaries")
                }
                
                guard let relatedTopics = results["RelatedTopics"] as? [[String: AnyObject]] else {
                    fatalError("Unable to parse out the related topics in duck search")
                }
                
                DispatchQueue.main.async {
                    
                    let resultArray: [[String:String]] = relatedTopics.map {
                        var dictEntry = [String:String]()
                        dictEntry["FirstURL"] = $0["FirstURL"] as? String
                        dictEntry["Text"] = $0["Text"] as? String
                        return dictEntry
                    }
                    completion(resultArray)
                }
                
            } catch {
                fatalError("error serializing JSON: \(error)")
            }
        })
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        task.resume()
    }
    
    // - Attributions: https://grokswift.com/building-urls/
    private func createDuckURL(query: String) -> NSURL {
        let duckUrlComponents = NSURLComponents()
        
        duckUrlComponents.scheme = "https"
        duckUrlComponents.host = "api.duckduckgo.com"
        
        let queryParam = URLQueryItem(name: "q", value: query)
        let formatParam = URLQueryItem(name: "format", value: "json")
        duckUrlComponents.queryItems = [queryParam, formatParam]
        
        return duckUrlComponents.url! as NSURL
    }
}
