//
//  BookMarkViewController.swift
//  Go Ask a Duck
//
//  Created by Michael Meyer on 8/5/17.
//  Copyright © 2017 Michael Meyer. All rights reserved.
//

import UIKit

class BookMarkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    
    weak var delegate: DetailBookmarkDelegate?
    
    var favs = [String]()
    var favsTable: UITableView!
    let userDefaults = UserDefaults.standard
    
    // MARK: Actions
    
    @IBAction func closeBookMarks(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editTable(_ sender: UIButton) {
        favsTable.isEditing = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favsTable = UITableView(frame: CGRect(x: 10, y: 50, width: 280, height: 200))
        favsTable.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        favsTable.delegate = self
        favsTable.dataSource = self
        self.view.addSubview(favsTable)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: Table View Stuff
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(favs[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if var favs = userDefaults.value(forKey: "favs") as! [String]! {
                favs.remove(at: indexPath.row)
                userDefaults.set(favs, forKey: "favs")
            }
            favs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
