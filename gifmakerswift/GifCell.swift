//
//  GifCell.swift
//  gifmakerswift
//
//  Created by Maciej Serwicki on 8/15/16.
//  Copyright © 2016 Maciej Serwicki. All rights reserved.
//

import UIKit

class GifCell: UICollectionViewCell {

    @IBOutlet weak var gifImageView: UIImageView!
    
    func configureForGif(gif: Gif) {
        self.gifImageView.image = gif.gifImage
    }
    
}
