//
//  HomeViewTableViewCell.swift
//  microblog
//
//  Created by Alexey Il on 30.10.2021.
//

import UIKit

class HomeViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }

    public func configure (title: String, text: String) {
        self.textView.text = text
        self.titleLabel.text = title
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textView.textContainer.lineFragmentPadding = 0
     }

}
