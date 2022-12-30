//
//  UIView+Misc.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 30/12/22.
//

import UIKit

extension UIView {
    convenience init(translateMask: Bool) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = translateMask
    }
}
