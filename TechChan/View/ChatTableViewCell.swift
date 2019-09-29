//
//  ChatTableViewCell.swift
//  TechChan
//
//  Created by 大林拓実 on 2019/09/25.
//  Copyright © 2019 大林拓実. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    public var postNumber: Int?
    
    @IBOutlet public var postNumberLabel: UILabel!
    @IBOutlet public var userNameLabel: UILabel!
    @IBOutlet public var messageLabel: UILabel!
    @IBOutlet public var postTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
