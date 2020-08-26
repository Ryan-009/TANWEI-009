//
//  HomeViewControllerExtension.swift
//  salestar
//
//  Created by li zhou on 2019/12/21.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation
import UIKit
extension HomeViewController {

    func showSearchBarAnimating() {
        CATransaction.begin()
        addChild(self.searchVC)
        self.view.addSubview(self.searchVC.view)
        self.searchVC.view.alpha = 0
        CATransaction.disableActions()
        CATransaction.commit()
        UIView.animate(withDuration: 0.2, animations: {
         [weak self] in
            guard let strong = self else {
                return
            }
            strong.searchVC.searchBar.setShowsCancelButton(true, animated: true)
            strong.searchBar.setShowsCancelButton(true, animated: true)
        }) { [weak self](_) in
            guard let strong = self else {
                return
            }
            strong.searchVC.view.alpha = 1
//            self?.customNavigationBar.backgroundColor = UIColor.black
            strong.searchBar.showsCancelButton = false
        }
    }
}


extension HomeViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        showSearchBarAnimating()
        return false
    }
}

extension HomeViewController: WeiChatSerachViewControllerDelegate {

    func willPresentSearchController(_ searchController: WeiChatSearchViewController) {
        searchVC.addChild(searchVC.searchResultViewController)
        searchVC.view.addSubview(searchVC.searchResultViewController.view)
    }

    func willDismissSearchController(_ searchController: WeiChatSearchViewController) {
        searchVC.searchResultViewController.view.removeFromSuperview()
        searchVC.searchResultViewController.removeFromParent()
    }

    func updateSearchResults(for searchController: WeiChatSearchViewController) {

        let searchContent = self.searchVC.searchBar.text ?? ""
        let predicate = NSPredicate.init(format: "(SELF CONTAINS %@)", searchContent)
        let filterArray = (dataArray as NSArray).filtered(using: predicate) as! [String]
        self.filterResult = searchContent.count > 0 ? filterArray : dataArray
        let searchResult = self.searchVC.searchResultViewController!
        searchResult.sourceArray = self.filterResult
    }
}


extension HomeViewController:PhotoBrowserDelegate{
   
    @objc func showImage(index:Int,total:Int) {
        let photoBrowser = PhotoBrowser(showByViewController: self, delegate: self)
        photoBrowser.resId = self.adList[selectedADRowWhenShowImage].imgResIds
        // 装配PageControl，提供了两种PageControl实现，若需要其它样式，可参照着自由定制
        photoBrowser.pageControlDelegate = PhotoBrowserDefaultPageControlDelegate(numberOfPages:total)
        photoBrowser.show(index: index)
    }
    
    func numberOfPhotos(in photoBrowser: PhotoBrowser) -> Int {
        return self.selTatalPages
    }
    
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailViewForIndex index: Int) -> UIView? {
        return self.selectedImageView
    }
    
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailImageForIndex index: Int) -> UIImage? {
        // 取thumbnailImage
        return self.selectedImageView.image
    }
    
    func photoBrowser(_ photoBrowser: PhotoBrowser, highQualityUrlStringForIndex index: Int) -> URL? {
        
        let imgResIds = self.adList[selectedADRowWhenShowImage].imgResIds.components(separatedBy: ";")
        if imgResIds.count > index {
            return URL(string: ImageBaseURL + imgResIds[index])
        }
        return nil
    }
    
}
