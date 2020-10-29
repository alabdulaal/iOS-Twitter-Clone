//
//  BaseMenuController.swift
//  iOS-Twitter-Automation
//
//  Created by ahmed on 2/11/19.
//  Copyright © 2019 com.ahmed. All rights reserved.
//

import UIKit
import TwitterKit

class BaseMenuController: UIViewController {
    
    var menuLeadingConstraint: NSLayoutConstraint!
    var rightViewController: UIViewController?
    var menuLeadingTrailingConstraint: NSLayoutConstraint!
    
    let mainViewContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let menuViewContainer: UIView = {
        let v = UIView()
        v.backgroundColor = .blue
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let darkCoverView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0, alpha: 0.7)
        v.alpha = 0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpGestures()
        ActivityIndicator.shared.hideLoaderView()
    }
    
    func didSelectMenuItem(indexPath: IndexPath) {
        performRightViewCleanUp()
        closeMenu()
        print(indexPath.row)
        switch indexPath.row {
        case 0:
            rightViewController = UINavigationController(rootViewController: MainTableViewController())

        default:
            print("Default")
        }
        
        menuViewContainer.addSubview(rightViewController!.view)
        addChild(rightViewController!)
        menuViewContainer.bringSubviewToFront(darkCoverView)
    }
    
    // PanGesture to control menu open and close
    @objc func handlePan(gesture: UIPanGestureRecognizer){
        
        let translation = gesture.translation(in: view)
        var x = translation.x
        
        x = isMenuOpen ? x + menuWidth : x
        x = min(menuWidth, x)
        x = max(0, x)
        
        menuLeadingConstraint.constant = x
        menuLeadingTrailingConstraint.constant = x
        darkCoverView.alpha = x / menuWidth
        
        if gesture.state == .ended {
            handleGestureEnded(gesture: gesture)
        }
    }

    @objc func handleTapDismiss(){
        closeMenu()
    }
    
    
    // Mark: - fileprivate 
    
    fileprivate let menuWidth: CGFloat = 280
    fileprivate let velocityThreshold: CGFloat = 500
    fileprivate var isMenuOpen: Bool = false
    
    fileprivate func handleGestureEnded(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        
        if isMenuOpen {
            if abs(velocity.x) > velocityThreshold {
                closeMenu()
                return
            }
            if abs(translation.x) < menuWidth / 2 {
                openMenu()
            } else {
                closeMenu()
            }
        } else {
            if abs(velocity.x) > velocityThreshold {
                openMenu()
                return
            }
            
            if translation.x < menuWidth / 2 {
                closeMenu()
            } else {
                openMenu()
            }
        }
        
    }
    
    
    @objc fileprivate func openMenu() {
        isMenuOpen = true
        menuLeadingConstraint.constant = menuWidth
        menuLeadingTrailingConstraint.constant = menuWidth
        performAnimations()
    }
    
    fileprivate func closeMenu() {
        menuLeadingConstraint.constant = 0
        menuLeadingTrailingConstraint.constant = 0
        isMenuOpen = false
        performAnimations()
    }
    
    fileprivate func performAnimations() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.darkCoverView.alpha = self.isMenuOpen ? 1 : 0
        })
    }
    
    fileprivate func setUpViews(){
        view.addSubview(mainViewContainer)
        mainViewContainer.addSubview(darkCoverView)
        view.addSubview(menuViewContainer)
        
        NSLayoutConstraint.activate([
            mainViewContainer.topAnchor.constraint(equalTo: view.topAnchor),
            mainViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            menuViewContainer.topAnchor.constraint(equalTo: view.topAnchor),
            menuViewContainer.trailingAnchor.constraint(equalTo: mainViewContainer.leadingAnchor),
            menuViewContainer.widthAnchor.constraint(equalToConstant: menuWidth),
            menuViewContainer.bottomAnchor.constraint(equalTo: mainViewContainer.bottomAnchor)
            ])
        
        menuLeadingConstraint = mainViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        menuLeadingConstraint.isActive = true
        
        menuLeadingTrailingConstraint = mainViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        menuLeadingTrailingConstraint.isActive = true
        
        setupViewControllers()
    }
    
    fileprivate func setupViewControllers(){
        
        let homeController = UINavigationController(rootViewController: MainTableViewController())
        let menuController = LeftMenuController()
        
        let homeControllerView = homeController.view!
        let menuControllerView = menuController.view!
        
        homeControllerView.translatesAutoresizingMaskIntoConstraints = false
        menuControllerView.translatesAutoresizingMaskIntoConstraints = false
        
        mainViewContainer.addSubview(homeControllerView)
        mainViewContainer.addSubview(darkCoverView)

        menuViewContainer.addSubview(menuControllerView)
        
        NSLayoutConstraint.activate([
            homeControllerView.topAnchor.constraint(equalTo: mainViewContainer.topAnchor),
            homeControllerView.leadingAnchor.constraint(equalTo: mainViewContainer.leadingAnchor),
            homeControllerView.bottomAnchor.constraint(equalTo: mainViewContainer.bottomAnchor),
            homeControllerView.trailingAnchor.constraint(equalTo: mainViewContainer.trailingAnchor),
            
            menuControllerView.topAnchor.constraint(equalTo: menuViewContainer.topAnchor),
            menuControllerView.leadingAnchor.constraint(equalTo: menuViewContainer.leadingAnchor),
            menuControllerView.bottomAnchor.constraint(equalTo: menuViewContainer.bottomAnchor),
            menuControllerView.trailingAnchor.constraint(equalTo: menuViewContainer.trailingAnchor),
            
            darkCoverView.topAnchor.constraint(equalTo: mainViewContainer.topAnchor),
            darkCoverView.leadingAnchor.constraint(equalTo: mainViewContainer.leadingAnchor),
            darkCoverView.bottomAnchor.constraint(equalTo: mainViewContainer.bottomAnchor),
            darkCoverView.trailingAnchor.constraint(equalTo: mainViewContainer.trailingAnchor),
            ])
        
        addChild(homeController)
        addChild(menuController)
    }
    
    fileprivate func performRightViewCleanUp() {
        rightViewController!.view.removeFromSuperview()
        rightViewController!.removeFromParent()
    }
    
    fileprivate func setUpGestures() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(openMenu), name: Notification.Name(rawValue: "openMenu"), object: nil)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss))
        darkCoverView.addGestureRecognizer(tapGesture)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "openMenu"), object: nil)
    }

}
