//
//  ActivityAPIService.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 29/12/22.
//

import Alamofire
import RxSwift

protocol ActivityAPIServiceProtocol {
    func getResponseFromActivityEndPoint() -> Single<Result<ActivityResponse, NetworkError>>
}

enum ActivityAPICall {
    case activity

    var path: APIRequest {
        switch self {
        case .activity:
            return APIRequest(method: .get, path: "activity")
        }
    }
}

final class ActivityAPIService: ActivityAPIServiceProtocol {

    // MARK: Private Property

    private let serviceAPI: ServiceAPICallProtocol

    // MARK: Initializer

    init(serviceAPI: ServiceAPICallProtocol) {
        self.serviceAPI = serviceAPI
    }

    // MARK: Internal Methods

    func getResponseFromActivityEndPoint() -> Single<Result<ActivityResponse, NetworkError>> {
        return serviceAPI.request(request: ActivityAPICall.activity.path, type: ActivityResponse.self)
            .asSingle()
    }
}
