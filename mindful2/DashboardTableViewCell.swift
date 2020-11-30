//
//  DashboardTableViewCell.swift
//  mindful2
//
//  Created by Carmen Khuu on 2020-11-29.
//

import UIKit

class DashboardTableViewCell: UITableViewCell {

    @IBOutlet weak var moodImageView: UIImageView!
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var dateActivityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
