//
//  YFloopView.swift
//  YFloopView
//
//  Created by iCanong on 16/1/25.
//  Copyright © 2016年 yufan. All rights reserved.
//

import UIKit

@objc protocol YFloopViewDelegate: NSObjectProtocol {
    
    optional func viewDidScrollToIndex (index: NSInteger)
    
    optional func viewDidClickAtIndex (index: NSInteger)
    
}


class YFloopView: UIView, UIScrollViewDelegate {

    
    weak var delegate : YFloopViewDelegate?
    
    private let scrollView = UIScrollView()
    
    private var index : NSInteger = 0
    
    private var imageViews = [UIImageView]()
    
    private var timer: NSTimer?
    
    private var pageControl = UIPageControl()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        visualEffectView.frame = UIScreen.mainScreen().bounds
        visualEffectView.alpha = 0.8
        addSubview(visualEffectView)
        
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.bounces = false
        addSubview(scrollView)
    }
    
    override func layoutSubviews() {
        scrollView.frame = bounds
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(imageViews.count), height: scrollView.frame.size.height)
        scrollView.contentOffset = CGPoint(x: imageViews.count > 1 ? scrollView.frame.size.width : 0, y: 0)
        for (index, imageView) in imageViews.enumerate() {
            imageView.frame = CGRect(x: scrollView.frame.size.width * CGFloat(index) + 30, y: 40, width: scrollView.frame.size.width - 60, height: scrollView.frame.size.height - 70)
            imageView.layer.cornerRadius = 10
            imageView.layer.borderColor = UIColor.purpleColor().CGColor
            imageView.layer.borderWidth = 2
            imageView.layer.masksToBounds = true
        }
    }

    func scrollViewToImages(images: [String]) {
        layoutIfNeeded()
        
        imageViews.removeAll(keepCapacity: true)
        for view in scrollView.subviews {
            view.removeFromSuperview()
        }
        
        var list = images
        if images.count > 1 {
            list.insert(images[images.count - 1], atIndex: 0)
            list.append(images[0])
        }
        
        for image in list {
            let imageView = UIImageView()
            imageView.image = UIImage(named: image)
            scrollView.addSubview(imageView)
            imageViews.append(imageView)
        }

        timer?.invalidate()
        if list.count > 0 {
            timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "handleTimer:", userInfo: nil, repeats: true)
        }
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleTimer(timer: NSTimer) {
        let page = Int(scrollView.contentSize.width / scrollView.frame.size.width)
        let curr = Int(scrollView.contentOffset.x / scrollView.frame.size.width);
        UIView.animateWithDuration(0.7) { () -> Void in
            if curr == page - 1 {
                self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            } else {
                self.scrollView.contentOffset = CGPoint(x: self.scrollView.frame.size.width * CGFloat(curr + 1), y: 0)
            }
        }
        scrollViewDidEndDecelerating(scrollView)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        index = Int(floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width)) + 1
        backgroundColor = UIColor(patternImage: imageViews[index].image!)
    }
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if index == 0 {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width * CGFloat(imageViews.count - 2), y: 0)
        }
        if index == imageViews.count - 1 {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        }
        if let delegate = delegate where delegate.respondsToSelector("viewDidScrollToIndex:") {
            delegate.viewDidScrollToIndex!(index - 1)
        }
        if let delegate = delegate where delegate.respondsToSelector("viewDidClickAtIndex:") {
            delegate.viewDidClickAtIndex!(index - 1)
        }
    }


}
