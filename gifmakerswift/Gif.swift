//
//  Gif.swift
//  gifmakerswift
//
//  Created by Maciej Serwicki on 7/30/16.
//  Copyright © 2016 Maciej Serwicki. All rights reserved.
//

import UIKit

class Gif: NSObject, NSCoding {

    var url: NSURL? = nil
    var videoURL: NSURL? = nil
    var caption: NSString? = nil
    var gifImage: UIImage? = nil
    var gifData: NSData? = nil
    
    init (url: NSURL, videoURL: NSURL, caption: String?) {
        self.caption = caption
        self.videoURL = videoURL
        self.url = url
        self.gifData = NSData(contentsOfURL: url)
        self.gifImage = UIImage.gifWithURL(url.absoluteString)
    }
    
    init(name: String) {
        self.gifImage = UIImage.gifWithName(name)
    }
    
    init(data: NSData) {
        self.gifImage = UIImage.gifWithData(data)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        self.url = aDecoder.decodeObjectForKey("url") as? NSURL
        self.caption = aDecoder.decodeObjectForKey("caption") as! String
        self.videoURL = aDecoder.decodeObjectForKey("videoURL") as? NSURL
        self.gifImage = aDecoder.decodeObjectForKey("gifImage") as? UIImage
        self.gifData = aDecoder.decodeObjectForKey("gifData") as? NSData

    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.url, forKey: "url")
        aCoder.encodeObject(self.caption, forKey: "caption")
        aCoder.encodeObject(self.videoURL, forKey: "videoURL")
        aCoder.encodeObject(self.gifImage, forKey: "gifImage")
    }
    
}
