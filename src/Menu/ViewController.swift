//
//  ViewController.swift
//  Menu
//
//  Created by Sergio Cirasa on 1/1/17.
//  Copyright © 2017 Sergio Cirasa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MenuDelegate {

    let defaultAnimationDuration : TimeInterval = 0.4
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var menuContainerView: UIView!
    @IBOutlet weak var overlayShadowView: UIView!
    @IBOutlet weak var menuMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tapGesture: UITapGestureRecognizer!
    
    var menuViewController : MenuViewController?
    var currentContentViewController : UINavigationController?
    var menuAnimationInProgress = false
    var startDraggingPositionX : CGFloat = 0.0 
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
//------------------------------------------------------------------------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if(self.view.frame.size.width > 320){
            menuWidthConstraint.constant = menuWidthConstraint.constant + 30;
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterBackground(notification:)), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
        
    }
    
    override func viewDidLayoutSubviews(){
        if (currentContentViewController==nil){
            onHomeAction()
        }
    }
//------------------------------------------------------------------------------------------------------------------------------------------
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
//------------------------------------------------------------------------------------------------------------------------------------------
    func applicationWillEnterBackground(notification: NSNotification) {
        if(isMenuOpen()){
            closeMenu();
        }
    }
//------------------------------------------------------------------------------------------------------------------------------------------
    func createMenuBarButtonItem() -> UIBarButtonItem {
        
        let button = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named: "hamburgerIcon"), for: UIControlState.normal)
        button.frame = CGRect(x:0, y:0, width:44, height:44)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -26, 0, 0);
        button.addTarget(self, action: #selector(toggleMenu), for: UIControlEvents.touchUpInside)
        
        let leftButton = UIBarButtonItem(customView: button)
        return leftButton;
    }
//------------------------------------------------------------------------------------------------------------------------------------------
    func animationDurationForDistance(_ dist:CGFloat) -> TimeInterval {
        return (TimeInterval(dist)*defaultAnimationDuration) / TimeInterval(self.menuWidthConstraint.constant);
    }
//------------------------------------------------------------------------------------------------------------------------------------------
    func addSubview( subview: UIView, toView parentView:UIView)
    {

        parentView.addSubview(subview)
        /*
        parentView.addConstraint(NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: parentView, attribute: .top, multiplier: 1.0, constant: 0.0))
        parentView.addConstraint(NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: parentView, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        
        parentView.addConstraint(NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: parentView, attribute: .leading, multiplier: 1.0, constant: 0.0))
        parentView.addConstraint(NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: parentView, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        */
    }
//------------------------------------------------------------------------------------------------------------------------------------------
    func swapViewControllers(oldNavigation: UINavigationController?, newNavigation:UINavigationController ){
        
        if let oldViewController = oldNavigation{
            oldViewController.willMove(toParentViewController: nil)
            self.addChildViewController(newNavigation)
            self.addSubview(subview: newNavigation.view, toView: self.containerView)
            newNavigation.view.layoutIfNeeded()
            newNavigation.view.alpha = 0;
            
            UIView.animate(withDuration: defaultAnimationDuration, delay: 0.0, options: [.allowUserInteraction], animations: {
                newNavigation.view.alpha = 1;
                oldViewController.view.alpha = 0;
            }, completion: { finished in
                oldViewController.view.removeFromSuperview();
                oldViewController.removeFromParentViewController();
                newNavigation.didMove(toParentViewController: self);
                self.currentContentViewController = newNavigation;
            })
        }else{
            self.addChildViewController(newNavigation)
            self.addSubview(subview: newNavigation.view, toView: self.containerView)
            newNavigation.view.layoutIfNeeded()
            newNavigation.didMove(toParentViewController: self);
            self.currentContentViewController = newNavigation;
        }
        
    }
//------------------------------------------------------------------------------------------------------------------------------------------
    // MARK: -  SliderMenuDelegate
    func onHomeAction(){
        print("Hello onHomeAction")
        let vc = UIViewController(nibName: nil, bundle: nil)
        vc.view.backgroundColor = UIColor.green;
        let nav = UINavigationController(rootViewController: vc)
        nav.topViewController?.navigationItem.leftBarButtonItem = createMenuBarButtonItem()
        swapViewControllers(oldNavigation: self.currentContentViewController, newNavigation:nav)
        closeMenu()
    }
    
    func onAboutAction(){
    print("Hello onAboutAction")
        let vc = UIViewController(nibName: nil, bundle: nil)
        vc.view.backgroundColor = UIColor.blue;
        let nav = UINavigationController(rootViewController: vc)
        nav.topViewController?.navigationItem.leftBarButtonItem = createMenuBarButtonItem()
        swapViewControllers(oldNavigation: self.currentContentViewController!, newNavigation:nav)
        closeMenu()
    }
    
    func onHelpAction(){
    print("Hello onHelpAction")
        let vc = UIViewController(nibName: nil, bundle: nil)
        vc.view.backgroundColor = UIColor.purple;
        let nav = UINavigationController(rootViewController: vc)
        nav.topViewController?.navigationItem.leftBarButtonItem = createMenuBarButtonItem()
        swapViewControllers(oldNavigation: self.currentContentViewController!, newNavigation:nav)
        closeMenu()
    }
    
    func onTermAndConditionsAction(){
    print("Hello onTermAndConditionsAction")
        let vc = UIViewController(nibName: nil, bundle: nil)
        vc.view.backgroundColor = UIColor.red;
        self.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(vc, animated: true, completion: {
            self.closeMenu()
        })
    }
    //------------------------------------------------------------------------------------------------------------------------------------------
    // MARK: - Segue Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if let identifier = segue.identifier{
            
            if(identifier=="MenuViewController"){
                self.menuViewController = segue.destination as? MenuViewController;
                self.menuViewController?.delegate = self;
            }
        }
    }
