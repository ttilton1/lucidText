//
//  HomeViewController.swift
//  LucidText
//
//  Created by Thomas Tilton on 4/12/20.
//  Copyright © 2020 Thomas Tilton. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    //Colors
    let selectedSegmentTintColor: UIColor = .systemYellow
    let segmentBackgroundTintColor: UIColor = .black
    //Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var processButton: UIButton!
    @IBOutlet weak var sliderThing: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
         titleLabel.text = "Welcome to Lucid Text"
         titleLabel.numberOfLines = 0
         titleLabel.lineBreakMode = .byTruncatingTail
         titleLabel.minimumScaleFactor = 0.5
         titleLabel.sizeToFit()
        titleLabel.font = .systemFont(ofSize: 25, weight: .semibold)
        titleLabel.textAlignment = .center
         titleLabel.textColor = cellTextColor
        //TextLabel
         textLabel.text = "Paste your text below. Words that go past the box's capacity will still be processed."
         textLabel.numberOfLines = 0
         textLabel.lineBreakMode = .byTruncatingTail
         textLabel.minimumScaleFactor = 0.5
         textLabel.sizeToFit()
        textLabel.font = .systemFont(ofSize: 16, weight: .regular)
        textLabel.textAlignment = .center
         textLabel.textColor = cellTextColor
        // levelLabel.text = "Welcome to Lucid Text"
         levelLabel.text = "Select your learning level:"
         levelLabel.numberOfLines = 0
         levelLabel.lineBreakMode = .byTruncatingTail
         levelLabel.minimumScaleFactor = 0.5
         levelLabel.sizeToFit()
        titleLabel.textAlignment = .center
         levelLabel.textColor = cellTextColor
        //textview
        textView.sizeToFit()
        //cell.textView.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        textView.textColor = cellTextColor
        textView.layer.cornerRadius = cornerRadiusVar
        textView.layer.borderWidth = cellBorderWidth
        textView.layer.borderColor = cellBorderColor
        //Segment Adjust
        sliderThing.removeAllSegments()
        sliderThing.insertSegment(withTitle: "Beginner", at: 0, animated: true)
        sliderThing.insertSegment(withTitle: "Intermediate", at: 1, animated: true)
        sliderThing.insertSegment(withTitle: "Advanced", at: 2, animated: true)
        sliderThing.selectedSegmentTintColor = selectedSegmentTintColor
        sliderThing.tintColor = segmentBackgroundTintColor
       
        
        ColorFrames.styleFilledButton(processButton)
        processButton.setTitle("Process Text", for: .normal)
        processButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        // Do any additional setup after loading the view.
    }

    @IBAction func processTouched(_ sender: Any) {
    if let vc = storyboard?.instantiateViewController(withIdentifier: "processVC") as? ProcessedTextViewController {
       //vc.textToProcess = textView.text
      navigationController?.pushViewController(vc, animated: true)
     }
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
