//
//  MainTableViewCell.swift
//  Bus
//
//  Created by bwayne500 on 2022/3/3.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var MenuName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
