//
//  CameraViewController.swift
//  AddressFinder
//
//  Created by Priscilla Jofani Oetomo on 10/19/17.
//  Copyright © 2017 grandevox. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MobileCoreServices

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var takePicture: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var avPlayerViewController: AVPlayerViewController!
    var image: UIImage?
    var movieURL: URL?
    var lastChosenMediaType: String?
    
    @IBAction func createMedia (_ sender: UIButton) {
        pickMediaFromSource(UIImagePickerControllerSourceType.camera)
    }
    
    @IBAction func accessLibrary (_ sender: UIButton) {
        pickMediaFromSource(UIImagePickerControllerSourceType.photoLibrary)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            takePicture.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        updateDisplay()
    }
    
    func pickMediaFromSource (_ sourceType: UIImagePickerControllerSourceType) {
        // What media types are available on the device
        let mediaTypes = UIImagePickerController.availableMediaTypes(for: sourceType)!
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) && mediaTypes.count > 0 {
            let picker = UIImagePickerController()
            
            // Display the media types available on the picker
            picker.mediaTypes = mediaTypes
            
            // Set delegate to self for system method calls
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = sourceType
            
            // Present the picker to the user
            present(picker, animated: true, completion: nil)
        }
        
        // Otherwise display an error message
        
        else {
            let alertController = UIAlertController(title: "Error accessing media", message: "Unsupported media source.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController (_ picker:UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        lastChosenMediaType = info[UIImagePickerControllerMediaType] as? String
        
        // Set the variable to the data retrieved
        if let mediaType = lastChosenMediaType {
            if mediaType == (kUTTypeImage as NSString) as String {
                image = info[UIImagePickerControllerEditedImage] as? UIImage
            } else if mediaType == (kUTTypeMovie as NSString) as String {
                movieURL = info[UIImagePickerControllerMediaURL] as? URL
            }
        }
        // Dismiss the picker to return to the apps view
        picker.dismiss(animated: true, completion: nil)
    }
    
    func updateDisplay() {
        // Optional, so if let used to unwrap
        if let mediaType = lastChosenMediaType {
            // If the media chosen is an image, then get the image and display it
            if mediaType == (kUTTypeImage as NSString) as String {
                imageView.image = image!
                imageView.isHidden = false
                
                if avPlayerViewController != nil {
                   avPlayerViewController!.view.isHidden = true
                }
                
                //Otherwise the media chosen is a video
            } else if mediaType == (kUTTypeMovie as NSString) as String {
                if avPlayerViewController == nil {
                    // Instantiate a view for displaying the video
                    avPlayerViewController = AVPlayerViewController()
                    let avPlayerView = avPlayerViewController!.view
                    avPlayerView?.frame = imageView.frame
                    avPlayerView?.clipsToBounds = true
                    view.addSubview(avPlayerView!)
                }
                
                if let url = movieURL {
                    imageView.isHidden = true
                    avPlayerViewController.player = AVPlayer(url: url)
                    avPlayerViewController!.view.isHidden = false
                    avPlayerViewController!.player!.play()
                }
            }
        }
    }
}
