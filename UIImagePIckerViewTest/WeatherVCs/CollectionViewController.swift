//
//  CollectionViewController.swift
//  UIImagePIckerViewTest
//
//  Created by Robin Allemand on 11/25/17.
//  Copyright © 2017 Robin Allemand. All rights reserved.
//

import UIKit
import Photos

let albumName3 = "Panda Nice"            //App specific folder name

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var albumFound : Bool = false
    var assetCollection: PHAssetCollection = PHAssetCollection()
    var photosAsset: PHFetchResult<PHAsset>!
    var assetThumbnailSize:CGSize!
    var index: Int = 0
    
    //    fileprivate let itemsPerRow: CGFloat = 3
    //    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 15.0, bottom: 50.0, right: 15.0)
    
    //Actions & Outlets
    @IBOutlet weak var addMyImageButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //    @IBAction func btnCamera(_ sender : AnyObject) {
    //        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
    //            //load the camera interface
    //            let picker : UIImagePickerController = UIImagePickerController()
    //            picker.sourceType = UIImagePickerControllerSourceType.camera
    //            picker.delegate = self
    //            picker.allowsEditing = false
    //            self.present(picker, animated: true, completion: nil)
    //        } else {
    //            //no camera available
    //            let alert = UIAlertController(title: "Error", message: "There is no camera available", preferredStyle: .alert)
    //            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {(alertAction)in
    //                alert.dismiss(animated: true, completion: nil)
    //            }))
    //            self.present(alert, animated: true, completion: nil)
    //        }
    //    }
    
    @IBAction func addMyImage(_ sender : AnyObject) {
        let picker : UIImagePickerController = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.delegate = self
        picker.allowsEditing = false
        self.present(picker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        //Check if the folder exists, if not, create it
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName3)
        let collection: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let first_Obj:AnyObject = collection.firstObject{
            //found the album
            self.albumFound = true
            self.assetCollection = first_Obj as! PHAssetCollection
        } else {
            //Album placeholder for the asset collection, used to reference collection in completion handler
            var albumPlaceholder: PHObjectPlaceholder!
            //create the folder
            NSLog("\nFolder \"%@\" does not exist\nCreating now...", albumName3)
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName3)
                albumPlaceholder = request.placeholderForCreatedAssetCollection
            },
                                                   completionHandler: {(success:Bool, error:Error?) in
                                                    if(success){
                                                        print("Successfully created folder")
                                                        self.albumFound = true
                                                        let collection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [albumPlaceholder.localIdentifier], options: nil)
                                                        self.assetCollection = collection.firstObject!
                                                    } else {
                                                        print("Error creating folder")
                                                        self.albumFound = false
                                                    }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Get size of the collectionView cell for thumbnail image
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            let cellSize = layout.itemSize
            self.assetThumbnailSize = CGSize(width: cellSize.width, height: cellSize.height)
        }
        
        //fetch the photos from collection
        self.navigationController?.hidesBarsOnTap = false   //!! Use optional chaining
        self.photosAsset = PHAsset.fetchAssets(in: self.assetCollection, options: nil)
        
        
        //        if let photoCnt = self.photosAsset?.count{
        //            if(photoCnt == 0){
        //                self.noPhotosLabel.isHidden = false
        //            }else{
        //                self.noPhotosLabel.isHidden = true
        //            }
        //        }
        self.collectionView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if(segue.identifier == "viewLargePhoto"){
    //            if let controller:ViewPhoto = segue.destination as? ViewPhoto{
    //                if let cell = sender as? UICollectionViewCell{
    //                    if let indexPath: IndexPath = self.collectionView.indexPath(for: cell){
    //                        controller.index = indexPath.item
    //                        controller.photosAsset = self.photosAsset
    //                        controller.assetCollection = self.assetCollection
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    
    //UICollectionViewDataSource Methods (Remove the "!" on variables in the function prototype)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        var count: Int = 0
        if(self.photosAsset != nil){
            count = self.photosAsset.count
        }
        return count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? myCell
        
        //Modify the cell
        let asset = self.photosAsset[indexPath.item]
        
        // Create options for retrieving image (Degrades quality if using .Fast)
        //        let imageOptions = PHImageRequestOptions()
        //        imageOptions.resizeMode = PHImageRequestOptionsResizeMode.Fast
        PHImageManager.default().requestImage(for: asset, targetSize: self.assetThumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: {(result, info) in
            if let image = result {
                cell?.setThumbnailImage(image)
                cell?.delegate = self
            }
        })
        return cell!
    }
    
    //UICollectionViewDelegateFlowLayout methods
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
    //        return 4
    //    }
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
    //        return 1
    //    }
    
    
    
    //UIImagePickerControllerDelegate Methods
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]){
        NSLog("in didFinishPickingMediaWithInfo")
        if let image: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            //Implement if allowing user to edit the selected image
            //let editedImage = info.objectForKey("UIImagePickerControllerEditedImage") as UIImage
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async(execute: {
                PHPhotoLibrary.shared().performChanges({
                    let createAssetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                    let assetPlaceholder = createAssetRequest.placeholderForCreatedAsset
                    if let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection, assets: self.photosAsset) {
                        albumChangeRequest.addAssets([assetPlaceholder!] as NSArray)
                    }
                }, completionHandler: {(success, error)in
                    DispatchQueue.main.async(execute: {
                        NSLog("Adding Image to Library -> %@", (success ? "Success":"Error!"))
                        picker.dismiss(animated: true, completion: nil)
                    })
                })
            })
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
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
        if var indexPath = collectionView?.indexPath(for: cell) {
            //1. delete the photo from our data source
            PHPhotoLibrary.shared().performChanges({
                //Delete Photo
                if let request = PHAssetCollectionChangeRequest(for: self.assetCollection){
                    request.removeAssets(at: IndexSet([indexPath.item]))
                }
            }, completionHandler: {(success: Bool, error: Error?) in
                if (success) {
                    // Move to the main thread to execute
                    DispatchQueue.main.async(execute: {
                        self.photosAsset = PHAsset.fetchAssets(in: self.assetCollection, options: nil)
                        if self.photosAsset.count == 0 {
                            print("No Images Left!!")
                            self.collectionView.reloadData()
                            //if let navController = self.navigationController {
                            //navController.popToRootViewController(animated: true)
                            //}
                        } else {
                            print("\(self.photosAsset.count) image/s left")
                            if indexPath.item >= self.photosAsset.count {
                                indexPath.item = self.photosAsset.count - 1
                                self.collectionView.reloadData()
                            }
                        }
                    })
                } else {
                    print("Error: \(String(describing: error))")
                }
            })
            
            
            //2. delete the photo cell at that index path from the collection view
            //                self.collectionView?.deleteItems(at: [indexPath])
            //                self.collectionView.reloadData()
        }
    }
}















