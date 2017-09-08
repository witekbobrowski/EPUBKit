//
//  EKViewController.swift
//  EPUBKit
//
//  Created by Witek on 06/08/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import UIKit

public class EKViewController: UIViewController {
    
    @IBOutlet fileprivate weak var documentView: UIView!
    
    public var epubDocument: EPUBDocument?
    
    
    public override var prefersStatusBarHidden: Bool {
        return navigationController?.isNavigationBarHidden == true
    }
    public override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tableOfContentsVC = segue.destination as? EKTableOfContentsViewController {
            tableOfContentsVC.delegate = self
            tableOfContentsVC.epubDocument = epubDocument
        }
    }
    
}

//MARK: - Configuration
extension EKViewController {
    
    fileprivate func configure() {
        let nibName = String(describing: EKInfiniteScrollView.self)
        let nib = UINib(nibName: nibName, bundle: Bundle(for: EKInfiniteScrollView.classForCoder()))
        let infiniteScrollView = nib.instantiate(withOwner: EKInfiniteScrollView.self, options: nil).first as! EKInfiniteScrollView
        view.addSubview(infiniteScrollView)
        documentView = infiniteScrollView
        infiniteScrollView.epubDocument = epubDocument
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(hideNavigationBar(_:)))
        view.addGestureRecognizer(tapGestureRecogniser)
    }
    
    @objc private func hideNavigationBar(_ sender: UITapGestureRecognizer){
         navigationController?.setNavigationBarHidden(navigationController?.isNavigationBarHidden == false, animated: true)
    }
    
}

//MARK: - EKTableOfContentsViewControllerDelegate
extension EKViewController: EKTableOfContentsViewControllerDelegate {
    
    func tableOfContentsView(_ tableOfContentsView: EKTableOfContentsViewController, didSelectRowAt indexPath: IndexPath) {
        if let infiniteScrollView = documentView as? EKInfiniteScrollView {
            infiniteScrollView.idOfElementToDisplay = (tableOfContentsView.dataSource.item(at: indexPath) as? EKTableOfContentsDataSource.Item)?.item
        }
    }
    
}
