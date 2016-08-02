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
        
        
        
    }
    
    
    @IBAction func createAndShareBtnPressed(sender: UIButton) {
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gifImageView.image = gif?.gifImage
    }



}
