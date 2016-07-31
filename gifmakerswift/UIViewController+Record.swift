//
//  UIViewController+Record.swift
//  gifmakerswift
//
//  Created by Maciej Serwicki on 7/29/16.
//  Copyright © 2016 Maciej Serwicki. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import ImageIO


//MARK: - Constants
let frameCount = 16
let delayTime: Float = 0.2
let loopCount = 0 // 0 means infinity


//MARK: - UIViewController: UINavigationControllerDelegate
extension UIViewController: UINavigationControllerDelegate {
    
}

//MARK: - UIViewController: UIImagePickerControllerDelegate
extension UIViewController: UIImagePickerControllerDelegate {
    @IBAction func launchVideoCamera(sender: AnyObject) {
        let videoController = UIImagePickerController()
        videoController.sourceType = .Camera
        videoController.mediaTypes = [kUTTypeMovie as String]
        videoController.allowsEditing = false //Change to true later for editing.
        videoController.delegate = self
        self.presentViewController(videoController, animated: true, completion: nil)
    }
    
    //Allows Editing
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        if mediaType == kUTTypeMovie as String {
            let videoURL = info[UIImagePickerControllerMediaURL] as! NSURL
            dismissViewControllerAnimated(true, completion: nil)

            convertVideoToGIF(videoURL)
           // UISaveVideoAtPathToSavedPhotosAlbum(videoURL.path!, nil, nil, nil)
            //Get Start and End Points From Trimmed Video.
        }
    }
    
    public func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: - GIF Converting Methods
    
    func convertVideoToGIF(videoURL: NSURL) {
        let regift = Regift(sourceFileURL: videoURL, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
        let gifURL = regift.createGif()
        
         let gif = Gif(url: gifURL!, videoURL: videoURL, caption: nil)

        
        displayGifFromGif(gif)
    }
    
    
    func displayGifFromGif(displayGif: Gif) {

      //  let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard?.instantiateViewControllerWithIdentifier("GifEditorViewController") as! GifEditorViewController
        vc.gif = displayGif
        
       navigationController?.pushViewController(vc, animated: true)
    }

    
    //End of UIViewController: UIImagePickerControllerDelegate
}







