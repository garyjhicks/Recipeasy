//
//  ViewController.swift
//  ObjectRecognition
//
//  Created by Gary Hicks on 2018-03-16.
//  Copyright © 2018 Gary Hicks. All rights reserved.
//

import UIKit
import AVKit
import Vision

var items = [String]()
var favs = [String]()

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var object: UILabel!
    @IBOutlet weak var probability: UILabel!
    
    @IBAction func save(_ sender: Any) {
        print("Hit")
        if let item = self.object.text {
            items.append(item)
            defaults.set(items, forKey: "SavedItems")
            print("Here")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let previous = defaults.stringArray(forKey: "SavedItems") {
            items = previous
        }
        
        self.hideKeyboard()
        
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        if let captureDevice = AVCaptureDevice.default(for: .video){
            do{
                let input = try AVCaptureDeviceInput(device: captureDevice)
                captureSession.addInput(input)
                captureSession.startRunning()
                let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer.frame = view.bounds
                view.layer.addSublayer(previewLayer)
                
                
                let dataOutput = AVCaptureVideoDataOutput()
                dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
                captureSession.addOutput(dataOutput)
                
            }catch{
                print("There was an error!")
            }
        }
        
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        if let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            
            do {
                
                let model = try VNCoreMLModel(for: Resnet50().model)
                
                let request = VNCoreMLRequest(model: model, completionHandler: { (finishedRequest, error) in
                    if error == nil{
                        
                        //print(finishedRequest.results)
                        
                        if let results = finishedRequest.results as? [VNClassificationObservation]{
                            if let first = results.first {
                                //print(first.identifier, first.confidence)
                                DispatchQueue.main.async {
                                    self.object.text = first.identifier
                                    self.probability.text = String(first.confidence)
                                }
                            }
                        }
                        
                    }
                    else{
                        print("Error was: \(String(describing: error))")
                    }
                })
                
                do {
                    try VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
                }catch{
                    print("There was an error!")
                }
                
            }catch{
                print("There was an error!")
            }
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}


