//
//  SavedGifsVewController.swift
//  gifmakerswift
//
//  Created by Maciej Serwicki on 8/15/16.
//  Copyright © 2016 Maciej Serwicki. All rights reserved.
//

import UIKit

var savedGifs: [Gif] = [Gif]()

class SavedGifsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewOutlet.dataSource = self
        collectionViewOutlet.delegate = self
        
        
    }
    @IBOutlet weak var collectionViewOutlet: UICollectionView!

    @IBAction func presentVideoOptions(sender: UIButton) {
        presentVideoOptions()
    }
    
     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionViewOutlet.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! UICollectionViewCell
        
        cell.backgroundColor = UIColor.darkGrayColor()
        
        return cell
    }

     func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row.description)
    }
    
    
}
