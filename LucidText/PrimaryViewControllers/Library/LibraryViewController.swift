//
//  LibraryViewController.swift
//  LucidText
//
//  Created by Thomas Tilton on 4/1/20.
//  Copyright © 2020 Thomas Tilton. All rights reserved.
//

import Foundation

import UIKit
import CoreData

var oldWords = [SavedWord]()
//var trackerBool: Bool = true
//var trackerName: String = "Hello"

class LibraryViewController: UICollectionViewController, UITabBarDelegate {

    var cornerRadiusVar: CGFloat = 7
    //Properties
    private let reuseIdentifier = "wordCell"
    //insets
    private let sectionInsets = UIEdgeInsets(top: 0.0,
    left: 20.0, //was 20
    bottom: 50.0, //was 50
    right: 20.0)
    
    private let inBetweenSpacing: CGFloat = 5
    
    private let cellHeight: CGFloat = 70
    
    private var libraryWords = ["HardWord1", "HardWord2", "HardWord3", "HardWord4", "WordArjunWordArjunWordArjunWordArjunWordArjunWordArjunWordArjun", "HardWord1", "HardWord2", "HardWord3", "HardWord4", "HardWord1", "HardWord2", "HardWord3", "HardWord4"]
    
    
    private let itemsPerRow: CGFloat = 1
    
    //Colors
   // let backgroundColor = UIColor(red: 230/255, green: 238/255, blue: 255/255, alpha: 1)
    //let cellTextColor = UIColor.black
   // let cellBackgroundColor = UIColor.white.cgColor
  //  let cellBorderColor = UIColor.black.withAlphaComponent(0.2).cgColor
 //   let cellBorderWidth: CGFloat = 2.0
   /* func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem){
        if tabBar.selectedItem?.tag == 1 {
            self.viewDidLoad()
        }
    }
    */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidLoad()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(deleteAll))
     

        //SharingManager.sharedInstance.loadSavedData = loadSavedData
        //self.tabBarController?.delegate = (self as! UITabBarControllerDelegate)
        container = NSPersistentContainer(name: "LucidText")
        container.loadPersistentStores { storeDescription, error in
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        loadSavedData()
        /*
        NotificationCenter.default.addObserver(self, selector: #selector(loadSavedDataObjC), name: Notification.Name(rawValue: trackerName), object: nil)
        */
        let image:UIImage = UIImage(named: "lucidHeader")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        self.navigationItem.titleView = imageView
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Lucid Text"
        self.tabBarItem.title = "Library"
        collectionView.backgroundColor = backgroundColor
       self.collectionView?.reloadData()

       NotificationCenter.default.addObserver(self.collectionView!,
                                              selector: #selector(UICollectionView.reloadData),
                                              name: UIContentSizeCategory.didChangeNotification,
                                              object: nil)

    }
   // @objc func loadSavedDataObjC(){
        //loadSavedData()
   // }
    @objc func deleteAll() {
        print("poooooo")
        
        let DelRequest = SavedWord.createDeleteRequest()
        do {
            
           
           try container.viewContext.execute(DelRequest)
            oldWords.removeAll()
            collectionView.reloadData()
            oldNames.removeAll()

            //tableView.reloadData()
           // getNames(wordsFromData: oldWords)
        } catch {
            print("Fetch failed")
        }
        
    }
    
    func loadSavedData() {
        let request = SavedWord.createFetchRequest()
       // print(request)
        let sort = NSSortDescriptor(key: "name", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            
            oldWords = try container.viewContext.fetch(request)
          //  try container.viewContext.execute(DelRequest)
            collectionView.reloadData()
            //tableView.reloadData()
           // getNames(wordsFromData: oldWords)
        } catch {
            print("Fetch failed")
        }
    }
    func getNames(wordsFromData: [SavedWord]) {
       oldNames.removeAll()
       for word in wordsFromData {
        oldNames.insert(word.name ?? "not word")
        print("In Library:\(word.name)")
       }
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
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return oldWords.count
    }
    

    //override func viewDidLayoutSubviews() {
    //    super.viewDidLayoutSubviews()
   //    self.collectionView.collectionViewLayout.invalidateLayout()
        //collectionViewLayout.invalidateLayout()
       // myCollection.collectionViewLayout.invalidateLayout()
  //  }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordCell", for: indexPath) as? WordCell else {
            // we failed to get a PersonCell – bail out!
            fatalError("Unable to dequeue WordCell.")
        }
        //get word and specify label
        let word = oldWords[indexPath.item].name
        cell.name.text = word
        cell.name.numberOfLines = 0
        cell.name.lineBreakMode = .byTruncatingTail
        cell.name.minimumScaleFactor = 0.5
        cell.name.sizeToFit()
        cell.name.textColor = cellTextColor
        let widthTest = cell.frame.width - 20
        let heightTest = cell.frame.height
        cell.name.frame = CGRect(x: 10, y: 0, width: widthTest-10, height: heightTest)

        cell.layer.cornerRadius = cornerRadiusVar
        cell.layer.borderWidth = cellBorderWidth
        cell.layer.borderColor = cellBorderColor
        cell.layer.backgroundColor = cellBackgroundColor
        
        cell.chevRight.frame = CGRect(x: 10, y: 0, width: widthTest, height: heightTest)
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detailVC") as? DetailViewController {
            vc.navTitle = oldWords[indexPath.item].name ?? "no word"
            vc.definition = oldWords[indexPath.item].definition ?? "no definition"
            vc.synonym = oldWords[indexPath.item].synonyms ?? "no synonyms"
            vc.spTrans = oldWords[indexPath.item].spanish ?? "none"
            vc.hiTrans = oldWords[indexPath.item].hindi ?? "none"
            vc.arTrans = oldWords[indexPath.item].arabic ?? "none"
            vc.chTrans = oldWords[indexPath.item].mandarin ?? "none"
            vc.bnTrans = oldWords[indexPath.item].bengali ?? "none"
            vc.ptTrans = oldWords[indexPath.item].portuguese ?? "none"
           navigationController?.pushViewController(vc, animated: true)
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
            withReuseIdentifier: "libraryHeader",
            for: indexPath) as? LibraryHeaderView
          else {
            fatalError("Invalid view type")
        }
        headerView.label.text = "My Words"
        headerView.backgroundColor = backgroundColor
        return headerView
    
      default:
        // 4
        assert(false, "Invalid element type")
      }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 70.0)
        
    }


}

extension LibraryViewController : UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
  

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




