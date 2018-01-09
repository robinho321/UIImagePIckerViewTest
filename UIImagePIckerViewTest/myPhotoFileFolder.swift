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
        return weatherFolders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = weatherFolders[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
        
        myIndex = indexPath.row
        performSegue(withIdentifier: "collectionVC", sender: self)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
