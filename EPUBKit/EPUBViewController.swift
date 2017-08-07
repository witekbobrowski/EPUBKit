//
//  EPUBViewController.swift
//  EPUBKit
//
//  Created by Witek on 06/08/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import UIKit

public class EPUBViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UINavigationItem!
    
    public var epubDocument: EPUBDocument!
    var dataSource: EPUBViewDataSource?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    public override func viewDidLayoutSubviews() {
        layoutCollectionView()
    }
}

extension EPUBViewController {
    
    fileprivate func configure() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backItem?.title = ""
        titleLabel.title = epubDocument.title
        dataSource = EPUBViewDataSource()
        dataSource?.delegate = self
        dataSource?.build(from: epubDocument)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "EPUBViewCell", bundle: Bundle(for: classForCoder)),
                                    forCellWithReuseIdentifier: "EPUBViewCell")
    }
    
    fileprivate func layoutCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = collectionView.frame.size
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
}

extension EPUBViewController: UICollectionViewDelegate {
    
}

extension EPUBViewController: EPUBViewDataSourceDelegate {
    
    func dataSourceDidFinishBuilding(_ dataSource: EPUBDataSource) {
        collectionView.reloadData()
    }
}

