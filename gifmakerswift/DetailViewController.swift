//
//  DetailViewController.swift
//  gifmakerswift
//
//  Created by Maciej Serwicki on 8/16/16.
//  Copyright © 2016 Maciej Serwicki. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailImageViewOutlet: UIImageView!
    
    var gif: Gif? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = gif?.gifImage {
            self.detailImageViewOutlet.image = image
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeDetail(sender: UIButton) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func shareButtonPressed(sender: UIButton) {
        

        
        
            //Data is nil
            var itemsToShare = [NSData]()
            itemsToShare.append((self.gif?.gifData)!)
            
            let shareController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
            shareController.completionWithItemsHandler = { activityType, completed, items, error in
                if (completed) {
                   self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
            self.presentViewController(shareController, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
