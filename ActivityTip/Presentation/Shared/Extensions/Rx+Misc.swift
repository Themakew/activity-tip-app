//
//  Rx+Misc.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 29/12/22.
//

import RxSwift

extension ObservableType {
    func flatMap<A: AnyObject, O: ObservableType>(weak scope: A, selector: @escaping (A, Self.Element) throws -> O) -> Observable<O.Element> {
        return flatMap { [weak scope] value -> Observable<O.Element> in
            try scope.map { try selector($0, value).asObservable() } ?? .empty()
        }
    }
}
