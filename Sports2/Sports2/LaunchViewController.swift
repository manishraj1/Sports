//
//  LaunchViewController.swift
//  Sports2
//
//  Created by Manish raj(MR) on 23/12/21.
//

import Foundation
import UIKit

class SplashViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()
        login()
    }
    
    private func login() {
        let vc = (storyboard?.instantiateViewController(identifier: "tabBarVC"))! as UIViewController
        vc.modalPresentationStyle = .fullScreen
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1) , execute: {
            self.present(vc, animated: true)
        })
    }
}
