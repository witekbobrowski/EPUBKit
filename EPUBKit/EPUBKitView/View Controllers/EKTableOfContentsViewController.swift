//
//  EKTableOfContentsViewController.swift
//  EPUBKit
//
//  Created by Witek on 06/08/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import UIKit

class EKTableOfContentsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    public weak var delegate: EKTableOfContentsViewControllerDelegate?
    fileprivate var dataSource = EKTableOfContentsDataSource()
    
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
        tableView.register(UINib(nibName: "EKTableOfContentsViewCellTableViewCell", bundle: Bundle(for: classForCoder)),
                                 forCellReuseIdentifier: "EKTableOfContentsViewCellTableViewCell")
    }
    
    public func configure(with document: EPUBDocument) {
        dataSource.build(from: document)
    }
}

//MARK: - EKViewDataSourceDelegate
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
