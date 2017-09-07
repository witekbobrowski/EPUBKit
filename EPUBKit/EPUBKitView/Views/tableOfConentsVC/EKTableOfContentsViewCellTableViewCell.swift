//
//  EKTableOfContentsViewCellTableViewCell.swift
//  EPUBKit
//
//  Created by Witek on 09/08/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import UIKit

class EKTableOfContentsViewCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var chapterLabel: UILabel!
    
}

extension EKTableOfContentsViewCellTableViewCell {
    
    public func configure(with chapterTitle: String) {
        chapterLabel.text = chapterTitle
    }
}


