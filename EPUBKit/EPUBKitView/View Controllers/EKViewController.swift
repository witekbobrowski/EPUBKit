//
//  EKViewController.swift
//  EPUBKit
//
//  Created by Witek on 06/08/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import UIKit

public class EKViewController: UIViewController {
    
    @IBOutlet weak var documentView: UIView!
    
    public var document: EPUBDocument!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tableOfContentsVC = segue.destination as? EKTableOfContentsViewController {
            tableOfContentsVC.configure(with: document)
            tableOfContentsVC.delegate = self
        }
    }
    
}

//MARK: - Configuration
extension EKViewController {
    
    fileprivate func configure() {
        let nib = UINib(nibName: "EKPageView" , bundle: Bundle(for: classForCoder))
        let pageView = nib.instantiate(withOwner: self, options: nil).first as! EKPageView
        view.addSubview(pageView)
        documentView = pageView
        pageView.configure(with: document)
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backItem?.title = ""
        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(hideNavigationBar(_:)))
        view.addGestureRecognizer(tapGestureRecogniser)
        pageView.addGestureRecognizer(tapGestureRecogniser)
    }
    
    @objc private func hideNavigationBar(_ sender: UITapGestureRecognizer){
        guard let navBar = navigationController?.navigationBar else {
            return
        }
        if navBar.isHidden {
            navBar.isHidden = false
        } else {
            navBar.isHidden = true
        }
    }
}

extension EKViewController: EKTableOfContentsViewControllerDelegate {
    func tableOfContentsView(_ tableOfContentsView: EKTableOfContentsViewController, didSelectRowAt indexPath: IndexPath) {
        if let pageView = documentView as? EKPageView {
            pageView.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
}


