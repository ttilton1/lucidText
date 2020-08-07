//
//  TabBarController.swift
//  LucidText
//
//  Created by Thomas Tilton on 4/21/20.
//  Copyright © 2020 Thomas Tilton. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    var theValue: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToLibrary"{
            if let destinationVC = segue.destination.navigationController as? LibraryViewController {
                destinationVC.viewDidLoad()
            }
        }
    }
    */
    
    /*override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if (item.tag == 1) {
            self.viewDidLoad()
        }
    }
 */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
