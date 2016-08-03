//
//  PreviewViewController.swift
//  gifmakerswift
//
//  Created by Maciej Serwicki on 7/27/16.
//  Copyright © 2016 Maciej Serwicki. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    var gif: Gif? = nil
    
    @IBOutlet weak var gifImageView: UIImageView!
    //displays the gif with the added caption and provides the option to share it.
    
    @IBAction func shareBtnPressed(sender: UIButton) {
        
        if let url: NSURL = (self.gif?.url!) {

        let data: NSData = NSData(contentsOfURL: url)!
        let itemsToShare = [data]
        let shareController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
            shareController.completionWithItemsHandler = { activityType, completed, items, error in
                if (completed) {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
            }
            self.presentViewController(shareController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func createAndShareBtnPressed(sender: UIButton) {
        
        // Copy GIF data from temporary URL
        let url = self.gif?.url
        self.gif?.gifData = NSData.init(contentsOfURL: url!)
        
        // Save updated Gif object to Gif array model
      //  let appDelegate = UIApplication.sharedApplication().delegate
      //  appDelegate.gifs.append(self.gif)
        
        
        /*
         // Copy GIF data from temporary URL
         self.gif.gifData = [NSData dataWithContentsOfURL:self.gif.url];
         
         // Save updated Gif object to Gif array model
         AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
         [appDelegate.gifs addObject:self.gif];
         
         [self.navigationController popToRootViewControllerAnimated:YES];

 
    */
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gifImageView.image = gif?.gifImage
    }



}
