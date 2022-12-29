//
//  ServiceAPICall.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 29/12/22.
//

import Alamofire
import Foundation
import RxAlamofire
import RxSwift

protocol ServiceAPICallProtocol {
    func request<T: Decodable>(request: APIRequest, type: T.Type) -> Observable<T>
}

final class ServiceAPICall: ServiceAPICallProtocol {

    // MARK: Private Methods

    private let session: Session

    // MARK: Initializer

    init(session: Session = .default) {
        self.session = session
    }

    // MARK: Internal Methods

    func request<T: Decodable>(request: APIRequest, type: T.Type) -> Observable<T> {
        return session.rx.request(request.method, request.url)
            .responseData()
            .map { response, data -> Data in
                return data
            }
            .flatMapLatest { data -> Observable<T> in
                let decoder = JSONDecoder()

                do {
                    return Observable<T>.create { observer in
                        do {
                            let object = try decoder.decode(T.self, from: data)
                            observer.onNext(object)
                            observer.onCompleted()
                        } catch {
                            observer.onError(error)
                        }

                        return Disposables.create()
                    }
                }
            }.catch { error in
                print("❌ - Finished With Error")
                print("Message - \(error)")

                throw error
            }
    }
}
