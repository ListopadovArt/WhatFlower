//
//  Manager.swift
//  WhatFlower
//
//  Created by Artem Listopadov on 2.06.22.
//

import UIKit
import CoreML
import Vision

final class Manager {
    
    static let shared = Manager()
    private var result: String?
    
    private init() { }
    
    internal func detect(image: CIImage) -> String {
        guard let model = try? VNCoreMLModel(for: FlowerClassifier().model) else {
            fatalError("Loading CoreML Model Failed")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
            if let firstResult = results.first {
                self.result = firstResult.identifier.capitalized
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
        return result ?? ""
    }
}
