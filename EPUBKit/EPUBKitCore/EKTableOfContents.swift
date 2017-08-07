//
//  EKTableOfContents.swift
//  EPUBKit
//
//  Created by Witek on 09/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

public class EKTableOfContents {

    var label: String
    var id: String
    var item: String?
    var page: Int?
    var subTable: [EKTableOfContents]?
    
    init(label: String, id: String, item: String?, subTable: [EKTableOfContents]?) {
        self.label = label
        self.id = id
        self.item = item
        self.subTable = subTable
        self.page = nil
    }
    
    convenience init(label: String, id: String, item: String?) {
        self.init(label: label, id: id, item: item, subTable: nil)
    }
    
}
