//
//  ViewController.swift
//  test
//
//  Created by Mohamed Musa on 2/18/23.
//

import UIKit
import RealityKit
import Vision
class ViewController: UIViewController {
    var captured_image: UIImage = UIImage()
    @IBOutlet var arView: ARView!
    @IBOutlet weak var capture_button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
        //create button
        
    }
    @IBAction func capture_image(_ sender: Any) {
        arView.snapshot(saveToHDR: false) { im in
            self.captured_image = UIImage(data: (im?.pngData())!)!
        }
        parse_image_to_text()
    }
    func processResults(str: [String]) {
        print(str)
    }
    func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            return
        }
        let recognizedStrings = observations.compactMap { observation in
            // Return the string of the top VNRecognizedText instance.
            return observation.topCandidates(1).first?.string
        }
        
        // Process the recognized strings.
        processResults(str: recognizedStrings)
    }
    func parse_image_to_text(){
        guard let cgImage = self.captured_image.cgImage else { return }

        // Create a new image-request handler.
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)

        // Create a new request to recognize text.
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)

        do {
            // Perform the text-recognition request.
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
    }
    
    
}



  

