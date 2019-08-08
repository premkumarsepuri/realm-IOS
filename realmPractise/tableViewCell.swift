//
//  tableViewCell.swift
//  realmPractise
//
//  Created by apple on 8/2/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class tableViewCell: UITableViewCell {

    @IBOutlet weak var titleLableLBL: UILabel!
    
    @IBOutlet weak var ingredientsTextView: UILabel!
    
    @IBOutlet weak var photoImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
