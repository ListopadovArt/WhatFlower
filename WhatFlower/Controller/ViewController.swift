//
//  ViewController.swift
//  WhatFlower
//
//  Created by Artem Listopadov on 2.06.22.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var flowerImageView: UIImageView!
    
    
    // MARK: - Private Properties
    private let imagePicker = UIImagePickerController()
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    
    //MARK: - ImagePicker Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            flowerImageView.image = userPickedImage
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert to CIImage")
            }
            self.navigationItem.title = Manager.shared.detect(image: ciImage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - IBActions
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func photoLibraryButtonPressed(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}

