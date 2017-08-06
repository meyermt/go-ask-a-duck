//
//  MasterViewController.swift
//  Go Ask a Duck
//
//  Created by Michael Meyer on 8/3/17.
//  Copyright © 2017 Michael Meyer. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UISearchBarDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var searchBar: UISearchBar!
    

    var detailViewController: DetailViewController? = nil
    var objects = [[String:String]]()
    let userDefaults = UserDefaults.standard
    
    // MARK: Actions
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if let split = splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        searchBar.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 140
        if let query = userDefaults.value(forKey: "lastQuery") as! String! {
            searchBar.text = query
        } else {
            searchBar.text = "apple"
        }
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchFor(searchText)
        if let lastSearchURL = userDefaults.value(forKey: "lastSearch") as! String! {
            detailViewController?.detailItem = lastSearchURL
        } else {
            detailViewController?.detailItem = "https://duckduckgo.com/Apple"
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] 
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object["FirstURL"]
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "DuckResponseTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DuckResponseTableViewCell else {
            fatalError("The dequeued cell is not an instance of DuckResponseTableViewCell.")
        }
        
        let result = objects[indexPath.row]
        
        cell.firstURL.text = result["FirstURL"]
        cell.textResp.text = result["Text"]
        
        return cell
    }
    
    // MARK: Search Bar Delegate Methods
    
    // - Attributions: https://www.raywenderlich.com/158106/urlsession-tutorial-getting-started
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchFor(searchText)
        userDefaults.set(searchText, forKey: "lastQuery")
    }
    
    
    
    // MARK: Private methods
    
    private func searchFor(_ query: String) {
        func populateSearchResults(_ results: [[String:String]]) {
            //update some view here
            objects = results
            self.tableView.reloadData()
        }
        
        SharedNetworking.sharedInstance.searchDuck(query: query, completion: populateSearchResults(_:))
    }

    func dismissKeyboard() {
        self.searchBar.resignFirstResponder()
    }
}

