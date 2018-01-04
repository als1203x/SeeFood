//
//  ViewController.swift
//  SeeFood
//
//  Created by LinuxPlus on 1/3/18.
//  Copyright © 2018 ARC. All rights reserved.
//

import UIKit
import CoreML
//helps process images easier
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var displayImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        imagePicker.delegate = self
            //Allows user to take picture
        imagePicker.sourceType = .camera // .photoLibrary   -- allows for the use of the library
        imagePicker.allowsEditing = false
        
    }
    
    //MARK: - UIImagPicker Delegate Method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            // selected image
        if let userPickedImage = info[UIImagePickerControllerOriginalImage]as? UIImage  {
            displayImageView.image = userPickedImage
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
}