//Mark: Worked for FileManager, but only on one documentsdirectory. I couldn't separate into multiple view controllers.

//import Foundation
//import UIKit
//import Photos
//
//class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    var directoryContentsArray = [URL]()
//
//    fileprivate let itemsPerRow: CGFloat = 3
//    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 15.0, bottom: 50.0, right: 15.0)
//
//
//    @IBOutlet weak var addMyImageButton: UIBarButtonItem!
//    @IBOutlet weak var collectionView: UICollectionView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        fetchDirectoryContents()
//        checkPhotoLibraryPermission()
//
//        navigationItem.rightBarButtonItem = editButtonItem
//
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
////        collectionView.reloadData()
//    }
//
//    //number of views
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print(directoryContentsArray.count)
//        return directoryContentsArray.count
//
//            }
//
//    //populate the views
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? myCell {
//                let imageFile = self.directoryContentsArray[indexPath.item]
//                if imageFile.pathExtension == "jpeg",
//                    let image = UIImage(contentsOfFile: imageFile.path) {
//                    cell.myImageView.image = image
//                    cell.delegate = self as myCellDelegate
//                }
//                else if
//                    imageFile.pathExtension == "png",
//                    let image = UIImage(contentsOfFile: imageFile.path) {
//                        cell.myImageView.image = image
//                    cell.delegate = self as myCellDelegate
//                }
//                else {
//                    fatalError("Can't create image from file \(imageFile)")
//                }
//                return cell
//            }
//            return UICollectionViewCell()
//        }
//
//
//    @IBAction func addMyImage(_ sender: UIBarButtonItem) {
//
//    let imagePickerController = UIImagePickerController()
//        imagePickerController.delegate = self
//
//    let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a Source", preferredStyle: .actionSheet)
//
////Can add camera images later. Would need to save image to filemanager.
////    if UIImagePickerController.isSourceTypeAvailable(.camera) {
////    actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
////    imagePickerController.sourceType = .camera
////    imagePickerController.allowsEditing = false
////    self.present(imagePickerController, animated: true, completion: nil)
////    }))
////    }
////    else{
////    print("Camera not available")
////    }
//
//    actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
//    imagePickerController.sourceType = .photoLibrary
//    imagePickerController.allowsEditing = false
//    self.present(imagePickerController, animated: true, completion: nil)
//    }))
//
//    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//    self.present(actionSheet, animated: true, completion: nil)
//
//}
//
//func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//
//    if let imageURL = info[UIImagePickerControllerImageURL] as? URL {
//
//        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        do {
//            try FileManager.default.moveItem(at: imageURL.standardizedFileURL, to: documentDirectory.appendingPathComponent(imageURL.lastPathComponent))
//
////            collectionView.reloadData()
//        } catch {
//            print(error)
//        }
//    }
//
//    picker.dismiss(animated: true, completion: nil)
//    }
//
//
//func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//    picker.dismiss(animated: true, completion: nil)
//}
//
////Mark - Delete Items
//
//    override func setEditing(_ editing: Bool, animated: Bool) {
//        super.setEditing(editing, animated: animated)
//
//        addMyImageButton.isEnabled = !editing
//        if let indexPaths = collectionView?.indexPathsForVisibleItems {
//            for indexPath in indexPaths {
//                if let cell = collectionView?.cellForItem(at: indexPath) as? myCell {
//                    cell.isEditing = editing
//                }
//            }
//        }
//    }
//
//
//func fetchDirectoryContents() {
//    let fileManager = FileManager.default
//    let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//    let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
//
//    self.directoryContentsArray = directoryContents
//    print(directoryContentsArray.count)
//    collectionView.reloadData()
//}
//
//
//func checkPhotoLibraryPermission() {
//    let status = PHPhotoLibrary.authorizationStatus()
//    switch status {
//    case .authorized: break
//
//    //handle authorized status
//    case .denied, .restricted : break
//    //handle denied status
//    case .notDetermined:
//        // ask for permissions
//        PHPhotoLibrary.requestAuthorization() { status in
//            switch status {
//            case .authorized: break
//            // as above
//            case .denied, .restricted: break
//            // as above
//            case .notDetermined: break
//                // won't happen but still
//            }
//        }
//    }
//}
//}
//
//extension CollectionViewController: myCellDelegate
//{
//    func delete(cell: myCell) {
//        if let indexPath = collectionView?.indexPath(for: cell) {
//            //1. delete the photo from our data source
//            let fileManager = FileManager.default
//            let imageFile = self.directoryContentsArray[indexPath.item]
//            let imagePath = imageFile.path
//            try! fileManager.removeItem(atPath: imagePath)
//
//            directoryContentsArray.remove(at: indexPath.item)
//
//            //2. delete the photo cell at that index path from the collection view
//            collectionView?.deleteItems(at: [indexPath])
//        }
//    }
//}
//
////Flow Layout Arrangement for UICollectionView
//extension CollectionViewController : UICollectionViewDelegateFlowLayout {
//    //1
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        //2
//        let paddingSpace = sectionInsets.left * (itemsPerRow + 0.5)
//        let availableWidth = view.frame.width - paddingSpace
//        let widthPerItem = availableWidth / itemsPerRow
//
//        return CGSize(width: widthPerItem, height: widthPerItem)
//    }
//
//    //3
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//        return sectionInsets
//    }
//
//    // 4
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return sectionInsets.left
//    }
//}



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
