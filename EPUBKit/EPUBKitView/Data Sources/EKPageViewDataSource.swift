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
        let id: Int
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

//MARK: - EKViewDataSource
extension EKPageViewDataSource: EKViewDataSource {

    func build(from epubDocument: EPUBDocument) {
        var model: [Chapter] = []
        for (index, item) in epubDocument.spine.children.enumerated() {
            if let manifestItem = epubDocument.manifest.children[item.idref] {
                model.append(Chapter(id: index, title: epubDocument.title ?? "" ,path: epubDocument.contentDirectory.appendingPathComponent(manifestItem.path),
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
        let chapter = model[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EKPageViewCell", for: indexPath) as! EKPageViewCell
        cell.configure(with:chapter.title, id: chapter.id, at: chapter.path)
        return cell
    }
    
}
