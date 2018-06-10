//
//  TransferirConfirmarVC.swift
//  FideliCash-Cliente
//
//  Created by Carlos Doki on 10/06/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftKeychainWrapper


class TransferirConfirmarVC: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var valorTxt: UITextField!
    @IBOutlet weak var QRCodeimg: UIImageView!
    
    var qrcodeImage: CIImage!
    let locationManger = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.requestWhenInUseAuthorization()
        locationManger.startMonitoringSignificantLocationChanges()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            Location.sharedInstance.latitude = locationManger.location?.coordinate.latitude
            Location.sharedInstance.longitude = locationManger.location?.coordinate.longitude
            
            
        } else {
            locationManger.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }
    
    @IBAction func voltarBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func convert(cmage:CIImage) -> UIImage
    {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
    
    @IBAction func gerarQRCodeBtnPressed(_ sender: RoundedButton) {
        if qrcodeImage == nil {
            if valorTxt.text == "" {
                return
            }

            let textocompleto = "valor=\(valorTxt.text!);lat=\(Location.sharedInstance.latitude!);lon=\(Location.sharedInstance.longitude!);origin=\(KeychainWrapper.standard.string(forKey: KEY_UID)!)"
            let data = textocompleto.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
            
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter!.setValue(data, forKey: "inputMessage")
            filter!.setValue("Q", forKey: "inputCorrectionLevel")
            qrcodeImage = filter!.outputImage
            
            let scaleX = QRCodeimg.frame.size.width / qrcodeImage.extent.size.width
            let scaleY = QRCodeimg.frame.size.height / qrcodeImage.extent.size.height
            let transformedImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
            QRCodeimg.image = convert(cmage: transformedImage)
            valorTxt.resignFirstResponder()
            //displayQRCodeImage()
        }
        else {
            self.QRCodeimg.image = nil
            self.qrcodeImage = nil
        }
    }
}
