//
//  ViewController.swift
//  YFloopView
//
//  Created by iCanong on 16/1/25.
//  Copyright © 2016年 yufan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, YFloopViewDelegate {

    var pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let images = ["66.jpg","61.jpg","155.jpg","34.jpg","71.jpg"]
        
        pageControl.frame = CGRect(x: 0, y: view.frame.size.height - 70, width: view.frame.size.width, height: 30)
        pageControl.numberOfPages = images.count
        pageControl.pageIndicatorTintColor = UIColor.orangeColor()
        pageControl.currentPageIndicatorTintColor = UIColor.whiteColor()
        pageControl.userInteractionEnabled = false
        
        let yfloop = YFloopView(frame: UIScreen.mainScreen().bounds)
        yfloop.scrollViewToImages(images)
        yfloop.delegate = self
        view.addSubview(yfloop)
        view.addSubview(pageControl)
    }
    
    func viewDidScrollToIndex (index: NSInteger) {
        pageControl.currentPage = index
    }

    func viewDidClickAtIndex(index: NSInteger) {
        print("\(index)")
    }

}

