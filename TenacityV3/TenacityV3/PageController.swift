//
//  PageController.swift
//  TenacityV3
//
//  Created by PLL on 7/25/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import Foundation
import UIKit


// for the "carousel style page"
class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var pageControl = UIPageControl()//dots
    
    lazy var orderedViewControllers: [UIViewController] = {
        
        return [self.newVc(viewController: "BreatheFocus"),
                self.newVc(viewController: "BreatheInfinite"),
                self.newVc(viewController: "Lotus")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self //dots
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        configurePageControl()//dots
    }
    
    func newVc(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else{
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else{
            return orderedViewControllers.last
        }
        
        guard orderedViewControllers.count > previousIndex else{
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else{
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        
        guard orderedViewControllers.count != nextIndex else{
            return orderedViewControllers.first
        }
        
        guard orderedViewControllers.count > nextIndex else{
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    // puts page controller dots on bottom
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 75,width: UIScreen.main.bounds.width,height: 0))
        self.pageControl.numberOfPages = orderedViewControllers.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.white
        self.pageControl.pageIndicatorTintColor = UIColor.gray //color of noncurrent dots
        self.pageControl.currentPageIndicatorTintColor = UIColor.white //color of current dot
        self.view.addSubview(pageControl)
    }

    // dots change as scroll to diff pages
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.firstIndex(of: pageContentViewController)!
    }
}
