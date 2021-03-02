//
//  ViewController.swift
//  SeeFood
//
//  Created by Michael Sonnino on 02/03/2021.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    let hotdogIdentefier = HotdogIdentefier()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
            
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert to CIImage")
            }
            
            if hotdogIdentefier.isHotdog(image: ciImage) {
                self.navigationItem.title = "Hotdog!"
            } else {
                self.navigationItem.title = "Not Hotdog!"
            }
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cameraPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil,
                               preferredStyle: .actionSheet)

        let actCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actCancel)

        let actPhoto = UIAlertAction(title: "Take Photo", style: .default) { (_) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        alert.addAction(actPhoto)

        let actLibrary = UIAlertAction(title: "Choose From Library", style: .default) { (_) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        alert.addAction(actLibrary)

        present(alert, animated: true, completion: nil)
    }
    
}
