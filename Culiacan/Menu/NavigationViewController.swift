//
//  NavigationViewController.swift
//  Culiacan
//
//  Created by Armando Trujillo on 08/12/14.
//  Copyright (c) 2014 RedRabbit. All rights reserved.
//

import UIKit

class NavigationViewController: ENSideMenuNavigationController, ENSideMenuDelegate {

    var view2 : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu = ENSideMenu(sourceView: self.view, menuViewController: MenuTableViewController(), menuPosition:.Left)
        sideMenu?.delegate = self //optional
        sideMenu?.menuWidth = 245.0 // optional, default is 160
        //sideMenu?.bouncingEnabled = false
        // make navigation bar showing over side menu
        view.bringSubviewToFront(navigationBar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
        println("sideMenuWillOpen")
        view2 = UIView(frame: CGRectMake(245,65,1000,1000))
        view2.backgroundColor = UIColor.clearColor()
        self.view.addSubview(view2)
    }
    
    func sideMenuWillClose() {
        println("sideMenuWillClose")
        if (view2 != nil) {
            view2.removeFromSuperview()
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
