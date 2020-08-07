//
//  MainViewController.swift
//  LucidText
//
//  Created by Thomas Tilton on 4/1/20.
//  Copyright © 2020 Thomas Tilton. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UINavigationControllerDelegate {

    
    //Outlets
    @IBOutlet weak var textViewTry: UITextView!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectLevel: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        //Design Title Label
         titleLabel.text = "Welcome to Lucid Text"
         titleLabel.numberOfLines = 0
         titleLabel.lineBreakMode = .byTruncatingTail
         titleLabel.minimumScaleFactor = 0.5
         titleLabel.sizeToFit()
        titleLabel.font = .systemFont(ofSize: 25, weight: .semibold)
        titleLabel.textAlignment = .center
         titleLabel.textColor = cellTextColor
        
        // levelLabel.text = "Welcome to Lucid Text"
         levelLabel.text = "Select your learning level:"
         levelLabel.numberOfLines = 0
         levelLabel.lineBreakMode = .byTruncatingTail
         levelLabel.minimumScaleFactor = 0.5
         levelLabel.sizeToFit()
         levelLabel.textColor = cellTextColor
        
        //textview
        //textViewTry.text = "Placeholder"
        //textViewTry.textColor = UIColor.lightGray
        
        
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
