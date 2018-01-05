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
//import SVProgressHUD

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
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
        cameraButton.isEnabled = false
        //SVProgressHUD.show()
            // selected image
        if let userPickedImage = info[UIImagePickerControllerOriginalImage]as? UIImage  {
            displayImageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else {  fatalError("Could not convert to CIImage")}
            
            detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
        // Use the InceptionV3
        // Vision -- allows to perform image analsyt
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model)  else{
            fatalError("Loading CoreML Model Failed")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation]   else    {
                fatalError("Model failed to process image")
            }
            DispatchQueue.main.async {
                self.cameraButton.isEnabled = true
            //    SVProgressHUD.dismiss()
            }
            
            if let firstResult = results.first  {
                if firstResult.identifier.contains("hotdog")    {
                    DispatchQueue.main.async {
                        if let navBar = self.navigationController?.navigationBar {
                            let navBarColor = UIColor.green
                            //color of navigation UI
                            navBar.barTintColor = navBarColor
                            //color of all navigation items & barButtons
                        }
                    }
                        self.navigationItem.title = "Hotdog!"
                }else  {
                    DispatchQueue.main.async {
                        if let navBar = self.navigationController?.navigationBar {
                            let navBarColor = UIColor.red
                            //color of navigation UI
                            navBar.barTintColor = navBarColor
                        }
                        self.navigationItem.title = "Not Hotdog!"
                    }
                }
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do  {
            try handler.perform([request])
        }catch  {
            print(error)
        }
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
}

