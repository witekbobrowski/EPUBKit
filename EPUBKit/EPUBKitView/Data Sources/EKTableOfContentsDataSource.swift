//
//  EKTableOfContentsDataSource.swift
//  EPUBKit
//
//  Created by Witek on 07/08/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

class EKTableOfContentsDataSource: NSObject {
    
    public weak var delegate: EKViewDataSourceDelegate?
    fileprivate var model: [Chapter] = []
    
    struct Chapter {
        let title: String
    }
    
}

//MARK: - EKViewDataSource
extension EKTableOfContentsDataSource: EKViewDataSource {

    func build(from epubDocument: EKDocument) {
        var model: [Chapter] = []
        
        func evaluate(tableOfContents: [EKTableOfContents], space: String) {
            for content in tableOfContents {
                model.append(Chapter(title: space + content.label))
                print( "  " + content.label)
                if let children = content.subTable {
                    evaluate(tableOfContents: children, space: space + "    ")
                }
            }
        }
        
        if let children = epubDocument.tableOfContents.subTable {
            evaluate(tableOfContents: children, space: "")
        }
        
        self.model = model
    }
    
}

//MARK: - UICollectionViewDataSource
extension EKTableOfContentsDataSource: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return model.isEmpty ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EKTableOfContentsViewCellTableViewCell" ,
                                                 for: indexPath) as! EKTableOfContentsViewCellTableViewCell
        cell.configure(with: model[indexPath.row].title)
        return cell
    }
    
}
