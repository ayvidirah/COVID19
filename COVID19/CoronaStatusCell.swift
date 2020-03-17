//
//  CoronaStatusCell.swift
//  AQI
//
//  Created by Hariharan Murugesan on 17/03/20.
//  Copyright © 2020 Hariharan Murugesan. All rights reserved.
//

import UIKit

class CoronaStatusCell: UITableViewCell {
    @IBOutlet weak var cases: UILabel!
    @IBOutlet weak var deaths: UILabel!
    @IBOutlet weak var recoveries: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
