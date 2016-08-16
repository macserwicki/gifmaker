//
//  GifEditorViewController.swift
//  gifmakerswift
//
//  Created by Maciej Serwicki on 7/27/16.
//  Copyright © 2016 Maciej Serwicki. All rights reserved.
//

import UIKit

class GifEditorViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    
    var gif: Gif? = nil
    
    //presents the newly created gif and enables the user to add a caption.
    
    @IBAction func backgroundTapped(sender: UITapGestureRecognizer) {
        dismissKeyboard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captionTextField.delegate = self
        subscribeToKeyboardNotifications()
        self.title = "Editor"
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.placeholder = nil
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let gifImg = gif?.gifImage {
            gifImageView.image = gifImg
        }
    }
    
    
    //MARK: - Keyboard Observe Notif and Respond
    
    func subscribeToKeyboardNotifications() -> Void {
        print("Subscribed to keyboard notifications.")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GifEditorViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GifEditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        
    }
    
    func unsubscribeFromKeyboardNotifications() -> Void {
        print("Unsubscribed from keyboard notifications.")
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) -> Void {
        print("Keyboard will show")
        if (self.view.frame.origin.y >= 0) {
            if var rect: CGRect = self.view.frame {
                print("Keyboard - \(rect.origin.y)")
                rect.origin.y -= self.getKeyboardHeight(notification)!
                self.view.frame = rect
                print("Keyboard - \(rect.origin.y)")

            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) -> Void {
        print("Keyboard will show")
        if (self.view.frame.origin.y < 0) {
            if var rect: CGRect = self.view.frame {
                print("Keyboard - \(rect.origin.y)")
                rect.origin.y += self.getKeyboardHeight(notification)!
                self.view.frame = rect
                print("Keyboard - \(rect.origin.y)")
            }
        }
    }
    
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat? {
        
        if let userInfo = notification.userInfo {
            if let keyboardFrameEnd = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardFrameEndRect = keyboardFrameEnd.CGRectValue()
                return keyboardFrameEndRect.height
            }
        }
        return nil
    }
    
    func dismissKeyboard() -> Void {
        view.endEditing(true)
    }

    @IBAction func nextBtnGifPreview(sender: AnyObject) {
        presentGifPreview()
    }

    
    
    func presentGifPreview() -> Void {
        let previewViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PreviewViewController") as! PreviewViewController
        if self.gif?.caption != nil {
            self.gif?.caption = self.captionTextField.text
        }
        
        if let source = self.gif?.videoURL {
        let regift: Regift = Regift(sourceFileURL: source, destinationFileURL: nil, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
            let captionFont: UIFont = self.captionTextField.font!
            let gifURL: NSURL = regift.createGif(caption: self.captionTextField.text, font: captionFont)!
            let newGif: Gif = Gif(url: gifURL, videoURL: self.gif!.videoURL!, caption: self.captionTextField.text)


            previewViewController.gif = newGif
            self.navigationController?.pushViewController(previewViewController, animated: true)
        }
    }
    
  
    
    
}


