//
//  ViewController.swift
//  test
//
//  Created by Mohamed Musa on 2/18/23.
//

import UIKit
import RealityKit
import Vision
import AVFoundation
class ViewController: UIViewController {
    
    var captured_image: UIImage = UIImage()
    @IBOutlet var arView: ARView!
    @IBOutlet weak var capture_button: UIButton!
    func setupArView() {
        let frameRect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let cameraMode = ARView.CameraMode.nonAR
        arView = ARView(frame: frameRect, cameraMode: cameraMode, automaticallyConfigureSession: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //Load the "Box" scene from the "Experience" Reality File
        //let boxAnchor = try! Experience.loadBox()
        
        //Add the box anchor to the scene
       // arView.scene.anchors.append(boxAnchor)
        //create button
    }
        func create_box() -> ModelEntity {
            let url = URL(fileURLWithPath: "path/to/MyEntity.usdz")
            let appleEntity = try? ModelEntity.loadModel(named: "Red_Apple_Emoji")
            return appleEntity!
        }
        func place_box(box: ModelEntity, at position: SIMD3<Float>){
            let box_anchor = AnchorEntity(world: position)
            box_anchor.addChild(box)
            arView.scene.addAnchor(box_anchor)
        }
    func install_gestures(on object: ModelEntity){
        object.generateCollisionShapes(recursive: true)
        arView.installGestures(for: object)
    }
    @IBAction func capture_image(_ sender: Any) {
        arView.snapshot(saveToHDR: false) { im in
            self.captured_image = UIImage(data: (im?.pngData())!)!
        }
        parse_image_to_text()
    }
    func processResults(str: [String]) {
        //var joined = str.joined(separator: ",")
        if str.contains("Apple") {
            print(str)
            for s in str {
                for char in s {
                    if char.isNumber {
                        print("penis")
                        for i in 0..<Int(String(char))! {
                            let box = create_box()
                            place_box(box: box, at: SIMD3(x: 0.5*(Float(i)), y: 0.5*(Float(i)), z: 0))
                            install_gestures(on: box)
                        }
                        return
                    }
                }
            }

        }
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


