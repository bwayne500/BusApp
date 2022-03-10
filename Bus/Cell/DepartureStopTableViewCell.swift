//
//  DepartureStopTableViewCell.swift
//  Bus
//
//  Created by bwayne500 on 2022/3/9.
//

import UIKit

class DepartureStopTableViewCell: UITableViewCell {
    @IBOutlet weak var EstimateTime: UILabel!
    @IBOutlet weak var DepartureStopName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
