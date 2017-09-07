//
//  InfiniteScrollView.swift
//  EPUBKit
//
//  Created by Witek on 07/09/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import UIKit
import WebKit

class EKInfiniteScrollView: UIView {

    @IBOutlet fileprivate weak var contentView: UIView!
    fileprivate var webView: WKWebView!
    public var epubDocument: EPUBDocument? {
        didSet {
            if let epubDocument = epubDocument {
                configure(with: epubDocument)
            }
        }
    }
    public var idOfElementToDisplay: String? {
        didSet {
            guard let id = idOfElementToDisplay else { return }
            if id.contains("#") {
                let idSubstring = id.substring(from: id.characters.index(of: "#")!)
                webView.evaluateJavaScript("location.href = \"\(idSubstring)\";")
            } else {
                webView.evaluateJavaScript("location.href = \"#\(id)\";")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
}

//MARK: - Configuration
extension EKInfiniteScrollView {

    fileprivate func configure() {
        webView = WKWebView(frame: contentView.frame)
        contentView.addSubview(webView)
        constrainView(view: webView, toView: contentView)
        webView.allowsBackForwardNavigationGestures = false
        webView.scrollView.showsVerticalScrollIndicator = true
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.pinchGestureRecognizer?.isEnabled = false
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
    }
    
    public func configure(with epubDocument: EPUBDocument){
        var htmlString = "<html><body>"
        for spineItem in epubDocument.spine.items {
            if let manifestItem = epubDocument.manifest.items[spineItem.idref] {
                htmlString.append("<div id=\"\(manifestItem.path)\"></div>")
                let itemURL = epubDocument.contentDirectory.appendingPathComponent(manifestItem.path)
                let spineHtmlString = (try? String(contentsOf: itemURL)) ?? ""
                htmlString.append(spineHtmlString)
            }
        }
        htmlString += "</html></body>"
        webView.loadHTMLString(htmlString, baseURL: epubDocument.contentDirectory)
    }
    
    fileprivate func constrainView(view:UIView, toView contentView:UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
}

//MARK: - WKNavigationDelegate
extension EKInfiniteScrollView: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        webView.evaluateJavaScript("var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no');document.getElementsByTagName('head')[0].appendChild(meta);")
    }
    
}

//MARK: - UIScrollViewDelegate
extension EKInfiniteScrollView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
}

