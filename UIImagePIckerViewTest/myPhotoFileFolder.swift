//
//  myPhotoFileFolder.swift
//  UIImagePIckerViewTest
//
//  Created by Robin Allemand on 11/25/17.
//  Copyright © 2017 Robin Allemand. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

enum weatherConditions {
    case nice
    case cloudy
    case cold
    case rain
    case lightning
    
    static let allValues = [nice, cloudy, cold, rain, lightning]
}

var weatherFolders = ["Nice", "Cloudy", "Cold", "Rain", "Lightning"]
var myIndex = 0

protocol myPhotoFileFolderDelegate {
    func didClose(controller: myPhotoFileFolder)
}

class myPhotoFileFolder: UITableViewController {
    var delegate: myPhotoFileFolderDelegate? = nil
    
    @IBAction func closeButton(_ sender: UIBarButtonItem) {
        self.delegate?.didClose(controller: self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherConditions.allValues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = weatherFolders[indexPath.row]
        
        return cell
    }
    
    
    //share - take the user to the URL that is my app
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
        
        if indexPath.row == 0 {
            segueToPhotoFolder(.nice)
        }
            
        else if indexPath.row == 1 {
            segueToPhotoFolder(.cloudy)
        }
            
        else if indexPath.row == 2 {
            segueToPhotoFolder(.cold)
        }
            
        else if indexPath.row == 3 {
            segueToPhotoFolder(.rain)
        }
            
        else if indexPath.row == 4 {
            segueToPhotoFolder(.lightning)
        }
        
//        myIndex = indexPath.row
//        performSegue(withIdentifier: "collectionVC", sender: self)
        
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
//
//        if let index = self.tableView.indexPathForSelectedRow{
//            self.tableView.deselectRow(at: index, animated: true)
//        }
//
//        myIndex = indexPath.row
//        performSegue(withIdentifier: "collectionVC", sender: self)
//
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func segueToPhotoFolder(_ weatherConditions: weatherConditions) {
        switch weatherConditions {
        case .nice:
            return self.performSegue(withIdentifier: "showNice", sender: nil)
        case .cloudy:
            return self.performSegue(withIdentifier: "showCloudy", sender: nil)
        case .cold:
            return self.performSegue(withIdentifier: "showCold", sender: nil)
        case .rain:
            return self.performSegue(withIdentifier: "showRain", sender: nil)
        case .lightning:
            return self.performSegue(withIdentifier: "showLightning", sender: nil)
        }
    }
}

//    func nice() {
//        self.performSegue(withIdentifier: "showTerms", sender: nil)
//    }
//
//    func cloudy() {
//        self.performSegue(withIdentifier: "showTerms", sender: nil)
//    }
//
//    func cold() {
//        self.performSegue(withIdentifier: "showTerms", sender: nil)
//    }
//
//    func rain() {
//        self.performSegue(withIdentifier: "showTerms", sender: nil)
//    }
//
//    func lightning() {
//        self.performSegue(withIdentifier: "showTerms", sender: nil)
//    }

//class CustomPhotoAlbum: NSObject {
//    static let albumName = "Cold"
//    static let sharedInstance = CustomPhotoAlbum()
//
//    var assetCollection: PHAssetCollection!
//
//    override init() {
//        super.init()
//
//        if let assetCollection = fetchAssetCollectionForAlbum() {
//            self.assetCollection = assetCollection
//            return
//        }
//
//        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
//            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
//                ()
//            })
//        }
//
//        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
//            self.createAlbum()
//        } else {
//            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
//        }
//    }
//
//    func requestAuthorizationHandler(status: PHAuthorizationStatus) {
//        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
//            // ideally this ensures the creation of the photo album even if authorization wasn't prompted till after init was done
//            print("trying again to create the album")
//            self.createAlbum()
//        } else {
//            print("should really prompt the user to let them know it's failed")
//        }
//    }
//
//    func createAlbum() {
//        PHPhotoLibrary.shared().performChanges({
//            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: CustomPhotoAlbum.albumName)   // create an asset collection with the album name
//        }) { success, error in
//            if success {
//                self.assetCollection = self.fetchAssetCollectionForAlbum()
//            } else {
//                print("error \(error)")
//            }
//        }
//    }
//
//    func fetchAssetCollectionForAlbum() -> PHAssetCollection? {
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.predicate = NSPredicate(format: "title = %@", CustomPhotoAlbum.albumName)
//        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
//
//        if let _: AnyObject = collection.firstObject {
//            return collection.firstObject
//        }
//        return nil
//    }
//
//    func save(image: UIImage) {
//        if assetCollection == nil {
//            return                          // if there was an error upstream, skip the save
//        }
//
//        PHPhotoLibrary.shared().performChanges({
//            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
//            let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
//            let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection)
//            let enumeration: NSArray = [assetPlaceHolder!]
//            albumChangeRequest!.addAssets(enumeration)
//
//        }, completionHandler: nil)
//    }
//}

