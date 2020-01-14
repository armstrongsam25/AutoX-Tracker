//
//  TutorialVC.swift
//  AutoX Tracker
//
//  Created by Sam Armstrong on 1/11/20.
//  Copyright © 2020 Samuel Armstrong. All rights reserved.
//

import UIKit

class TutorialVC: UIPageViewController {
    
    fileprivate lazy var pages: [UIViewController] = {
            return [
                self.getViewController(withIdentifier: "VC1"),
                self.getViewController(withIdentifier: "VC2"),
                self.getViewController(withIdentifier: "VC3")
            ]
        }()
        
        fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController
        {
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
        }
        
        override func viewDidLoad()
        {
            super.viewDidLoad()
            self.dataSource = self
            self.delegate = self
            let appear = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
            appear.pageIndicatorTintColor = UIColor.darkGray
            appear.currentPageIndicatorTintColor = UIColor.red
            
            if let firstVC = pages.first
            {
                setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
            }
        }
    }

    extension TutorialVC: UIPageViewControllerDataSource
    {
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            
            guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
            
            let previousIndex = viewControllerIndex - 1
            
            guard previousIndex >= 0          else { return pages.last }
            
            guard pages.count > previousIndex else { return nil        }
            
            return pages[previousIndex]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
        {
            guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
            
            let nextIndex = viewControllerIndex + 1
            
            guard nextIndex < pages.count else { return pages.first }
            
            guard pages.count > nextIndex else { return nil         }
            
            return pages[nextIndex]
        }
        
        func presentationCount(for pageViewController: UIPageViewController) -> Int {
            setupPageControl()
            return pages.count
        }

        func presentationIndex(for pageViewController: UIPageViewController) -> Int {
            return 0
        }
        
        private func setupPageControl() {
            let appearance = UIPageControl.appearance()
            appearance.pageIndicatorTintColor = UIColor.darkGray
            appearance.currentPageIndicatorTintColor = UIColor.red
            appearance.backgroundColor = UIColor.white //UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        }
    }

extension TutorialVC: UIPageViewControllerDelegate { }
