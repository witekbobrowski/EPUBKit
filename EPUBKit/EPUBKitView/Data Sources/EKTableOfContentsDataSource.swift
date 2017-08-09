//
//  EPUBTableOfContentsDataSource.swift
//  EPUBKit
//
//  Created by Witek on 07/08/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

class EPUBTableOfContentsDataSource: NSObject {
    
    public weak var delegate: EKViewDataSourceDelegate?
    fileprivate var model: [Chapter] = []
    
    struct Chapter {
        let title: String
    }
    
}

extension EPUBTableOfContentsDataSource: EKViewDataSource {

    func build(from epubDocument: EKDocument) {
        var model: [Chapter] = []
        
        func evaluate(tableOfContents: [EKTableOfContents]) {
            for content in tableOfContents {
                model.append(Chapter(title: content.label))
                if let children = content.subTable {
                    evaluate(tableOfContents: children)
                }
            }
        }
        
        if let children = epubDocument.tableOfContents.subTable {
            evaluate(tableOfContents: children)
        }
        
        self.model = model
    }
    
}

extension EPUBTableOfContentsDataSource: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return model.isEmpty ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
