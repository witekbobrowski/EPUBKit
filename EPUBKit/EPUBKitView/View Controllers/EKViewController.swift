//
//  EKViewController.swift
//  EPUBKit
//
//  Created by Witek on 06/08/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import UIKit

public class EKViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UINavigationItem!
    
    public var document: EKDocument!
    var dataSource: EKViewDataSource?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    public override func viewDidLayoutSubviews() {
        layoutCollectionView()
    }
}

extension EKViewController {
    
    fileprivate func configure() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backItem?.title = ""
        titleLabel.title = document.title
        dataSource = EKViewDataSource()
        dataSource?.delegate = self
        dataSource?.build(from: document)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "EKViewCell", bundle: Bundle(for: classForCoder)),
                                    forCellWithReuseIdentifier: "EKViewCell")
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

extension EKViewController: UICollectionViewDelegate {
    
}

extension EKViewController: EKViewDataSourceDelegate {
    
    func dataSourceDidFinishBuilding(_ dataSource: EKDataSource) {
        collectionView.reloadData()
    }
}

