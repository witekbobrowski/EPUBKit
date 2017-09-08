//
//  EKTableOfContentsViewController.swift
//  EPUBKit
//
//  Created by Witek on 06/08/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import UIKit

class EKTableOfContentsViewController: UIViewController {
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    public weak var delegate: EKTableOfContentsViewControllerDelegate?
    public var dataSource = EKTableOfContentsDataSource()
    public var epubDocument: EPUBDocument? {
        didSet {
            dataSource.epubDocument = epubDocument
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
}

//MARK: - Configuration
extension EKTableOfContentsViewController {
    
    fileprivate func configure() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backItem?.title = ""
        dataSource.delegate = self
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.register(UINib(nibName: "EKTableOfContentsViewCell", bundle: Bundle(for: classForCoder)), forCellReuseIdentifier: "EKTableOfContentsViewCell")
    }
    
}

//MARK: - UITableViewDelegate
extension EKTableOfContentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tableOfContentsView(self, didSelectRowAt: indexPath)
        navigationController?.popViewController(animated: true)
    }
}


//MARK: - EKViewDataSourceDelegate
extension EKTableOfContentsViewController: EKViewDataSourceDelegate {
    
    func dataSourceDidFinishBuilding(_ dataSource: EKViewDataSource) {
        tableView.reloadData()
    }
    
}

protocol EKTableOfContentsViewControllerDelegate: class {
    func tableOfContentsView(_ tableOfContentsView: EKTableOfContentsViewController, didSelectRowAt indexPath: IndexPath)
}
