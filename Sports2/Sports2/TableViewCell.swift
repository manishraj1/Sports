//
//  TableViewCell.swift
//  Sports2
//
//  Created by Manish raj(MR) on 23/12/21.
//

import Foundation
import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    func setTableCellBackGroundColor() {
        let dictOfStadiumAndColors = SportsArray.dictOfStadiumAndTeamColorHex
        
        
        
        if let stadium = self.label.text {
            if let teamColorHex = dictOfStadiumAndColors[stadium] {
                if teamColorHex.count == 6 {
                    let teamColor = UIColor().colorFromHex(teamColorHex)
                    self.label.textColor = teamColor
                } else {
                    self.label.textColor = .black
                }
            }
        } else {
            print("Error setting color")
        }
    }
}
