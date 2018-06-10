//
//  MeusDadosVC.swift
//  FideliCash-Cliente
//
//  Created by Carlos Doki on 09/06/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftKeychainWrapper
import Firebase

class MeusDadosVC: UIViewController {
    
    @IBOutlet weak var nomeTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var telefoneTxt: UITextField!
    @IBOutlet weak var cpfTxt: UITextField!
    @IBOutlet weak var photoURL: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    
    var activeField: UITextField?
    var lastOffset: CGPoint!
    var keyboardHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nomeTxt.setBottomLine(borderColor: nomeTxt.textColor!)
        emailTxt.setBottomLine(borderColor: emailTxt.textColor!)
        telefoneTxt.setBottomLine(borderColor: telefoneTxt.textColor!)
        cpfTxt.setBottomLine(borderColor: cpfTxt.textColor!)
        
        // Do any additional setup after loading the view.
        let user = Auth.auth().currentUser
        if let user = user {
            emailTxt.text = user.email
            photoURL.load(url: user.photoURL!)
            nomeTxt.text = user.displayName
            telefoneTxt.text = user.phoneNumber
        }
        cpfTxt.text = UserCPF
        
        // Observe keyboard change
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Add touch gesture for contentView
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(returnTextView(gesture:))))
    }
    
    @objc func returnTextView(gesture: UIGestureRecognizer) {
        guard activeField != nil else {
            return
        }
        
        activeField?.resignFirstResponder()
        activeField = nil
    }
    
    @IBAction func btnSairPressed(_ sender: RoundedButton) {
        let alert = UIAlertController(title: "FideliCash", message: "Confirma o logout?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Sim", style: .default) { (UIAlertAction) in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                KeychainWrapper.standard.removeObject(forKey: KEY_UID)
                exit(0)
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
        let cancel = UIAlertAction(title: "Não", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func salvarBtnPressed(_ sender: RoundedButton) {
        if (cpfTxt.text == "") {
            let alert = UIAlertController(title: "Alerta", message: "Número de CPF inválido ou incompleto", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let user = Auth.auth().currentUser
            let ref = Database.database().reference()
            let users = ref.child("users").child((user?.uid)!)
            users.child("cpf").setValue(cpfTxt.text)
        }
    }
    
}
// MARK: UITextFieldDelegate
extension MeusDadosVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        lastOffset = self.scrollView.contentOffset
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeField?.resignFirstResponder()
        activeField = nil
        return true
    }
}

// MARK: Keyboard Handling
extension MeusDadosVC {
    @objc func keyboardWillShow(notification: NSNotification) {
        if keyboardHeight != nil {
            return
        }
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            
            // so increase contentView's height by keyboard height
            UIView.animate(withDuration: 0.3, animations: {
                self.constraintContentHeight.constant += self.keyboardHeight
            })
            
            // move if keyboard hide input field
            let distanceToBottom = self.scrollView.frame.size.height - (activeField?.frame.origin.y)! - (activeField?.frame.size.height)!
            let collapseSpace = keyboardHeight - distanceToBottom
            
            if collapseSpace < 0 {
                // no collapse
                return
            }
            
            // set new offset for scroll view
            UIView.animate(withDuration: 0.3, animations: {
                // scroll to the position above keyboard 10 points
                self.scrollView.contentOffset = CGPoint(x: self.lastOffset.x, y: collapseSpace + 20)
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if keyboardHeight != nil {
            UIView.animate(withDuration: 0.3) {
                self.constraintContentHeight.constant -= self.keyboardHeight
                
                self.scrollView.contentOffset = self.lastOffset
            }
        }
        keyboardHeight = nil
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
