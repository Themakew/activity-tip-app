//
//  Encodable+misc.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 29/12/22.
//

import Foundation

extension Encodable {
    func toJson() throws -> Any {
        let data = try JSONEncoder().encode(self)
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments)
    }

    func toDictionary() -> [String: Any]? {
        return (try? toJson()).flatMap { $0 as? [String: Any] }
    }
}
