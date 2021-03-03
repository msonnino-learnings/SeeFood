//
//  hotdogIdentifier.swift
//  SeeFood
//
//  Created by Michael Sonnino on 02/03/2021.
//

import UIKit
import CoreML
import Vision

struct HotdogIdentifier {
    
    func isHotdog(image: CIImage) -> Bool {
        
        var isHotdog = false
        
        guard let model = try? VNCoreMLModel(for: MLModel(contentsOf: Inceptionv3.urlOfModelInThisBundle)) else {
            fatalError("Can't load ML model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let result = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to proccess image")
            }
            
            if let firstResult = result.first {
                if firstResult.identifier.contains("hotdog") {
                    isHotdog = true
                } else {
                    isHotdog = false
                }
            }
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
        
        return isHotdog
        
    }
    
}
