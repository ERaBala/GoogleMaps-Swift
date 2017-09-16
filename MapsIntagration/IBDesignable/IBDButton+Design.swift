//
//  IBDButton+Design.swift
//  MapsIntagration
//
//  Created by Omnipro Technologies on 15/09/17.
//  Copyright © 2017 Omnipro Technologies. All rights reserved.
//

import UIKit

@IBDesignable
class IBDButton_Design: UIButton {

    // MARK: - Inspectables
    @IBInspectable var colorCode: Int = 0 {
        didSet {
            self.backgroundColor = setColor(colorCode: colorCode)
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 3.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var fontColor: UIColor = .white {
        didSet {
            self.tintColor = fontColor
        }
    }
    
    @IBInspectable var image: UIImage?
    
    @IBInspectable var imgLeftInset: CGFloat = 10.0
    
    @IBInspectable var imgTopInset: CGFloat = 7.0
    
    @IBInspectable var imgBottomInset: CGFloat = 7.0
    
    
    // MARK: - Properties
    var buttonFont: String = "Noto Sans"
    var imgView: UIImageView?
    
    
    // MARK: - View
    override func awakeFromNib() {
        self.setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
    
    func setupView() {
        self.backgroundColor = setColor(colorCode: colorCode)
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        
        if let font = UIFont(name: buttonFont, size: 14.0) {
            self.titleLabel?.font = font
        } else {
            self.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
        }
        
        self.setNeedsLayout()
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if self.image != nil {
            self.imgView = UIImageView(frame: CGRect(origin: CGPoint(x: self.imgLeftInset,y :self.imgTopInset), size: CGSize(width: self.bounds.height - (self.imgTopInset + self.imgBottomInset), height: self.bounds.height - (self.imgTopInset + imgBottomInset))))
            
            self.imgView!.contentMode = .scaleAspectFit
            self.imgView!.image = self.image
            self.addSubview(self.imgView!)
            
        }
    }
    
    
    //MARK: - Methods
    func setColor(colorCode: Int) -> UIColor {
        
        switch (colorCode) {
            
        case 1:
            return UIColor(rgb: 0x1FC299)
        case 2:
            return UIColor(rgb: 0xE9AA31)
        case 3:
            return UIColor(rgb: 0xF68A68)
        case 4:
            return UIColor(rgb: 0xB86044)
        case 5:
            return UIColor(rgb: 0x903E11)
        case 6:
            return UIColor(rgb: 0x3B5998)
        case 7:
            return UIColor(rgb: 0x000000)
        case 8:
            return UIColor(rgb: 0xFFFFFF)
        case 9:
            return UIColor(rgb: 0x707070)
        case 10 :
            return UIColor(rgb: 0xF3C613)
        default:
            return UIColor(rgb: 0xD8471E)
        }
    }
    

}
