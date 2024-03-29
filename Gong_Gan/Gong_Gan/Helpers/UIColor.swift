//
//  UIColor.swift
//  Gong_Gan
//
//  Created by 이창형 on 2023/09/13.
//

import UIKit

extension UIColor {
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
            var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
            
            if hexFormatted.hasPrefix("#") {
                hexFormatted = String(hexFormatted.dropFirst())
            }
            
            assert(hexFormatted.count == 6, "Invalid hex code used.")
            
            var rgbValue: UInt64 = 0
            Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
            
            self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                      alpha: alpha)
        }
    
    static let joinTextFieldColor = UIColor(hexCode: "F6F6F6")
    static let joinButtonColor = UIColor(hexCode: "595959")
    static let buttonColor = UIColor(hexCode: "2A2A2A")
    static let locationColor = UIColor(hexCode: "2A2A2A")
    static let galleryColor = UIColor(hexCode: "191919")
    static let galleryLabelColor = UIColor(hexCode: "868686")
    static let settingCellColor = UIColor(hexCode: "262826")
    static let settingArrowColor = UIColor(hexCode: "8B8B8B")
    static let emailLoginButtonColor = UIColor(hexCode: "3E3E3E")
    static let placeHolderColor = UIColor(hexCode: "656565")
    static let brandColor = UIColor(hexCode: "9BE5AD")
    static let mainBackGroundColor = UIColor(hexCode: "191919")
    static let captionColor = UIColor(hexCode: "9E9E9E")
    static let inactiveFalseColor = UIColor(hexCode: "494E58")
    static let inactiveFalseTextColor = UIColor(hexCode: "67696F")
}

