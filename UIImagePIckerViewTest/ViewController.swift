//
//  ViewController.swift
//  UIImagePIckerViewTest
//
//  Created by Robin Allemand on 11/25/17.
//  Copyright © 2017 Robin Allemand. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, myPhotoFileFolderDelegate {
    
    func didClose(controller: myPhotoFileFolder) {
        self.dismiss(animated: true, completion: nil)
        print("\("Will is awesome")")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "openFileFolderTable" {
            let navigationController: UINavigationController = segue.destination as! UINavigationController
            let FileFolderTVController: myPhotoFileFolder = navigationController.viewControllers[0] as! myPhotoFileFolder
            FileFolderTVController.delegate = self
        }
    }

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.delegate = self
//
//        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a Source", preferredStyle: .actionSheet)
//
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
//                imagePickerController.sourceType = .camera
//                imagePickerController.allowsEditing = false
//                self.present(imagePickerController, animated: true, completion: nil)
//            }))
//        }
//        else{
//            print("Camera not available")
//        }
//
//        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
//            imagePickerController.sourceType = .photoLibrary
//            imagePickerController.allowsEditing = false
//            self.present(imagePickerController, animated: true, completion: nil)
//        }))
//
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//        self.present(actionSheet, animated: true, completion: nil)
//
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//
//        imageView.image = image
//
//
//
//        let imageURL = info[UIImagePickerControllerMediaURL]
//        //get the array
//        let usD = UserDefaults()
//        let array: NSMutableArray = usD.value(forKey: "weatherArray") as! NSMutableArray
//        array.add(imageURL as Any)
//
//        //add the new photo link to the array
//
//        //set the array to the 'new array' in nsuserdefaults
//
//        //save
//        usD.setValuesForKeys(["weatherArray": array])
//        usD.synchronize()
//
//        //set any of the images to an imageview
//
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
    }


}

