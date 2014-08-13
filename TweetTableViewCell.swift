//
//  TweetTableViewCell.swift
//  SwiftAndParse
//
//  Created by kiiita on 2014/08/10.
//  Copyright (c) 2014年 Yuto Kitakuni. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet var usernameLabel: UILabel! = UILabel()
    @IBOutlet var timestampLabel: UILabel! = UILabel()
    @IBOutlet var tweetTextView: UITextView! = UITextView()
    required override convenience init(style: UITableViewCellStyle, reuseIdentifier: String) {
        self.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
