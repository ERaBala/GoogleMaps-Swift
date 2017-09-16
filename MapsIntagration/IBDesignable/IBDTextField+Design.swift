//
//  IBDTextField+Design.swift
//  MapsIntagration
//
//  Created by Omnipro Technologies on 15/09/17.
//  Copyright © 2017 Omnipro Technologies. All rights reserved.
//

import UIKit

@IBDesignable
class IBDTextField_Design: UITextField {

    // MARK: - IBInspectable
    @IBInspectable var tintCol  : UIColor = UIColor(rgb: 0x707070)
    @IBInspectable var fontCol  : UIColor = UIColor(rgb: 0x707070)
    @IBInspectable var shadowCol: UIColor = UIColor(rgb: 0x707070)
    
    @IBInspectable var image        : UIImage? = nil
    
    @IBInspectable var placeholderText  : String?
    
    @IBInspectable var imgTopInset      : CGFloat = 7.0
    
    @IBInspectable var imgBottomInset   : CGFloat = 7.0
    
    @IBInspectable var imgLeftInset     : CGFloat = 10.0

    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = self.cornerRadius
            layer.masksToBounds = self.cornerRadius > 0
        }
    }
    
    @IBInspectable var paddingValue: CGFloat = 0
    
    
    @IBInspectable var borderColor: UIColor? = UIColor.clear {
        didSet {
            layer.borderColor = self.borderColor?.cgColor
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = self.borderWidth
        }
    }
    
    // MARK: - Properties
    var textFont = UIFont(name: "Noto Sans", size: 14.0)
    var imgView: UIImageView?
    
    // MARK: - View
    override func awakeFromNib() {
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    
    func setupView() {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowCol.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 1.0
        self.layer.shadowOffset = CGSize(width : 0.0, height: 0.0)
        self.tintColor = tintCol
        self.textColor = fontCol
        
        // email icon color #B3B3B3
        if let phText = self.placeholderText {
            self.attributedPlaceholder = NSAttributedString(string: phText, attributes: [NSForegroundColorAttributeName: UIColor(rgb: 0xB3B3B3)])
        }
        
        if let fnt = textFont {
            self.font = fnt
        } else {
            self.font = UIFont(name: "Helvetica Neue", size: 14.0)
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
    
    // Placeholder text
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        if let iView = self.imgView {
            return bounds.insetBy(dx: iView.bounds.size.width + 15, dy: 0)
        } else {
            return bounds.insetBy(dx: 10, dy: 0)
        }
        
    }
    
    // Editable text
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        if let iView = self.imgView {
            return bounds.insetBy(dx: iView.bounds.size.width + 15, dy: 0)
        } else {
            return bounds.insetBy(dx: 10, dy: 0)
        }
    }

}
