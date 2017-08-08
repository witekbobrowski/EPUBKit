//
//  EKViewDataSource.swift
//  EPUBKit
//
//  Created by Witek on 06/08/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import UIKit

class EKViewDataSource: NSObject {
    
    public weak var delegate: EKViewDataSourceDelegate?
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

//MARK: - EKDataSource
extension EKViewDataSource: EKDataSource {

    func build(from epubDocument: EKDocument) {
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
extension EKViewDataSource: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EKViewCell", for: indexPath) as! EKViewCell
        cell.configure(with: model[indexPath.row].path, at: model[indexPath.row].directory)
        return cell
    }
    
}
