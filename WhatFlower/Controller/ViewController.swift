//
//  ViewController.swift
//  WhatFlower
//
//  Created by Artem Listopadov on 2.06.22.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var flowerImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    // MARK: - Private Properties
    private let imagePicker = UIImagePickerController()
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        setGradientBackground()
    }
    
    
    //MARK: - ImagePicker Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            flowerImageView.image = userPickedImage
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert to CIImage")
            }
            let flowerName = Manager.shared.detect(image: ciImage)
            self.navigationItem.title = flowerName
            
            Manager.shared.requestInformation(name: flowerName) { (description, url) in
                self.descriptionLabel.text = description
                self.flowerImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.flowerImageView.sd_setImage(with: URL(string: url),
                                                 placeholderImage: UIImage(named: "no-image"))
            }
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: -  Method of implement Gradient Background
    func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemGreen.cgColor, UIColor.systemTeal.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0,1]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
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
