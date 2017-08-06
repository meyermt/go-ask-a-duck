//
//  DetailViewController.swift
//  Go Ask a Duck
//
//  Created by Michael Meyer on 8/3/17.
//  Copyright © 2017 Michael Meyer. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, DetailBookmarkDelegate {
    
    // MARK: Properties

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var webPage: UIWebView!
    
    let userDefaults = UserDefaults.standard
    
    
    // MARK: Actions
    
    @IBAction func favButton(_ sender: UIButton) {
        if var favs = userDefaults.value(forKey: "favs") as! [String]! {
            favs.append(detailItem!)
            userDefaults.set(favs, forKey: "favs")
        } else {
            let favs = [detailItem!]
            userDefaults.set(favs, forKey: "favs")
        }
    }
    
    

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.description
            }
            
            if let webPage = webPage {
                let url = URL(string: detail)!
                webPage.loadRequest(URLRequest(url: url))
                userDefaults.set(detail, forKey: "lastSearch")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: String? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    func bookmarkPassedURL(url: String) {
        // add code for loading
        detailItem = url
        configureView()
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("calling seque prepare and segue name is \(String(describing: segue.identifier))")
        //if segue.identifier == "segueToBookmarks" {
            print("about to segue to bm")
            let bvc = segue.destination as! BookMarkViewController
            if let favs = userDefaults.value(forKey: "favs") as! [String]! {
                print("found favs to set")
                bvc.favs = favs
            }
            bvc.delegate = self
        //}
    }

}

