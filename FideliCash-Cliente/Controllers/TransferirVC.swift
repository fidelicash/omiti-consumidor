//
//  TransferirVC.swift
//  FideliCash-Cliente
//
//  Created by Carlos Doki on 09/06/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import UIKit

class TransferirVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func transferirBtnPressed(_ sender: RoundedButton) {
        self.performSegue(withIdentifier: "transferir", sender: nil)
    }
}
