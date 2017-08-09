//
//  EKPageView.swift
//  EPUBKit
//
//  Created by Witek on 08/08/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import UIKit

class EKPageView: UIView {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            configure()
        }
    }
    fileprivate var dataSource = EKPageViewDataSource()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutCollectionView()
    }
}

extension EKPageView {
    
    public func configure(with document: EKDocument) {
        dataSource.build(from: document)
    }
    
    fileprivate func configure() {
        dataSource.delegate = self
        collectionView.dataSource = dataSource
        collectionView.register(UINib(nibName: "EKViewCell", bundle: Bundle(for: classForCoder)),
                                forCellWithReuseIdentifier: "EKViewCell")
    }
    
    fileprivate func layoutCollectionView() {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.frame.size
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.invalidateLayout()
    }
}

extension EKPageView: EKViewDataSourceDelegate {
    
    func dataSourceDidFinishBuilding(_ dataSource: EKViewDataSource) {
        collectionView.reloadData()
    }
}
