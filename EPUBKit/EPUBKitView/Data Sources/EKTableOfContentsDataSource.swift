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
    public var epubDocument: EPUBDocument? {
        didSet {
            if epubDocument != nil {
                build(from: epubDocument!)
            }
        }
    }
    fileprivate var model: [[Item]] = []
    
    struct Item {
        let item: String
        let title: String
    }
    
}

//MARK: - EKViewDataSource
extension EKTableOfContentsDataSource: EKViewDataSource {

    func build(from epubDocument: EPUBDocument) {
        var section: [Item] = []
        
        func evaluate(tableOfContents: [EPUBTableOfContents], space: String) {
            for item in tableOfContents {
                section.append(Item(item: item.item ?? "" , title: space + item.label))
                if let children = item.subTable {
                    evaluate(tableOfContents: children, space: space + "    ")
                }
            }
        }
        
        if let children = epubDocument.tableOfContents.subTable {
            evaluate(tableOfContents: children, space: "")
        }
        
        self.model = [section]
    }
    
    public func item(at indexPath: IndexPath) -> Any {
        return model[indexPath.section][indexPath.row]
    }
    
}

//MARK: - UICollectionViewDataSource
extension EKTableOfContentsDataSource: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chapter = item(at: indexPath) as! Item
        let cell = tableView.dequeueReusableCell(withIdentifier: "EKTableOfContentsViewCellTableViewCell" ,
                                                 for: indexPath) as! EKTableOfContentsViewCellTableViewCell
        cell.configure(with: chapter.title)
        return cell
    }
    
}
