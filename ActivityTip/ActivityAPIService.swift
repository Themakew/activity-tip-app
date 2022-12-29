//
//  ActivityAPIService.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 29/12/22.
//

import Alamofire
import RxSwift

protocol ActivityAPIServiceProtocol {
    func getResponseFromActivityEndPoint() -> Single<ActivityResponse>
}

enum ActivityAPICall {
    case activity

    var path: APIRequest {
        switch self {
        case .activity:
            return APIRequest(method: .get, path: "activity/")
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

    func getResponseFromActivityEndPoint() -> Single<ActivityResponse> {
        return serviceAPI.request(request: ActivityAPICall.activity.path, type: ActivityResponse.self)
            .asSingle()
    }
}
