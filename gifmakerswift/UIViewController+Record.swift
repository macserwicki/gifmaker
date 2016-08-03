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





//MARK: - UIViewController: UINavigationControllerDelegate
extension UIViewController: UINavigationControllerDelegate {
    
}

//MARK: - UIViewController: UIImagePickerControllerDelegate
extension UIViewController: UIImagePickerControllerDelegate {
    @IBAction func launchVideoCamera(sender: AnyObject) {
       self.launchVideoCamera()
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

    func launchPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.mediaTypes = [kUTTypeMovie as String]
        imagePicker.allowsEditing = false //Change to true later for editing.
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func launchVideoCamera() {
        let videoController = UIImagePickerController()
        videoController.sourceType = .Camera
        videoController.mediaTypes = [kUTTypeMovie as String]
        videoController.allowsEditing = false //Change to true later for editing.
        videoController.delegate = self
        self.presentViewController(videoController, animated: true, completion: nil)    }
    
    
    @IBAction func presentVideoOptions() {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            self.launchPhotoLibrary()
        } else {
            //camera or library alert view
            let alert = UIAlertController(title: "Create New Gif", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
            let recordVideo = UIAlertAction(title: "Shoot Video", style: UIAlertActionStyle.Default, handler: { action in
             self.launchVideoCamera()
            })
            let pickVideo = UIAlertAction(title: "Choose from Album", style: UIAlertActionStyle.Default, handler: { action in
            self.launchPhotoLibrary()
            })
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(recordVideo)
            alert.addAction(pickVideo)
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    //End of UIViewController: UIImagePickerControllerDelegate
}







