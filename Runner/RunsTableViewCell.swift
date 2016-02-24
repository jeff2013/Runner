//
//  RunsTableViewCell.swift
//  Runner
//
//  Created by Jeff Chang on 2016-02-20.
//  Copyright © 2016 Jeff Chang. All rights reserved.
//

import UIKit

class RunsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var runTitle: UILabel!
    @IBOutlet weak var runSatisfaction: UIImageView!
    @IBOutlet weak var runTime: UILabel!
    @IBOutlet weak var runDistance: UILabel!
    @IBOutlet weak var rightimage: UIImageView!
    @IBOutlet weak var satisfactionImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
