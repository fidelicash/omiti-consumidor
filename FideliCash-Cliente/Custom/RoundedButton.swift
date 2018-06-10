//
//  RoundedButton.swift
//  FideliCash-Cliente
//
//  Created by Carlos Doki on 09/06/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderWidth = UIScreen.main.nativeScale * 2
        contentEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 16)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
        layer.borderColor = isEnabled ? tintColor.cgColor : UIColor.lightGray.cgColor
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 5, height: 5)
    }
}
