//
//  DuckResponseTableViewCell.swift
//  Go Ask a Duck
//
//  Created by Michael Meyer on 8/3/17.
//  Copyright © 2017 Michael Meyer. All rights reserved.
//

import UIKit

class DuckResponseTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var firstURL: UILabel!
    @IBOutlet weak var textResp: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
