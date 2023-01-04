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
    func request<T: Decodable>(request: APIRequest, type: T.Type, parameters: Parameters?) -> Observable<Result<T, NetworkError>>
}

final class ServiceAPICall: ServiceAPICallProtocol {

    // MARK: Private Methods

    private let session: Session

    // MARK: Initializer

    init(session: Session = .default) {
        self.session = session
    }

    // MARK: Internal Methods

    func request<T: Decodable>(request: APIRequest, type: T.Type, parameters: Parameters?) -> Observable<Result<T, NetworkError>> {
        return session.rx.request(request.method, request.url, parameters: parameters)
            .responseData()
            .flatMapLatest { response, data -> Observable<Result<T, NetworkError>> in
                let decoder = JSONDecoder()

                do {
                    return Observable<Result<T, NetworkError>>.create { observer in
                        let errorMessage = try? decoder.decode(ErrorResponse.self, from: data).error

                        if (errorMessage ?? "").isEmpty {
                            do {
                                let object = try decoder.decode(T.self, from: data)
                                debugPrint("Response: \(object)")
                                observer.onNext(.success(object))
                            } catch {
                                observer.onNext(
                                    .failure(
                                        NetworkError.decodeError(
                                            description: "Decoding the reponse to the object \(T.self) failed."
                                        )
                                    )
                                )
                            }
                        } else {
                            observer.onNext(
                                .failure(NetworkError.genericError(description: errorMessage))
                            )
                        }

                        observer.onCompleted()
                        return Disposables.create()
                    }
                }
            }
    }
}
