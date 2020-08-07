//
//  DetailViewController.swift
//  LucidText
//
//  Created by Thomas Tilton on 4/7/20.
//  Copyright © 2020 Thomas Tilton. All rights reserved.
//

import UIKit

private let reuseIdentifier1 = "CellOne"
private let reuseIdentifier2 = "CellTwo"

//Cell standards

private let sectionInsets = UIEdgeInsets(top: 0.0,
left: 20.0, //was 20
    bottom: 0.0, //was 50
right: 20.0)

private let inBetweenSpacing: CGFloat = 5

private let cellHeight: CGFloat = 120
private let headerHeight: CGFloat = 70

private let itemsPerRow: CGFloat = 1

//Colors
let backgroundColor = UIColor(named: "appLightBlue") ?? UIColor(red: 230/255, green: 238/255, blue: 255/255, alpha: 1)
let cellTextColor = UIColor.black
let cellBackgroundColor = UIColor.white.cgColor
let cellBorderColor = UIColor(named: "appGray")!.cgColor
    //?? .black.withAlphaComponent(0.2).cgColor
let cellBorderWidth: CGFloat = 2.0
//ScroolMenu

//Making second section
//let wordClickedOn: [String] = ["Definition", "Translation"]
//
//let languageTranslation: [String] = ["Spanish", "Hindi", "Arabic", "Mandarin", "Bengali", "Portuguese"]

var headings = ["WordClickedOn", "Translations"]
//let translations = ["Translation1", "Translation2", "Translation", "Translation4", "Translation5", "Translation6"]
//Passed variables
var cornerRadiusVar: CGFloat = 7
//BEGIN CLASSES



class DetailViewController: UICollectionViewController {
    
    var navTitle:String = ""
    var definition: String = ""
    var synonym: String = ""
    var spTrans: String = ""
    var hiTrans: String = ""
    var arTrans: String = ""
    var chTrans: String = ""
    var bnTrans: String = ""
    var ptTrans: String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let image:UIImage = UIImage(named: "lucidHeader")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        self.navigationItem.titleView = imageView
        headings[0] = navTitle
        print(headings)
        print("FIRST")
       // print(distToY)
        //self.title = "Lucid Text"
        self.navigationItem.title = "Lucid Text"
        self.tabBarItem.title = "Library"
        
        collectionView.backgroundColor = backgroundColor
        self.collectionView?.reloadData()

        NotificationCenter.default.addObserver(self.collectionView!,
                                               selector: #selector(UICollectionView.reloadData),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)
    }
    
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard
            let previousTraitCollection = previousTraitCollection,
            self.traitCollection.verticalSizeClass != previousTraitCollection.verticalSizeClass ||
            self.traitCollection.horizontalSizeClass != previousTraitCollection.horizontalSizeClass
        else {
            return
        }
       
