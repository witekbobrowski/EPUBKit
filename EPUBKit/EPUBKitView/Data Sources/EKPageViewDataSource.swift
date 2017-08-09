//
//  EKViewDataSource.swift
//  EPUBKit
//
//  Created by Witek on 06/08/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import UIKit

class EKPageViewDataSource: NSObject {
    
    public weak var delegate: EKViewDataSourceDelegate?
    fileprivate var model: [Chapter] = []
    
    struct Chapter {
        let title: String
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
extension EKPageViewDataSource: EKViewDataSource {

    func build(from epubDocument: EKDocument) {
        var model: [Chapter] = []
        for item in epubDocument.spine.children {
            if let manifestItem = epubDocument.manifest.children[item.idref] {
                model.append(Chapter(title: epubDocument.title,path: epubDocument.contentDirectory.appendingPathComponent(manifestItem.path),
                                     directory: epubDocument.contentDirectory,
                                     pages: []))
            }
        }
        self.model = epubDocument.spine.pageProgressionDirection == .leftToRight ? model : model.reversed()
        delegate?.dataSourceDidFinishBuilding(self)
    }
    
}

//MARK: - UICollectionViewDataSource
extension EKPageViewDataSource: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EKViewCell", for: indexPath) as! EKViewCell
        cell.configure(with:model[indexPath.row].title, at: model[indexPath.row].path)
        return cell
    }
    
}
