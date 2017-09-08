//
//  EKTableOfContentsViewCell.swift
//  EPUBKit
//
//  Created by Witek on 09/08/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import UIKit

class EKTableOfContentsViewCell: UITableViewCell {
    
    @IBOutlet weak var chapterLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        chapterLabel.text = ""
    }
    
}

extension EKTableOfContentsViewCell {
    
    public func configure(with chapterTitle: String) {
        chapterLabel.text = chapterTitle
    }
}


