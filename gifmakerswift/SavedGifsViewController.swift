//
//  SavedGifsVewController.swift
//  gifmakerswift
//
//  Created by Maciej Serwicki on 8/15/16.
//  Copyright © 2016 Maciej Serwicki. All rights reserved.
//

import UIKit

//#define GIFURL [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"savedGifs"]


var savedGifs: [Gif] = [Gif]()
let cellMargin: CGFloat = 12.0

class SavedGifsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PreviewViewControllerProtocol {

    
    let GIFURL = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true))[0].stringByAppendingString("savedGifs")
    
    var gifsFilePath: String {
        let directories = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsPath = directories[0]
        let gifsPath = documentsPath.stringByAppendingString("/savedGifs")
        return gifsPath
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        unarchiveGifs()
        
        collectionViewOutlet.dataSource = self
        collectionViewOutlet.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if savedGifs.count >= 1 {
            emptyViewGraphicStack.hidden = true
        }
        
        NSKeyedArchiver.archiveRootObject(savedGifs, toFile: gifsFilePath)
        collectionViewOutlet.reloadData()
    }
    
    @IBOutlet weak var emptyViewGraphicStack: UIStackView!
    @IBOutlet weak var collectionViewOutlet: UICollectionView!

    @IBAction func presentVideoOptions(sender: UIButton) {
        presentVideoOptions()
    }
    
    
     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedGifs.count
    }
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionViewOutlet.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! GifCell
        let gifAtIndex = savedGifs[indexPath.row]
        cell.configureForGif(gifAtIndex)
        cell.backgroundColor = UIColor.darkGrayColor()
        return cell
    }

     func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row.description)
        
        let selectedGif = savedGifs[indexPath.row]
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        vc.gif = selectedGif
        
        navigationController?.pushViewController(vc, animated: true)
        
        
        
//        let vc = storyboard?.instantiateViewControllerWithIdentifier("GifEditorViewController") as! GifEditorViewController
//        vc.gif = displayGif
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (collectionView.frame.width - (cellMargin * 2))/2
        return CGSizeMake(width, width)
        }
    
    let gif = savedGifs.last
    
    //Archive///
    func previewVC(preview: PreviewViewController, didSaveGif gif: Gif) {
        savedGifs.append(gif)
        NSKeyedArchiver.archiveRootObject(savedGifs, toFile: gifsFilePath)
        //NSObject... File path...
    }
    
    
    //Unarchive
    func unarchiveGifs() {
        if let gifsUnarchived = NSKeyedUnarchiver.unarchiveObjectWithFile(gifsFilePath) as? [Gif] {
        savedGifs = gifsUnarchived
        }
        
    }
    
    
    }
    

