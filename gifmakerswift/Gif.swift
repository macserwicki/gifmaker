//
//  Gif.swift
//  gifmakerswift
//
//  Created by Maciej Serwicki on 7/30/16.
//  Copyright © 2016 Maciej Serwicki. All rights reserved.
//

import UIKit

class Gif: NSObject {

    var url: NSURL? = nil
    var videoURL: NSURL? = nil
    var caption: NSString? = nil
    var gifImage: UIImage? = nil
    var gifData: NSData? = nil
    
    init (url: NSURL, videoURL: NSURL, caption: String?) {
        self.caption = caption
        self.videoURL = videoURL
        self.url = url
        self.gifData = nil
        self.gifImage = UIImage.gifWithURL(url.absoluteString)
    }
    
    init(name: String) {
        self.gifImage = UIImage.gifWithName(name)
    }
    
    init(data: NSData) {
        self.gifImage = UIImage.gifWithData(data)
    }
    
    
}
