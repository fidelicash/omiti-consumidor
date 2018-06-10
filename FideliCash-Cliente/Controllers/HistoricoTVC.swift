//
//  HistoricoTVC.swift
//  FideliCash-Cliente
//
//  Created by Carlos Doki on 09/06/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import UIKit
import Firebase

class HistoricoTVC: UITableViewCell {

    @IBOutlet weak var dataLbl: UILabel!
    @IBOutlet weak var nomeLbl: UILabel!
    @IBOutlet weak var valorLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(date: String, origin: String, target: String, value: Double) {
        DataService.ds.REF_USERS.child(target).observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if snap.key == "nome" {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"//this your string date format
                        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                        let date = dateFormatter.date(from: date)
                        
                        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"///this is what you want to convert format
                        dateFormatter.timeZone = NSTimeZone(name: "GMT-3") as TimeZone?
                        let timeStamp = dateFormatter.string(from: date!)
                        
                        self.dataLbl.text = timeStamp
                        self.nomeLbl.text = snap.value as! String
                        self.valorLbl.text =  "\(String(format: "%.2f", value))"
                    }
                }
            }
        })
    }
}
