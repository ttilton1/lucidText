//
//  ProcessedTextViewController.swift
//  LucidText
//
//  Created by Thomas Tilton on 4/13/20.
//  Copyright © 2020 Thomas Tilton. All rights reserved.
//

import UIKit

private let reuseIdentifierTextTwo = "textTwoCell"
private let reuseIdentifierHardWords = "HardWordsCell"
var textToProcess = "Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb."
var defWords: [String] = ["little","lamb"]
var sectionsArray: [[String]] = [[textToProcess], defWords]

//setup
private let sectionInsets = UIEdgeInsets(top: 20.0,
left: 20.0, //was 20
    bottom: 5.0, //was 50
right: 20.0)

private let inBetweenSpacing: CGFloat = 5

private let cellHeightText: CGFloat = 250
private let cellHeightWords: CGFloat = 120
private let headerHeight: CGFloat = 70

private let itemsPerRow: CGFloat = 1

//Header
private let procHeadings = ["Processing is complete.", "Challenging Words"]
private let cellId = "cellId"
private let cellButtonId = "cellButtonId"

var newDefs: [String] = ["Def1", "Def2", "Def3"]
var hardWords: [String] = ["Hardword1", "HardWord2", "HardWord3"]

class ProcessedTextTwoViewController: UICollectionViewController {
    

   // var sectionsArray: [[String]] = [[self.textToProcess], self.defWords]

    override func viewDidLoad() {
        super.viewDidLoad()
       // var sectionsArray: [[String]] = [[textToProcess], defWords]

        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
     //   self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifierProcessedText)
        
     //   self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifierHardWords)
        collectionView?.register(CategoryCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.backgroundColor = backgroundColor
        self.collectionView?.reloadData()

        NotificationCenter.default.addObserver(self.collectionView!,
                                               selector: #selector(UICollectionView.reloadData),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)

        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (indexPath.section == 0) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierTextTwo, for: indexPath) as? textTwoCell else {
                fatalError("Unable to dequeue CellOne")
            }

            cell.textLabel.text = "Input Text"
                //headingLabels[0]
           // cell.textView.text = sectionsArray[0][0]
            
            cell.textLabel.numberOfLines = 0
            cell.textLabel.lineBreakMode = .byTruncatingTail
            cell.textLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
            cell.textLabel.minimumScaleFactor = 0.5
            cell.textLabel.sizeToFit()
            cell.textLabel.textColor = cellTextColor
            let widthTest = cell.frame.width - 20
           // let heightTest = cell.frame.height
            let heightTest2 = cell.frame.height * 0.15
            cell.textLabel.frame = CGRect(x: 10, y: 5, width: widthTest-10, height: heightTest2)
            
            //try highlighting

            /*
            let range = (sectionsArray[0][0] as NSString).range(of: "little")
            let attribute = NSMutableAttributedString.init(string: sectionsArray[0][0] )
            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
            cell.textView.attributedText = attribute
             */
            
            cell.textView.sizeToFit()
            cell.textView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            cell.textView.textColor = cellTextColor
            cell.textView.isEditable = false
            let widthTestTwo = cell.frame.width - 20
            let heightTestTwo = cell.frame.height * 0.8
            cell.textView.attributedText = generateAttributedString(with: "little", targetString: sectionsArray[0][0])
            cell.textView.frame = CGRect(x: 15, y: 5 + heightTest2, width: widthTestTwo-10, height: heightTestTwo)
            
           // cell.textView.layer.cornerRadius = cornerRadiusVar
           // cell.textView.layer.borderWidth = cellBorderWidth
           // cell.textView.layer.borderColor = cellBorderColor
            
            cell.layer.cornerRadius = cornerRadiusVar
            cell.layer.borderWidth = cellBorderWidth
            cell.layer.borderColor = cellBorderColor
            cell.layer.backgroundColor = cellBackgroundColor
            
        
           //NEED TO ADD INDEXO OATH SECTION
            return cell
        } else if (indexPath.section == 1) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCell
            
            return cell
               //NEED TO ADD INDEXO OATH SECTION
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellButtonId, for: indexPath) as! buttonCell
            cell.addButton.setTitle("Add Words to Dictionary", for: .normal)
            cell.addButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            ColorFrames.styleFilledButton(cell.addButton)
             let widthTestTwo = cell.frame.width - 10
            let heightTestTwo = cell.frame.height * 0.5
            cell.addButton.layer.frame = CGRect(x: 10, y: 0, width: widthTestTwo-10, height: heightTestTwo)
            cell.addButton.addTarget(self, action: #selector(self.saveToDictionary), for: .touchUpInside)
            cell.isUserInteractionEnabled = true
            return cell
        }
    
        // Configure the cell
        
   
    }
    
    func generateAttributedString(with searchTerm: String, targetString: String) -> NSAttributedString? {

        let attributedString = NSMutableAttributedString(string: targetString)
        do {
            let regex = try NSRegularExpression(pattern: searchTerm.trimmingCharacters(in: .whitespacesAndNewlines).folding(options: .diacriticInsensitive, locale: .current), options: .caseInsensitive)
            let range = NSRange(location: 0, length: targetString.utf16.count)
            for match in regex.matches(in: targetString.folding(options: .diacriticInsensitive, locale: .current), options: .withTransparentBounds, range: range) {
                attributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.red, range: match.range)

              //  attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold), range: match.range)
                //NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range
            }
            return attributedString
        } catch {
            NSLog("Error creating regular expresion: \(error)")
            return nil
        }
    }
    
    @objc func saveToDictionary(sender: UIButton) {
        print("Tap Tap")
    }
    /*
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
             withReuseIdentifier: "procHeaderVC",
             for: indexPath) as? ProcessHeaderView
           else {
             fatalError("Invalid view type")
         }
        
         headerView.label.text = procHeadings[indexPath.section]
         if indexPath.section == 0 {
            headerView.label.font = UIFont.boldSystemFont(ofSize: 15.0)
         } else{
            headerView.label.font = UIFont.boldSystemFont(ofSize: 27.0)
         }
         
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
*/


}

extension ProcessedTextTwoViewController : UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
  
 
    //1
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    if indexPath.section == 0{
        return CGSize(width: widthPerItem, height: cellHeightText)
    }
    return CGSize(width: widthPerItem, height: cellHeightWords)
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

