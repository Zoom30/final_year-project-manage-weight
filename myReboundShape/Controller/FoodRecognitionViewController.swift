//
//  FoodRecognitionViewController.swift
//  myReboundShape
//
//  Created by Daniel Ghebrat on 12/05/2021.
//

import Foundation
import UIKit
import CoreML
import Vision
import FirebaseStorage

class FoodRecognitionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var foodImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    
  //  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        
        guard let image = info[.editedImage] as? UIImage else { print("Failed obtaining image"); return }
        guard let ciImage = CIImage(image: image) else { print("Error converting to ciImage"); return }
        analyseImage(selectedImage: ciImage)
//        guard let imageData = image.pngData() else { return }
//        let imageName = UUID().uuidString
//        let storage = Storage.storage().reference().child("Images Folder").child("\(imageName).png")
//        storage.putData(imageData, metadata: nil) { metadata, error in
//            guard error == nil else { print("failed uploading"); return }
//        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func analyseImage (selectedImage : CIImage){
        
        guard let model = try? VNCoreMLModel(for: Food101().model) else {
            print("error detected")
            return
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation] else { print("error getting results"); return }
            guard let firstIdentifier = results.first?.identifier else { return }
            guard let confidence = results.first?.confidence.binade else { return }
            print("Food is \(firstIdentifier) with confidence \(confidence)")
        }
        
        let handler = VNImageRequestHandler(ciImage: selectedImage)
        do {
            try handler.perform([request])
        } catch  {
            fatalError()
        }
        
    }
    
    
    @IBAction func cameraTapped(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    
    
    func saveImageInCoreData(imageData : Data){
        
    }
    
}
