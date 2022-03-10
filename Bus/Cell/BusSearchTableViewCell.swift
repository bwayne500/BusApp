//
//  BusSearchTableViewCell.swift
//  Bus
//
//  Created by bwayne500 on 2022/3/4.
//

import UIKit

class BusSearchTableViewCell: UITableViewCell {
    @IBOutlet weak var BusName: UILabel!
    @IBOutlet weak var BusImage: UIImageView!
    @IBOutlet weak var BusRoute: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
