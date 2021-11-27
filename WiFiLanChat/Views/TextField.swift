//
//  TextField.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 27/11/21.
//

import UIKit

class TextField: UITextField {
    var onDeleteBackward: ((UITextField) -> Void)?
    let padding = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
    
    override func deleteBackward() {
        onDeleteBackward?(self)
        super.deleteBackward()
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
