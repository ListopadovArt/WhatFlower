//
//  Manager.swift
//  WhatFlower
//
//  Created by Artem Listopadov on 2.06.22.
//

import UIKit
import CoreML
import Vision
import Alamofire
import SwiftyJSON


final class Manager {
    
    static let shared = Manager()
    private let wikipediaURl = "https://en.wikipedia.org/w/api.php"
    
    private init() { }
    
    internal func detect(image: CIImage) -> String {
        var result = ""
        
        guard let model = try? VNCoreMLModel(for: FlowerClassifier().model) else {
            fatalError("Loading CoreML Model Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results?.first as? VNClassificationObservation else {
                fatalError("Model failed to process image")
            }
            result = results.identifier.capitalized
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
        return result
    }
    
    internal func requestInformation(name: String,  complition: @escaping (String)->()){
        var description: String?
        let parameters : [String:String] = [
            "format" : "json",
            "action" : "query",
            "prop" : "extracts",
            "exintro" : "",
            "explaintext" : "",
            "titles" : name,
            "indexpageids" : "",
            "redirects" : "1",
        ]
        
        Alamofire.request(self.wikipediaURl, method: .get, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                let flowerJSON: JSON = JSON(response.result.value!)
                let pageID = flowerJSON["query"]["pageids"][0].stringValue
                description = flowerJSON["query"]["pages"][pageID]["extract"].stringValue
                complition(description ?? "Description not found")
            }
        }
    }
}
