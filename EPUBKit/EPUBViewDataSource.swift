//
//  EPUBViewDataSource.swift
//  EPUBKit
//
//  Created by Witek on 06/08/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import UIKit

class EPUBViewDataSource: NSObject {
    
    public weak var delegate: EPUBViewDataSourceDelegate?
    fileprivate var model: [Chapter] = []
    
    struct Chapter {
        let path: URL
        let directory: URL
        let pages: [Page]
    }
    
    struct Page {
        let HTMLContent: String
        let baseURL: URL
    }

}

//MARK: - EPUBDataSource
extension EPUBViewDataSource: EPUBDataSource {

    func build(from epubDocument: EPUBDocument) {
        var model: [Chapter] = []
        for item in epubDocument.spine.children {
            if let manifestItem = epubDocument.manifest.children[item.idref] {
                model.append(Chapter(path: epubDocument.contentDirectory.appendingPathComponent(manifestItem.path),
                                     directory: epubDocument.contentDirectory,
                                     pages: []))
            }
        }
        self.model = epubDocument.spine.pageProgressionDirection == .leftToRight ? model : model.reversed()
        delegate?.dataSourceDidFinishBuilding(self)
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
        cell.configure(with: model[indexPath.row].path, at: model[indexPath.row].directory)
        return cell
    }
    
}
