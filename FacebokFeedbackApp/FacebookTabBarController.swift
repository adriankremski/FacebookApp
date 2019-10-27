//
//  FacebookTabBarControllerViewController.swift
//  FacebokFeedbackApp
//
//  Created by Adrian Kremski on 26/10/2019.
//  Copyright © 2019 Adrian Kremski. All rights reserved.
//

import UIKit

class FacebookTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let feedController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let navigationController = UINavigationController(rootViewController: feedController)
        navigationController.title = "News feed"
        navigationController.tabBarItem.image = UIImage(named: "news_feed")
        
        let friendRequestController = FriendRequestsController()
        let secondNavigationController = UINavigationController(rootViewController: friendRequestController)
        secondNavigationController.title = "Requests"
        secondNavigationController.tabBarItem.image = UIImage(named: "friends_requests")
        
        let messangerController = MessangerViewController()
        messangerController.navigationItem.title = "Messanger"
        let messangerNavigationController = UINavigationController(rootViewController: messangerController)
        messangerNavigationController.title = "Messanger"
        messangerNavigationController.tabBarItem.image = UIImage(named: "messanger")
        
        let notificationsController = UIViewController()
        notificationsController.navigationItem.title = "Notifications"
        let notificationsNavController = UINavigationController(rootViewController: notificationsController)
        notificationsNavController.title = "Notifications"
        notificationsNavController.tabBarItem.image = UIImage(named: "notifications")
        
        let moreController = UIViewController()
        moreController.navigationItem.title = "More"
        let moreNavController = UINavigationController(rootViewController: moreController)
        moreNavController.title = "More"
        moreNavController.tabBarItem.image = UIImage(named: "more")
        
        viewControllers = [navigationController, secondNavigationController, messangerNavigationController, notificationsNavController, moreNavController]
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        topBorder.backgroundColor = UIColor.rgb(red: 229, green: 231, blue: 235).cgColor
        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
