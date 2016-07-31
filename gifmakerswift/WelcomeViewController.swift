//
//  WelcomeViewController.swift
//  gifmakerswift
//
//  Created by Maciej Serwicki on 7/27/16.
//  Copyright © 2016 Maciej Serwicki. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    //welcomes the user and indicates where to start to create a gif.

    @IBOutlet weak var gifImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let testGif = UIImage.gifWithName("gif1")
        gifImageView.image = testGif
    }

}
