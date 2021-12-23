//
//  PopularViewController.swift
//  Sports2
//
//  Created by Manish raj(MR) on 23/12/21.
//

import Foundation
import UIKit

class SharePhotoViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    
    var photo: Photo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(data: photo.imageData!)
        imageView.image = image
    }
    
    
    @IBAction func shareBtnPressed(_ sender: Any) {
        let image = imageView.image
        let activityController = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        
        present(activityController, animated: true)
    }
    
}

