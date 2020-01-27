//
//  TutorialVC.swift
//  AutoX Tracker
//
//  Created by Samuel Armstrong on 1/11/20.
//  Copyright © 2020 Samuel Armstrong. All rights reserved.
//

import UIKit

// MARK: TutorialVC (Page View) Class
class TutorialVC: UIPageViewController, UIPageViewControllerDelegate {
    // Getting tutorial VCs
    fileprivate lazy var pages: [UIViewController] = {
            return [
                self.getViewController(withIdentifier: "VC1"),
                self.getViewController(withIdentifier: "VC2"),
                self.getViewController(withIdentifier: "VC3"),
                self.getViewController(withIdentifier: "VC4"),
                self.getViewController(withIdentifier: "VC5")
            ]
        }()
        
    // returning the view controller for a given string
    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    // MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        // page setup
        self.dataSource = self
        self.delegate = self
        let appear = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
        appear.pageIndicatorTintColor = UIColor.darkGray
        appear.currentPageIndicatorTintColor = UIColor.red
        self.view.backgroundColor = UIColor.white
        
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
} //End of Tutorial VC Class

// MARK: -TutorialVC Datasource
extension TutorialVC: UIPageViewControllerDataSource {
    // MARK: Loading the previous VC
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else { return nil } // prevents looping
        
        guard pages.count > previousIndex else { return nil }
        
        return pages[previousIndex]
    }
    
    
    // MARK: Loading the next VC
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return nil } //prevents looping
        
        guard pages.count > nextIndex else { return nil }
        
        return pages[nextIndex]
    }
    
    
    // Returns the number of pages to display
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        setupPageControl()
        return pages.count
    }
    

    // Returns 0 always
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    
    // Adding page dots to page controller
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.darkGray
        appearance.currentPageIndicatorTintColor = UIColor.red
        appearance.backgroundColor = UIColor.white
    }
} //End Tutorial VC DATASOURCE

// MARK: -View Controller for TutVC5
class LastTutVC: UIViewController {
    //Declaring the dismissal button
    @IBOutlet weak var dismiss: UIButton!
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        dismiss.layer.borderWidth = 2
        dismiss.layer.borderColor = UIColor.darkGray.cgColor
    }
}
