//
//  ListViewController.swift
//  Sports2
//
//  Created by Manish raj(MR) on 23/12/21.
//

import Foundation
import UIKit

class ListViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textField: UITextView!
    var stadiumDetail: StadiumDetails!
    var savedText = Note()
    var savedNote: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        navigationController?.title = "Notes"
        
        if NetworkMonitor.shared.isConnected{
            print("you have internet")
        }
        else {
            showAlert()
        }
        
        savedNote = (stadiumDetail.note?.text!)
        if let savedTextField = savedNote {
            textField.text = savedTextField
        } else {
            textField.becomeFirstResponder()
        }
        setBackgroundColor()
    
    }
    
    func setBackgroundColor() {
        let dictOfStadiumAndColors = SportsArray.dictOfStadiumAndTeamColorHex
        
        if let stadium = stadiumDetail.name {
                if let teamColorHex = dictOfStadiumAndColors[stadium] {
                    if teamColorHex.count == 6 {
                        let teamColor = UIColor().colorFromHex(teamColorHex)
                        textField.backgroundColor = teamColor
                        textField.textColor = .white
                    } else {
                        textField.backgroundColor = .white
                        textField.textColor = .black
                    }
                }
            } else {
                print("Error setting color")
            }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    fileprivate func saveText() {
        let note = Note(context: InfoController.shared.viewContext)
        note.text = textField.text
        note.stadium = stadiumDetail
        savedNote = textField.text
        InfoController.shared.save()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        saveText()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { action in
            print("tapped Ok")
        }))
        present(alert, animated: true)
    }

}
