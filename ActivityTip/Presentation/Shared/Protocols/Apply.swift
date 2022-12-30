//
//  Apply.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 30/12/22.
//

import UIKit.UIGeometry

protocol Apply {}

extension Apply where Self: Any {
    /// Makes it available to set properties with closures just after initializing
    ///
    ///     let label = UILabel().apply {
    ///         $0.textAligment = .center
    ///         $0.textColor = .blank
    ///         $0.text = "Hello, World!"
    ///     }

    @discardableResult
    func apply(_ block: (Self) -> Void) -> Self {
        // https://github.com/devxoul/Then
        block(self)
        return self
    }
}

extension UIEdgeInsets: Apply {}
extension UIOffset: Apply {}
extension UIRectEdge: Apply {}
extension Array: Apply {}
extension Dictionary: Apply {}
extension Set: Apply {}
extension JSONDecoder: Apply {}
extension JSONEncoder: Apply {}
extension NSObject: Apply {}
