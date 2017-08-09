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
    
    public var document: EKDocument!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

}

extension EKViewController {
    
    fileprivate func configure() {
        let nib = UINib(nibName: "EKPageView" , bundle: Bundle(for: classForCoder))
        let pageView = nib.instantiate(withOwner: self, options: nil).first as! EKPageView
        view.addSubview(pageView)
        documentView = pageView
        pageView.configure(with: document)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backItem?.title = ""
        navigationController?.hidesBarsOnTap = true
    }
    
}


