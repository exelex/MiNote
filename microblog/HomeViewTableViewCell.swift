//
//  HomeViewTableViewCell.swift
//  microblog
//
//  Created by Alexey Il on 30.10.2021.
//

import UIKit

class HomeViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    
    public func configure (title: String, text: String) {
        self.titleLabel.text = title
        self.noteLabel.text = text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
     }

}
