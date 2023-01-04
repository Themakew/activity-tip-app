//
//  Float+Misc.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 04/01/23.
//

extension Float {
    func toOneDecimal() -> Float{
        let stringValue = String(format: "%.1f", self)
        return Float(stringValue) ?? 0
    }
}
