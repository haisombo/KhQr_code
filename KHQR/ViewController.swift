//
//  ViewController.swift
//  KHQR
//
//  Created by Hai Sombo on 4/3/24.
//

import UIKit
import BakongKHQR

//MARK: life cycle
class ViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var bgImageQr        : UIImageView!
    @IBOutlet weak var nameLabel        : UILabel!
    @IBOutlet weak var dataAmountLabel  : UILabel!
    @IBOutlet weak var qrCodeImage      : UIImageView!
    @IBOutlet weak var qrCurrency       : UIImageView!
    @IBOutlet weak var inputText        : UITextField!
    @IBOutlet weak var payNowButton     : UIButton!
    
    //MARK: - Properties/Fields
    var qrCodeStrings   = ""
    var amount          = Double()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: Implementation goes here
        
        self.payNowButton.layer.cornerRadius = 10
        
        self.generateKhqr()
        // scan Qr
        self.setupUI()
        
    }
    //MARK: - Button action
    @IBAction func payNowButton(_ sender: Any) {
        self.amount = Double(inputText.text ?? "") ?? 0.0
        
//        self.qrCodeImage = nil
//        self.qrCurrency  = nil
        
        self.generateKhqr()
        // scan Qr
        self.setupUI()
    }
    
    func qrScanPayment () {
        // Generate QR code image from the current string
        if let qrCodeImages = generateQRCodeWithLogo(from: qrCodeStrings) {
            self.qrCodeImage.image = qrCodeImages
//            self.qrCurrency.image  = UIImage(named : "Vector")
            
        }else {
            print("error")
        }
    }
    func setupUI(){
        self.dataAmountLabel.text = String("$" + "\(self.amount)" )
        qrScanPayment()
    }
  
    func generateQRCodeWithLogo(from string: String) -> UIImage? {
        let data = string.data(using: .utf8)
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        
        qrFilter.setValue(data, forKey: "inputMessage")
        guard let qrCodeImage = qrFilter.outputImage else { return nil }
        
        let scaleX = UIScreen.main.scale
        let transformedImage = qrCodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleX))
        
        return UIImage(ciImage: transformedImage)
    }
    
    func generateKhqr () {
        let info = IndividualInfo(accountId: "khqr@ppcb",
                                  merchantName: "WeCafe Top-up",
                                  accountInformation:  "9700000 000507",
                                  acquiringBank: "Phnom Penh Commercial Bank",
                                  currency: .Usd,
                                  amount: amount)
        
        let khqrResponse = BakongKHQR.generateIndividual(info!)
        if khqrResponse.status?.code == 0 {
            let khqrData = khqrResponse.data as? KHQRData
            qrCodeStrings = khqrData?.qr ?? ""
            
            print("data: \(khqrData?.qr ?? "")")
            print("md5: \(khqrData?.md5 ?? "")")
        }
    }
    

}

//extension CIImage {
//    /// Combines the current image with the given image centered.
//    func combined(with image: CIImage) -> CIImage? {
//        guard let combinedFilter = CIFilter(name: "CISourceOverCompositing") else { return nil }
//        let centerTransform = CGAffineTransform(translationX: extent.midX - (image.extent.size.width / 2), y: extent.midY - (image.extent.size.height / 2))
//        combinedFilter.setValue(image.transformed(by: centerTransform), forKey: "inputImage")
//        combinedFilter.setValue(self, forKey: "inputBackgroundImage")
//        return combinedFilter.outputImage!
//    }
//    
//}
//extension CIImage {
//    /// Inverts the colors and creates a transparent image by converting the mask to alpha.
//    /// Input image should be black and white.
//    var transparent: CIImage? {
//        return inverted?.blackTransparent
//    }
//
//    /// Inverts the colors.
//    var inverted: CIImage? {
//        guard let invertedColorFilter = CIFilter(name: "CIColorInvert") else { return nil }
//
//        invertedColorFilter.setValue(self, forKey: "inputImage")
//        return invertedColorFilter.outputImage
//    }
//
//    /// Converts all black to transparent.
//    var blackTransparent: CIImage? {
//        guard let blackTransparentFilter = CIFilter(name: "CIMaskToAlpha") else { return nil }
//        blackTransparentFilter.setValue(self, forKey: "inputImage")
//        return blackTransparentFilter.outputImage
//    }
//
//    /// Applies the given color as a tint color.
//    func tinted(using color: UIColor) -> CIImage?
//    {
//        guard
//            let transparentQRImage = transparent,
//            let filter = CIFilter(name: "CIMultiplyCompositing"),
//            let colorFilter = CIFilter(name: "CIConstantColorGenerator") else { return nil }
//a
//        let ciColor = CIColor(color: color)
//        colorFilter.setValue(ciColor, forKey: kCIInputColorKey)
//        let colorImage = colorFilter.outputImage
//
//        filter.setValue(colorImage, forKey: kCIInputImageKey)
//        filter.setValue(transparentQRImage, forKey: kCIInputBackgroundImageKey)
//
//        return filter.outputImage!
//    }
//}
