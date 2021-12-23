//
//  CollectionViewCell.swift
//  Sports2
//
//  Created by Manish raj(MR) on 23/12/21.
//

import Foundation
import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setUpCell(_ photo: Photo) {
        
        if photo.imageData != nil {
            let image = UIImage(data: photo.imageData! as Data)
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
}
