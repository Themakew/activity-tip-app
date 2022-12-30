//
//  Configurable.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 30/12/22.
//

protocol Configurable {
    associatedtype Configuration

    func configure(content: Configuration)
}
