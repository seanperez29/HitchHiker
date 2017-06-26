//
//  ContainerVC.swift
//  HitchHiker
//
//  Created by Sean Perez on 6/26/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import UIKit
import QuartzCore

enum SlideOutState {
    case collapsed
    case menuExpanded
}

enum ShowWhichVC {
    case homeVC
}

var showVC: ShowWhichVC = .homeVC

class ContainerVC: UIViewController {
    
    var homeVC: HomeVC!
    var menuVC: MenuVC!
    var centerController: UIViewController!
    var currentState: SlideOutState = .collapsed {
        didSet {
            let shouldShowShadow = currentState != .collapsed
            shouldShowShadowForCenterViewController(shouldShowShadow)
        }
    }
    var isHidden = false
    let centerPanelExpandedOffset: CGFloat = 160
    var tap: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        initCenter(screen: showVC)
    }
    
    func initCenter(screen: ShowWhichVC) {
        var presentingController: UIViewController
        showVC = screen
        if homeVC == nil {
            homeVC = UIStoryboard.homeVC()
            homeVC.delegate = self
        }
        presentingController = homeVC
        if let controller = centerController {
            controller.view.removeFromSuperview()
            controller.removeFromParentViewController()
        }
        centerController = presentingController
        view.addSubview(centerController.view)
        addChildViewController(centerController)
        centerController.didMove(toParentViewController: self)
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return isHidden
    }

}

extension ContainerVC: CenterVCDelegate {
    func toggleMenu() {
        let notAlreadyExpanded = currentState != .menuExpanded
        if notAlreadyExpanded {
            addMenuViewController()
        }
        animateMenu(shouldExpand: notAlreadyExpanded)
    }
    
    func addMenuViewController() {
        if menuVC == nil {
            menuVC = UIStoryboard.menuViewController()
            addChildMenuViewController(menuVC)
        }
    }
    
    func animateMenu(shouldExpand: Bool) {
        if shouldExpand {
            isHidden = !isHidden
            animateStatusBar()
            setupWhiteCoverView()
            currentState = .menuExpanded
            animateCenterPanelXPosition(targetPosition: centerController.view.frame.width - centerPanelExpandedOffset)
        
        } else {
            isHidden = !isHidden
            animateStatusBar()
            hideWhiteCoverView()
            animateCenterPanelXPosition(targetPosition: 0, completion: { (finished) in
                if finished {
                    self.currentState = .collapsed
                    self.menuVC = nil
                }
            })
        }
    }
    
    func addChildMenuViewController(_ menuController: MenuVC) {
        view.insertSubview(menuController.view, at: 0)
        addChildViewController(menuController)
        menuController.didMove(toParentViewController: self)
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { 
            self.centerController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
    func animateStatusBar() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { 
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
    
    func setupWhiteCoverView() {
        let whiteCoverView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        whiteCoverView.alpha = 0
        whiteCoverView.backgroundColor = UIColor.white
        whiteCoverView.accessibilityIdentifier = "whiteCoverView"
        self.centerController.view.addSubview(whiteCoverView)
        UIView.animate(withDuration: 0.2) { 
            whiteCoverView.alpha = 0.75
        }
        tap = UITapGestureRecognizer(target: self, action: #selector(animateMenu(shouldExpand:)))
        tap.numberOfTapsRequired = 1
        centerController.view.addGestureRecognizer(tap)
    }
    
    func  hideWhiteCoverView() {
        centerController.view.removeGestureRecognizer(tap)
        for subview in centerController.view.subviews {
            if subview.accessibilityIdentifier == "whiteCoverView" {
                UIView.animate(withDuration: 0.2, animations: { 
                    subview.alpha = 0
                }, completion: { _ in
                    subview.removeFromSuperview()
                })
            }
        }
    }
    
    func shouldShowShadowForCenterViewController(_ status: Bool) {
        if status {
            centerController.view.layer.shadowOpacity = 0.6
        } else {
            centerController.view.layer.shadowOpacity = 0
        }
    }
    
}

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    class func menuViewController() -> MenuVC? {
        return mainStoryboard().instantiateViewController(withIdentifier: "MenuVC") as? MenuVC
    }
    
    class func homeVC() -> HomeVC? {
        return mainStoryboard().instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
    }
}
