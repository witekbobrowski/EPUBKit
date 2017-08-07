//
//  EPUBTableOfContentsDataSource.swift
//  EPUBKit
//
//  Created by Witek on 07/08/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

class EPUBTableOfContentsDataSource: NSObject {
    
    public weak var delegate: EPUBViewDataSourceDelegate?
    fileprivate var model: [Chapter] = []
    
    struct Chapter {
        let title: String
    }
    
}

extension EPUBTableOfContentsDataSource: EPUBDataSource {

    func build(from epubDocument: EPUBDocument) {
        var model: [Chapter] = []
        
        func evaluate(tableOfContents: [EPUBTableOfContents]) {
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
        
    }
    
}
