//
//  ResultsCellTableViewCell.swift
//  noteBook
//
//  Created by rdm10 on 09/04/2019.
//  Copyright © 2019 rdm10. All rights reserved.
//

import UIKit

class ResultsCellTableViewCell: UITableViewCell {
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var cached: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
