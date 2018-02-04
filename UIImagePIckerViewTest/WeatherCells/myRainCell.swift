//
//  myRainCell.swift
//  UIImagePIckerViewTest
//
//  Created by Robin Allemand on 1/21/18.
//  Copyright © 2018 Robin Allemand. All rights reserved.
//

import UIKit
import Photos

protocol myRainCellDelegate: class {
    func delete(cell: myRainCell)
}

class myRainCell: UICollectionViewCell {
    
    @IBOutlet weak var deleteButtonBackgroundView: UIVisualEffectView!
    @IBOutlet weak var myRainImageView: UIImageView!
    
    weak var delegate: myRainCellDelegate?
    
    func setThumbnailImage(_ thumbnailImage: UIImage){
        self.myRainImageView.image = thumbnailImage
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        deleteButtonBackgroundView.layer.cornerRadius = deleteButtonBackgroundView.bounds.width / 2.0
        deleteButtonBackgroundView.layer.masksToBounds = true
        deleteButtonBackgroundView.isHidden = !isEditing
    }
    
    var isEditing: Bool = false {
        didSet {
            deleteButtonBackgroundView.isHidden = !isEditing
        }
    }
    
    @IBAction func deleteButtonDidTap(_ sender: Any) {
        delegate?.delete(cell: self)
    }
}

