//
//  myCell.swift
//  UIImagePIckerViewTest
//
//  Created by Robin Allemand on 11/25/17.
//  Copyright © 2017 Robin Allemand. All rights reserved.
//

import UIKit

protocol myCloudyCellDelegate: class {
    func delete(cell: myCloudyCell)
}

class myCloudyCell: UICollectionViewCell {
    
    @IBOutlet weak var deleteButtonBackgroundView: UIVisualEffectView!
    @IBOutlet weak var myCloudyImageView: UIImageView!
    
    weak var delegate: myCloudyCellDelegate?
    
    func setThumbnailImage(_ thumbnailImage: UIImage){
        self.myCloudyImageView.image = thumbnailImage
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



