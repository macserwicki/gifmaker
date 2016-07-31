//
//  GifEditorViewController.swift
//  gifmakerswift
//
//  Created by Maciej Serwicki on 7/27/16.
//  Copyright © 2016 Maciej Serwicki. All rights reserved.
//

import UIKit

class GifEditorViewController: UIViewController {

    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    
    var gif: Gif? = nil
    
    //presents the newly created gif and enables the user to add a caption.
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let gifImg = gif?.gifImage {
            gifImageView.image = gifImg
        }
        
        
        //if let gifURL = gif?.url {
        //     let gifFromRecording = UIImage.gifWithURL(gifURL.absoluteString)
        //gifImageView.image = gifFromRecording
        
        }
        
    }


