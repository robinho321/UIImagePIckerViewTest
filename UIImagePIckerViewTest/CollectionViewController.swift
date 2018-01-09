//
//  CollectionViewController.swift
//  UIImagePIckerViewTest
//
//  Created by Robin Allemand on 11/25/17.
//  Copyright © 2017 Robin Allemand. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import Photos
import MapKit
import CoreLocation
import AddressBookUI
import CoreData

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    @IBOutlet weak var collectionView: UICollectionView! { didSet {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkPhotoLibraryPermission()
        collectionView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.reloadData()
    }
    
//    func fetchDirectoryContents() {
//        let fileManager = FileManager.default
//        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
//        print("directory contents is \(directoryContents)")
//    }
    
    //number of views
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let fileManager = FileManager.default
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let dirContents = try? fileManager.contentsOfDirectory(atPath: documentsPath)
        let count = dirContents?.count
        return count!
            }
    
    //populate the views
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! myCell
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        
        for imageURL in directoryContents where imageURL.pathExtension == "jpeg" {
            if let image = UIImage(contentsOfFile: imageURL.path) {
                cell.myImageView.image = image //[indexPath.row] **need "image" to be an array so can assign to indexPath.row
            } else {
                fatalError("Can't create image from file \(imageURL)")
            }
        }
        return cell
    }
    
    
    @IBAction func addMyImage(_ sender: UIButton) {
        
    let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
    
    let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a Source", preferredStyle: .actionSheet)
    
//Can add camera images later. Would need to save image to filemanager.
//    if UIImagePickerController.isSourceTypeAvailable(.camera) {
//    actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
//    imagePickerController.sourceType = .camera
//    imagePickerController.allowsEditing = false
//    self.present(imagePickerController, animated: true, completion: nil)
//    }))
//    }
//    else{
//    print("Camera not available")
//    }
    
    actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
    imagePickerController.sourceType = .photoLibrary
    imagePickerController.allowsEditing = false
    self.present(imagePickerController, animated: true, completion: nil)
    }))
    
    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    self.present(actionSheet, animated: true, completion: nil)
    
}

func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
    if let imageURL = info[UIImagePickerControllerImageURL] as? URL {
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            try FileManager.default.moveItem(at: imageURL.standardizedFileURL, to: documentDirectory.appendingPathComponent(imageURL.lastPathComponent))
            collectionView.reloadData()
        } catch {
            print(error)
        }
    }
    
    picker.dismiss(animated: true, completion: nil)
    }
    

func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
}
    
func checkPhotoLibraryPermission() {
    let status = PHPhotoLibrary.authorizationStatus()
    switch status {
    case .authorized: break
        
    //handle authorized status
    case .denied, .restricted : break
    //handle denied status
    case .notDetermined:
        // ask for permissions
        PHPhotoLibrary.requestAuthorization() { status in
            switch status {
            case .authorized: break
            // as above
            case .denied, .restricted: break
            // as above
            case .notDetermined: break
                // won't happen but still
            }
        }
    }
}
}

//Flow Layout Arrangement for UICollectionView
extension CollectionViewController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}



//        let usD = UserDefaults.standard
//        let array = usD.stringArray(forKey: "WeatherArray") ?? []
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! myCell
//
//        let myString = array[indexPath.row]
//        let imageUrl = URL(fileURLWithPath: myString)
//        let imageData = try? Data(contentsOf: imageUrl)
//        let image = UIImage(data: imageData!)
//        cell.myImageView.image = image



//        let data = try? Data(contentsOf: urls!)
//        let image: UIImage = UIImage(data: data!)!

//        let imageData: NSData = try! NSData(contentsOf: urls!)
//        let cvImage = UIImage(data:imageData as Data)
//
//        let imageData = try! Data(contentsOf: urls as! URL)
//        cell.myImageView.image = UIImage(data: imageData)
//        cell.myImageView.image = image


//Save array to UserDefaults and add picked image url to the array
//        let usD = UserDefaults.standard
//        var urls = usD.stringArray(forKey: "WeatherArray") ?? []
//        urls.append(imageURL.path)
//        usD.set(urls, forKey: "WeatherArray")

//        let myFileNames = directoryContents.map{$0.lastPathComponent}
//        print("My Collection View Photos include \(myFileNames)")
//        let myString = myFileNames[indexPath.row]
//        let filePath = directory[indexPath.row].thumbnail
//        cell.postImage.image = UIImage(contentsOfFile:filePath)
