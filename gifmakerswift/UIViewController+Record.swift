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
import AVFoundation




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
            //dismissViewControllerAnimated(true, completion: nil)
            
            let start: Float? = info["_UIImagePickerControllerVideoEditingStart"] as? Float
            let end: Float? = info["_UIImagePickerControllerVideoEditingEnd"] as? Float
            var duration: NSNumber?
            if let start = start {
                duration = NSNumber(float: (end!) - (start))
            } else {
                //don't trim
                duration = nil
            }
            
            convertVideoToGIF(videoURL, startTime: start, duration: duration?.floatValue)
           // UISaveVideoAtPathToSavedPhotosAlbum(videoURL.path!, nil, nil, nil)
            //Get Start and End Points From Trimmed Video.
        }
    }
    
    public func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: - GIF Converting Methods
    
    func convertVideoToGIF(videoURL: NSURL, startTime: Float?, duration: Float?) {
        
                dispatch_async(dispatch_get_main_queue()) {
                
        
        let regift: Regift
        
        if let start = startTime {
            //Trimmed Video
             regift = Regift(sourceFileURL: videoURL, destinationFileURL: nil, startTime: start, duration: duration!, frameRate: Int(duration!)*3, loopCount: loopCount)
            
            
        } else {

            
        
            
            //Untrimmed Video
            regift = Regift(sourceFileURL: videoURL, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
        }
        
        let gifURL = regift.createGif()
        let gif = Gif(url: gifURL!, videoURL: videoURL, caption: nil)
        self.displayGifFromGif(gif)
        self.dismissViewControllerAnimated(true, completion: nil)

        }
      
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
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func launchVideoCamera() {
        let videoController = UIImagePickerController()
        videoController.sourceType = .Camera
        videoController.mediaTypes = [kUTTypeMovie as String]
        videoController.allowsEditing = true
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
    
    
    
    
    func cropVideoToSquare(rawVideoURL: NSURL, start: NSNumber, duration: NSNumber) -> Void {
        //AVAsset and AVAssetTrack Initialized
        let videoAsset = AVAsset(URL: rawVideoURL)
        let videoTrack = videoAsset.tracksWithMediaType(AVMediaTypeVideo)[0]
        
        //Cropping To Square
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height, videoTrack.naturalSize.height)
        videoComposition.frameDuration = CMTimeMake(1, 30)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30))
        
        //Rotate To Portrait
        let transformer = AVMutableVideoCompositionLayerInstruction.init(assetTrack: videoTrack)
        
        let t1 = CGAffineTransformMakeTranslation(videoTrack.naturalSize.height, -(videoTrack.naturalSize.width - videoTrack.naturalSize.height) / 2)
        let t2 = CGAffineTransformRotate(t1, CGFloat(M_PI_2))
        
        let finalTransform: CGAffineTransform = t2
        
        transformer.setTransform(finalTransform, atTime: kCMTimeZero)
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]
        
        //Export
        let exporter = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetHighestQuality)
        exporter?.videoComposition = videoComposition
        
        var path = ""
        
        do {
            try
           path = self.createPath()
        } catch {
            print("Error creatingPath - createPath()") }
        
        
        exporter?.outputURL = NSURL.fileURLWithPath(path)
        exporter?.outputFileType = AVFileTypeQuickTimeMovie
        
        var croppedURL: NSURL? = nil
        exporter?.exportAsynchronouslyWithCompletionHandler({ 
            croppedURL = exporter?.outputURL
            self.convertVideoToGIF(croppedURL!, startTime: Float(start), duration: Float(duration))
        })
        
        
    }
    
    func createPath() throws -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory = paths[0]
        let manager = NSFileManager.defaultManager()
        var outputURL = documentsDirectory.stringByAppendingString("output")
        do { try manager.createDirectoryAtPath(outputURL, withIntermediateDirectories: true, attributes: nil) } catch {
            print("Error occurd when trying to createDirectoryAtPath - createPath()")
        }
        
        //might fail here
        outputURL = outputURL.stringByReplacingOccurrencesOfString("output", withString: "output.mov")
        
        //Remove Existing File
        try manager.removeItemAtPath(outputURL)
        
        return outputURL
    }
    

    
//    CGAffineTransform t1 = CGAffineTransformMakeTranslation(videoTrack.naturalSize.height, -(videoTrack.naturalSize.width - videoTrack.naturalSize.height) /2 );
//    CGAffineTransform t2 = CGAffineTransformRotate(t1, M_PI_2);
//
//    CGAffineTransform finalTransform = t2;
//    [transformer setTransform:finalTransform atTime:kCMTimeZero];
//    instruction.layerInstructions = [NSArray arrayWithObject:transformer];
//    videoComposition.instructions = [NSArray arrayWithObject: instruction];
//    
//    // export
//    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:videoAsset presetName:AVAssetExportPresetHighestQuality] ;
//    exporter.videoComposition = videoComposition;
//    NSString *path = [self createPath];
    
    
//    exporter.outputURL = [NSURL fileURLWithPath:path];
//    exporter.outputFileType = AVFileTypeQuickTimeMovie;
//    
//    __block NSURL *croppedURL;
//    
//    [exporter exportAsynchronouslyWithCompletionHandler:^(void){
//    croppedURL = exporter.outputURL;
//    [self convertVideoToGif:croppedURL start:start duration:duration];
//    }];
//    }
    
    
    
    
    //DONE
    //    -(void)cropVideoToSquare:(NSURL*)rawVideoURL start:(NSNumber*)start duration:(NSNumber*)duration {
    //    //Create the AVAsset and AVAssetTrack
    //    AVAsset *videoAsset = [AVAsset assetWithURL:rawVideoURL];
    //    AVAssetTrack *videoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    //
    //    // Crop to square
    //    AVMutableVideoComposition* videoComposition = [AVMutableVideoComposition videoComposition];
    //    videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height, videoTrack.naturalSize.height);
    //    videoComposition.frameDuration = CMTimeMake(1, 30);
    //
    //    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    //    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30) );
    //
    //    // rotate to portrait
    //    AVMutableVideoCompositionLayerInstruction* transformer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    //DONE
    
    //
    //    - (NSString*)createPath {
    //
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *documentsDirectory = [paths objectAtIndex:0];
    //    NSFileManager *manager = [NSFileManager defaultManager];
    //    NSString *outputURL = [documentsDirectory stringByAppendingPathComponent:@"output"] ;
    //    [manager createDirectoryAtPath:outputURL withIntermediateDirectories:YES attributes:nil error:nil];
    //    outputURL = [outputURL stringByAppendingPathComponent:@"output.mov"];
    //
    //    // Remove Existing File
    //    [manager removeItemAtPath:outputURL error:nil];
    //
    //    return outputURL;
    //    }
    
    
    
    //End of UIViewController: UIImagePickerControllerDelegate
}







