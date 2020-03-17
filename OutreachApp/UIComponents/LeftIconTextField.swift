//
//  LeftIconTextField.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 15/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import UIKit

class LeftIconTextField: UITextField {

    var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }

    var imageTintColor: UIColor = Theme.Color.primaryText

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += 10
        return textRect
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let leftViewWidth = self.leftView?.bounds.width ?? 0
        let textSpacing: CGFloat = 10
        let leftViewspacing: CGFloat = self.leftView?.frame.minX ?? 0.0
        let textOffset = leftViewWidth + leftViewspacing + textSpacing
        return CGRect(origin: CGPoint(x: textOffset, y: 0), size: bounds.size)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let leftViewWidth = self.leftView?.bounds.width ?? 0.0
        let leftViewspacing: CGFloat = self.leftView?.frame.minX ?? 0.0
        let textSpacing: CGFloat = 10
        let textOffset = leftViewWidth + leftViewspacing + textSpacing
        return CGRect(origin: CGPoint(x: textOffset, y: 0), size: bounds.size)
    }

    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = imageTintColor
            leftView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }

        self.backgroundColor = UIColor.init(white: 1, alpha: 0.5)
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
    }
}
