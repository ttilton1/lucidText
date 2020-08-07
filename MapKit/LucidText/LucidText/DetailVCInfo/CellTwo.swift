//
//  CellTwo.swift
//  LucidText
//
//  Created by Thomas Tilton on 4/8/20.
//  Copyright © 2020 Thomas Tilton. All rights reserved.
//

import UIKit

class CellTwo: UICollectionViewCell {
    @IBOutlet var nameTwo: UILabel!
    @IBOutlet weak var buttonTwo: UIButton!
    //UITableViewDataSource, UITableViewDelegate
    
    //dataSource = ["Spanish", "French", "Russian"]
      
     //  let transparentView = UIView()
     //  let tableView = UITableView()
    //   var frameSize = CGRect(x:10, y: 100, width: 200, height: 200)
    //   var selectedButton = UIButton()
    //   var dataSource = [String]()
    
    //   var distToY = cellHeight*2 + inBetweenSpacing*2 + headerHeight
    
     //   tableView.delegate = self as! UITableViewDelegate
        
     //   tableView.dataSource = self as! UITableViewDataSource
        
    //    tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
    
    /*
     distToY = distToY + heightTest2 + 5
    //Add button and actions
    let heightTest3 = cell.frame.height * 0.25
    cell.langButton.titleLabel?.text = "Select Language"
    cell.langButton.frame = CGRect(x:10, y: heightTest2+5, width: widthTest-10, height: heightTest3)
    cell.langButton.setTitle("Select Language", for: .normal)
    cell.langButton.contentHorizontalAlignment = .left
    frameSize = cell.langButton.frame
    cell.langButton.addTarget(self, action: #selector(langButtonTapped), for: .touchUpInside)
    selectedButton = cell.langButton
     */
/*
     extension DetailViewController {
         func addTransparentView(frames: CGRect) {
             let window = UIApplication.shared.keyWindow
             transparentView.frame = window?.frame ?? self.view.frame
             self.view.addSubview(transparentView)
             
             //SEcond Print
             print("Second")
             //print(distToY)
            
             //tableView
             tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
             
             self.view.addSubview(tableView)
             tableView.layer.cornerRadius = 5
             
             transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
             let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
             transparentView.addGestureRecognizer(tapgesture)
             transparentView.alpha = 0.0
             let centerY = self.view.frame.height / 2
             let centerX = self.view.frame.width / 2
             let takeX = frames.width / 2
             let takeY = frames.height / 2
             UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                 transparentView.alpha = 0.5
                 tableView.frame = CGRect(x: centerX - takeX, y: centerY - takeY, width: frames.width, height: 200)
             }, completion: nil)
         }
         
         @objc func removeTransparentView(){
             let frames = selectedButton.frame
                 //selectedButton.frame
             UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                 transparentView.alpha = 0.0
                 tableView.frame = CGRect(x: frames.origin.x + 20, y: frames.origin.y + frames.height, width: frames.width, height: 0)
             }, completion: nil)
         }
         
         @IBAction func langButtonTapped(_ sender: Any) -> Void {
             frameSize = selectedButton.frame
             addTransparentView(frames: frameSize)
             print(frameSize)
         }
     }

     extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
         
         func numberOfSections(in tableView: UITableView) -> Int {
             return 1
         }
         
         func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
             return dataSource.count
         }
         func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
             cell.textLabel?.text = dataSource[indexPath.row]
             return cell
         }
         
         
         
     }

     */

}