        self.collectionView?.collectionViewLayout.invalidateLayout()
        self.collectionView?.reloadData()
    }
    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return headings.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        //return headingLabels.count
        if section == 0 {
            return 2
        } else {
            return 6
        }
        //return itemHeads[section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    
        if indexPath.row == 0 && indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier1, for: indexPath) as? CellOne else {
                fatalError("Unable to dequeue CellOne")
            }

            cell.nameOne.text = "Definition"
                //headingLabels[0]
            cell.textView.text = definition
            
            cell.nameOne.numberOfLines = 0
            cell.nameOne.lineBreakMode = .byTruncatingTail
            cell.nameOne.font = UIFont.boldSystemFont(ofSize: 25.0)
            cell.nameOne.minimumScaleFactor = 0.5
            cell.nameOne.sizeToFit()
            cell.nameOne.textColor = cellTextColor
            let widthTest = cell.frame.width - 20
           // let heightTest = cell.frame.height
            let heightTest2 = cell.frame.height * 0.25
            cell.nameOne.frame = CGRect(x: 10, y: 5, width: widthTest-10, height: heightTest2)
            
            cell.textView.sizeToFit()
            cell.textView.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            cell.textView.textColor = cellTextColor
            cell.textView.isEditable = false
            let widthTestTwo = cell.frame.width - 20
            let heightTestTwo = cell.frame.height * 0.6
            cell.textView.frame = CGRect(x: 10, y: 5 + heightTest2, width: widthTestTwo-10, height: heightTestTwo)

            cell.layer.cornerRadius = cornerRadiusVar
            cell.layer.borderWidth = cellBorderWidth
            cell.layer.borderColor = cellBorderColor
            cell.layer.backgroundColor = cellBackgroundColor
            
        
           //NEED TO ADD INDEXO OATH SECTION
            return cell
        } else if indexPath.row == 1 && indexPath.section == 0 {  //SYNONYM CELL
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier1, for: indexPath) as? CellOne else {
                fatalError("Unable to dequeue CellOne")
            }
            cell.nameOne.text = "Synonyms"
            cell.textView.text = synonym
             
             cell.nameOne.numberOfLines = 0
             cell.nameOne.lineBreakMode = .byTruncatingTail
             cell.nameOne.font = UIFont.boldSystemFont(ofSize: 25.0)
             cell.nameOne.minimumScaleFactor = 0.5
             cell.nameOne.sizeToFit()
             cell.nameOne.textColor = cellTextColor
             let widthTest = cell.frame.width - 20
            // let heightTest = cell.frame.height
             let heightTest2 = cell.frame.height * 0.25
             cell.nameOne.frame = CGRect(x: 10, y: 5, width: widthTest-5, height: heightTest2)
             
             cell.textView.sizeToFit()
             cell.textView.font = UIFont.systemFont(ofSize: 18, weight: .regular)
             cell.textView.textColor = cellTextColor
             cell.textView.isEditable = false
             let widthTestTwo = cell.frame.width - 20
             let heightTestTwo = cell.frame.height * 0.6
             cell.textView.frame = CGRect(x: 10, y: 5 + heightTest2, width: widthTestTwo-10, height: heightTestTwo)

             cell.layer.cornerRadius = cornerRadiusVar
             cell.layer.borderWidth = cellBorderWidth
             cell.layer.borderColor = cellBorderColor
             cell.layer.backgroundColor = cellBackgroundColor

            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier1, for: indexPath) as? CellOne else {
                fatalError("Unable to dequeue CellTwo")
            }
            if indexPath.row == 0 {
                cell.nameOne.text = "Spanish"
                cell.textView.text = spTrans
            
            } else if indexPath.row == 1 {
                cell.nameOne.text = "Hindi"
                cell.textView.text = hiTrans
            } else if indexPath.row == 2 {
                cell.nameOne.text = "Arabic"
                cell.textView.text = arTrans
            } else if indexPath.row == 3 {
                cell.nameOne.text = "Mandarin"
                cell.textView.text = chTrans
            } else if indexPath.row == 4 {
                cell.nameOne.text = "Bengali"
                cell.textView.text = bnTrans
            } else {
                cell.nameOne.text = "Portuguese"
                cell.textView.text = ptTrans
            }
            //cell.nameTwo.text = headingLabels[2]

           // cell.textView.text = translations[indexPath.row]
            //Formatting LAbel
            cell.nameOne.numberOfLines = 0
            cell.nameOne.lineBreakMode = .byTruncatingTail
            cell.nameOne.font = UIFont.boldSystemFont(ofSize: 25.0)
            cell.nameOne.minimumScaleFactor = 0.5
            cell.nameOne.sizeToFit()
            cell.nameOne.textColor = cellTextColor
            let widthTest = cell.frame.width - 20
           // let heightTest = cell.frame.height
            let heightTest2 = cell.frame.height * 0.25
            cell.nameOne.frame = CGRect(x: 10, y: 5, width: widthTest-10, height: heightTest2)
           //Text View Format
            cell.textView.sizeToFit()
            cell.textView.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            cell.textView.textColor = cellTextColor
            cell.textView.isEditable = false
            let widthTestTwo = cell.frame.width - 20
            let heightTestTwo = cell.frame.height * 0.6
            cell.textView.frame = CGRect(x: 10, y: 5 + heightTest2, width: widthTestTwo-10, height: heightTestTwo)

            //---------Cell Features ---------
            cell.layer.cornerRadius = cornerRadiusVar
            cell.layer.borderWidth = cellBorderWidth
            cell.layer.borderColor = cellBorderColor
            cell.layer.backgroundColor = cellBackgroundColor
            
            return cell
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                  viewForSupplementaryElementOfKind kind: String,
                                  at indexPath: IndexPath) -> UICollectionReusableView {
       // 1
       switch kind {
       // 2
       case UICollectionView.elementKindSectionHeader:
         // 3
         guard
           let headerView = collectionView.dequeueReusableSupplementaryView(
             ofKind: kind,
             withReuseIdentifier: "detailHeader",
             for: indexPath) as? DetailHeaderView
           else {
             fatalError("Invalid view type")
         }
        
         headerView.label.text = headings[indexPath.section]
         headerView.label.font = UIFont.boldSystemFont(ofSize: 27.0)
         headerView.backgroundColor = backgroundColor
         return headerView
     
       default:
         // 4
         assert(false, "Invalid element type")
       }
     }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: headerHeight)
        
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension DetailViewController : UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
  

    //1
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    
    return CGSize(width: widthPerItem, height: cellHeight)
  }
  
  //3
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }
  
  // 4
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return inBetweenSpacing
  }
}

