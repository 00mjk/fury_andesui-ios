//
//  AndesBadgeShowcaseViewController.swift
//  AndesUI-demoapp
//

import UIKit
import AndesUI

class AndesBadgeShowcaseViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!

    let controllers = [BadgeViewController(), BadgeObjCViewController()]
    var pageController: UIPageViewController!

    fileprivate func setupPageControl() {
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = AndesStyleSheetManager.styleSheet.brandColor500
        pageControl.numberOfPages = controllers.count
    }

    fileprivate func setupPageController() {
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.dataSource = self
        pageController.delegate = self
        pageController.setViewControllers([controllers.first!], direction: .forward, animated: true, completion: nil)
        containerView.addSubview(pageController.view)
        pageController.view.pinTo(view: self.containerView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "AndesBadge"
        setupPageController()
        containerView.bringSubview(toFront: pageControl)
        setupPageControl()
    }
}

extension AndesBadgeShowcaseViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let current = controllers.index(of: viewController)!
        return current == 0 ? nil : controllers[current - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let current = controllers.index(of: viewController)!
        return current + 1 == controllers.count ? nil : controllers[current + 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else {return}
        let current = controllers.index(of: (pageViewController.viewControllers?.first!)!)!
        pageControl.currentPage = current
    }
}
