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
    
    var directoryContentsArray = [URL]()
    
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 15.0, bottom: 50.0, right: 15.0)
    
    @IBOutlet weak var addMyImageButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDirectoryContents()
        checkPhotoLibraryPermission()
        
        navigationItem.rightBarButtonItem = editButtonItem
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        collectionView.reloadData()
    }
    
    //number of views
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(directoryContentsArray.count)
        return directoryContentsArray.count

            }
    
    //populate the views
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? myCell {
                let imageFile = self.directoryContentsArray[indexPath.item]
                if imageFile.pathExtension == "jpeg",
                    let image = UIImage(contentsOfFile: imageFile.path) {
                    cell.myImageView.image = image
                    cell.delegate = self as myCellDelegate
                }
                else if
                    imageFile.pathExtension == "png",
                    let image = UIImage(contentsOfFile: imageFile.path) {
                        cell.myImageView.image = image
                    cell.delegate = self as myCellDelegate
                }
                else {
                    fatalError("Can't create image from file \(imageFile)")
                }
                
                return cell
            }
            return UICollectionViewCell()
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
    
//Mark - Delete Items
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        addMyImageButton.isEnabled = !editing
        if let indexPaths = collectionView?.indexPathsForVisibleItems {
            for indexPath in indexPaths {
                if let cell = collectionView?.cellForItem(at: indexPath) as? myCell {
                    cell.isEditing = editing
                }
            }
        }
    }
    
    
func fetchDirectoryContents() {
    let fileManager = FileManager.default
    let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
    
    self.directoryContentsArray = directoryContents
    print(directoryContentsArray.count)
    collectionView.reloadData()
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

extension CollectionViewController: myCellDelegate
{
    func delete(cell: myCell) {
        if let indexPath = collectionView?.indexPath(for: cell) {
            //1. delete the photo from our data source
            let fileManager = FileManager.default
            let imageFile = self.directoryContentsArray[indexPath.item]
            let imagePath = imageFile.path
            try! fileManager.removeItem(atPath: imagePath)
            
            directoryContentsArray.remove(at: indexPath.item)
            
            //2. delete the photo cell at that index path from the collection view
            collectionView?.deleteItems(at: [indexPath])
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
        let paddingSpace = sectionInsets.left * (itemsPerRow + 0.5)
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


//    func fetchDirectoryContents(_ type: URL) -> [String] {
//        let fileManager = FileManager.default
//        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
//        print("directory contents is \(directoryContents)")
//        return directoryContents as [String]
//    }


//        let fileManager = FileManager.default
//        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
//        let dirContents = try? fileManager.contentsOfDirectory(atPath: documentsPath)
//        let count = dirContents?.count
//        return count!


//        let fileManager = FileManager.default
//        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