//------------------------------------------------------------------------------------------------------------------------------------------
    // MARK: - Menu Methods
    func isMenuOpen() -> Bool {
        
        if(self.menuMarginConstraint.constant == self.menuWidthConstraint.constant){
            return true;
        }
        return false;
    }
//------------------------------------------------------------------------------------------------------------------------------------------
    func openMenu()
    {
        self.menuAnimationInProgress = true;
        self.menuMarginConstraint.constant = self.menuWidthConstraint.constant;
        self.overlayShadowView.alpha = 0.0;
        self.overlayShadowView.isHidden = false;
        
        UIView.animate(withDuration: defaultAnimationDuration, delay: 0.0, options: [.allowUserInteraction], animations: {
            self.overlayShadowView.alpha = 1.0
            self.view.layoutIfNeeded()
        }, completion: { finished in
            self.menuAnimationInProgress = false;
            self.tapGesture.isEnabled = true;
        })
    }
//------------------------------------------------------------------------------------------------------------------------------------------
    func closeMenu()
    {
        self.menuAnimationInProgress = true;
        self.menuMarginConstraint.constant = 0;
        
        UIView.animate(withDuration: defaultAnimationDuration, delay: 0.0, options: [.allowUserInteraction], animations: {
            self.overlayShadowView.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: { finished in
            self.overlayShadowView.isHidden = true;
            self.menuAnimationInProgress = false;
            self.tapGesture.isEnabled = false;
        })
    }
//------------------------------------------------------------------------------------------------------------------------------------------
    func toggleMenu()
    {
        if(self.menuAnimationInProgress){
            return;
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.dissmissKeyboardNotificationName), object: nil)
        
        if(isMenuOpen()){
            closeMenu();
        }else{
            openMenu();
        }
    }
//------------------------------------------------------------------------------------------------------------------------------------------
    // MARK: - Gesture Recognizer Methods
    @IBAction func onTapGesture(_ sender: Any)
    {
        if(self.menuAnimationInProgress){
            return;
        }
        
        if(self.isMenuOpen()){
            closeMenu();
        }
    }
//------------------------------------------------------------------------------------------------------------------------------------------
    @IBAction func onPanGesture(_ gesture: UIPanGestureRecognizer)
    {
        if(self.menuAnimationInProgress){
            return;
        }
        
        if (gesture.state == UIGestureRecognizerState.began) {
            self.startDraggingPositionX = self.menuMarginConstraint.constant;
            
        }else if (gesture.state == UIGestureRecognizerState.changed) {
            
            let translation = gesture.translation(in: self.view)
            if(self.startDraggingPositionX + translation.x < 0){
                self.menuMarginConstraint.constant = 0;
            }else if (self.startDraggingPositionX + translation.x > self.menuWidthConstraint.constant){
                self.menuMarginConstraint.constant = self.menuWidthConstraint.constant;
            }else{
                self.menuMarginConstraint.constant = self.startDraggingPositionX + translation.x;
            }
            
        }else if (gesture.state == UIGestureRecognizerState.ended) {
            
            let gestureVelocity = gesture.velocity(in: self.view)
            let translation = gesture.translation(in: self.view)
            let xx = self.startDraggingPositionX + translation.x;
            var dist :CGFloat = 0.0;
            self.menuAnimationInProgress = true;
            
            if(xx >= self.menuWidthConstraint.constant * 0.5 && gestureVelocity.x > 0){
                dist = self.menuWidthConstraint.constant - self.menuMarginConstraint.constant;
                self.menuMarginConstraint.constant = self.menuWidthConstraint.constant;
            }else if((xx < self.menuWidthConstraint.constant * 0.5 && gestureVelocity.x > 0) || (xx < self.menuWidthConstraint.constant * 0.75 && gestureVelocity.x < 0)){
                dist = self.menuMarginConstraint.constant;
                self.menuMarginConstraint.constant = 0;
            }else{
                dist = self.menuWidthConstraint.constant - self.menuMarginConstraint.constant;
                self.menuMarginConstraint.constant = self.menuWidthConstraint.constant;
            }
            
            let willOpen = (self.menuMarginConstraint.constant == self.menuWidthConstraint.constant);
            if(!willOpen){
               // [self.menuButton animateToType:buttonMenuType];
            }
            
            UIView.animate(withDuration: animationDurationForDistance(dist), delay: 0.0, options: [.allowUserInteraction, .curveEaseOut], animations: {
                self.view.layoutIfNeeded()
                self.overlayShadowView.alpha = willOpen ? 1 : 0;
            }, completion: { finished in
                self.menuAnimationInProgress = false;
                self.tapGesture.isEnabled = self.isMenuOpen();
                self.overlayShadowView.isHidden = !willOpen;
            })
        }
    }
    
}
