
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
            var transform = box_anchor.transform
            transform.scale *= 0.3
            box_anchor.move(to: transform, relativeTo: box_anchor.parent)
            box_anchor.move(to: transform, relativeTo: box_anchor.parent, duration: 0.3)
            arView.scene.addAnchor(box_anchor)
        }
    
        // BOB
        func create_bob() -> ModelEntity {
            let url = URL(fileURLWithPath: "path/to/MyEntity.usdz")
            let appleEntity = try? ModelEntity.loadModel(named: "bobidle")
            var transform = appleEntity!.transform
            transform.scale *= 0.05
            appleEntity!.move(to: transform, relativeTo: appleEntity?.parent)
            appleEntity!.move(to: transform, relativeTo: appleEntity?.parent, duration: 0.3)
            return appleEntity!
        }
        func create_sally() -> ModelEntity {
            let url = URL(fileURLWithPath: "path/to/MyEntity.usdz")
            let appleEntity = try? ModelEntity.loadModel(named: "sallywins")
            var transform = appleEntity!.transform
            transform.scale *= 0.08
            appleEntity!.move(to: transform, relativeTo: appleEntity?.parent)
            appleEntity!.move(to: transform, relativeTo: appleEntity?.parent, duration: 0.3)
            return appleEntity!
        }
        func place_person(box: ModelEntity, at position: SIMD3<Float>){
            let horizontal_anchor = AnchorEntity(world: position)
            horizontal_anchor.addChild(box)
            arView.scene.addAnchor(horizontal_anchor)
        }
        // Platform
        func create_platform() -> ModelEntity {
            let url = URL(fileURLWithPath: "path/to/MyEntity.usdz")
            let appleEntity = try? ModelEntity.loadModel(named: "hut")
            var transform = appleEntity!.transform
            transform.scale *= 0.05
            appleEntity!.move(to: transform, relativeTo: appleEntity?.parent)
            appleEntity!.move(to: transform, relativeTo: appleEntity?.parent, duration: 0.3)
            return appleEntity!
        }
        func place_platform(box: ModelEntity){
            let horizontal_anchor = AnchorEntity(plane: .horizontal)
            horizontal_anchor.addChild(box)
            arView.scene.addAnchor(horizontal_anchor)
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
//        for s in str{
//            if s.contains("apple") {
//                let platform = create_platform()
//                place_platform(box: platform)
//                let bob = create_bob()
//                place_person(box: bob, at: SIMD3(x: 0, y: 0, z: 0))
//
////                let sally = create_sally()
////                place_person(box: sally, at: SIMD3(x: 0, y: 0, z: 0))
////
//                let anim = bob.availableAnimations[0]
//                bob.playAnimation(anim.repeat(duration: .infinity), transitionDuration: 1.25)
//                for i in 0..<3 {
//                    let box = create_box()
//                    let xspot = Float(0.05 * Double(i)) + platform.position.x
//                    place_box(box: box, at: SIMD3(x: xspot, y: platform.position.y, z: platform.position.z))
//                    install_gestures(on: box)
//                }
////                for i in 0..<3 {
////                    let box = create_box()
////                    let xspot = Float(-1) * (Float(0.05 * Double(i)) + platform.position.x) + 1
////                    place_box(box: box, at: SIMD3(x: xspot, y: platform.position.y, z: platform.position.z))
////                    install_gestures(on: box)
////                }
//                break
//            }
//
//        }
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


