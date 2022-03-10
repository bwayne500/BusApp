//
//  DestinationStopTableViewCell.swift
//  Bus
//
//  Created by bwayne500 on 2022/3/9.
//

import UIKit

class DestinationStopTableViewCell: UITableViewCell {
    @IBOutlet weak var DestinationStopName: UILabel!
    @IBOutlet weak var EstimateTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
