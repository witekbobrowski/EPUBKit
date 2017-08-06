//
//  EPUBViewDataSource.swift
//  EPUBKit
//
//  Created by Witek on 06/08/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import UIKit

struct Chapter {
    let url: URL
    let pages: [Page]
}

struct Page {
    let HTMLContent: String
    let baseURL: URL
}

class EPUBViewDataSource: NSObject {
    
    public var epub: EPUBDocument! {
        didSet {
            rebuildModel()
        }
    }
    public weak var delegate: EPUBViewDataSourceDelegate?
    fileprivate var model: [Chapter] = []
    
}

//MARK: - Configuration
extension EPUBViewDataSource {

    fileprivate func rebuildModel() {
        var model: [Chapter] = []
        for item in epub.spine.children {
            if let manifestItem = epub.manifest.children[item.idref] {
                model.append(Chapter(url: epub.contentDirectory.appendingPathComponent(manifestItem.path), pages: []))
            }
        }
        self.model = epub.spine.pageProgressionDirection == .leftToRight ? model : model.reversed()
        delegate?.dataSourceDidFinishRebuildingModel(self)
    }
    
}

//MARK: - UICollectionViewDataSource
extension EPUBViewDataSource: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EPUBViewCell", for: indexPath) as! EPUBViewCell
        cell.configure(with: model[indexPath.row].url, at: epub.directory)
        return cell
    }
    
}

protocol EPUBViewDataSourceDelegate: class {
    func dataSourceDidFinishRebuildingModel(_ dataSource: EPUBViewDataSource)
}
