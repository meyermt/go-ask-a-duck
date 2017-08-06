//
//  DetailViewController.swift
//  Go Ask a Duck
//
//  Created by Michael Meyer on 8/3/17.
//  Copyright © 2017 Michael Meyer. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, DetailBookmarkDelegate, UIWebViewDelegate {
    
    // MARK: Properties

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var webPage: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var favStar: UIImageView!
    
    let userDefaults = UserDefaults.standard
    var isFav = false
    var bookCall = false
    
    
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
        if let favStar = favStar {
            if isFav {
                favStar.isHidden = false
            } else {
                favStar.isHidden = true
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Master", style: .plain, target: nil, action: nil)
        webPage.delegate = self
        activityView.isHidden = true
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: String? {
        didSet {
            // Update the view.
            if bookCall {
                isFav = true
                bookCall = false
            } else {
                isFav = false
            }
            configureView()
        }
    }

    func bookmarkPassedURL(url: String) {
        // add code for loading
        bookCall = true
        detailItem = url
        configureView()
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToBookmarks" {
            let bvc = segue.destination as! BookMarkViewController
            bvc.view.sizeToFit()
            bvc.updateViewConstraints()
            if let favs = userDefaults.value(forKey: "favs") as! [String]! {
                bvc.favs = favs
            }
            bvc.delegate = self
        }
    }
    
    // MARK: UIWebView Delegate methods
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        activityView.isHidden = false
        //activityIndicator.isAnimating = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityView.isHidden = true
        //activityIndicator.isAnimating = false
    }

}

