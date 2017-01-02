//
//  MenuViewController.swift
//  Menu
//
//  Created by Sergio Cirasa on 1/1/17.
//  Copyright © 2017 Sergio Cirasa. All rights reserved.
//

import UIKit

protocol MenuDelegate : NSObjectProtocol{
    func onHomeAction()
    func onAboutAction()
    func onHelpAction()
    func onTermAndConditionsAction()
}

class MenuViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var tableView: UITableView!
    var itemSelected = 0
    let menuData = NSArray(contentsOfFile: (Bundle.main.resourcePath! as NSString).appendingPathComponent("Menu.plist"))
    var delegate : MenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.bounces = false;
        self.tableView.scrollsToTop = false;
        self.tableView.alwaysBounceVertical = false;

    }

    // MARK: - UITableViewDelegate
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 50.0;
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.itemSelected = indexPath.row;
        let data = self.menuData?.object(at: indexPath.row) as? NSDictionary
        if let del = self.delegate{
            del.perform(Selector((data?.object(forKey: "event_name") as! String?)!))
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (self.menuData?.count)!
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let CellIdentifier = "SliderMenuTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? SliderMenuTableViewCell
        let data = self.menuData?.object(at: indexPath.row) as? NSDictionary
        cell?.titleLabel.text = data?.object(forKey: "title") as! String?
        cell?.imageView?.image = UIImage(named: data?.object(forKey: "icon") as! String)
        return cell!
    }
    
}
