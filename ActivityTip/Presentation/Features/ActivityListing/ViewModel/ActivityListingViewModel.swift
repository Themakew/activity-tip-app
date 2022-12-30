//
//  ActivityListingViewModel.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 29/12/22.
//

import RxRelay
import RxSwift
import UIKit

protocol ActivityListingViewModelProtocol {
    var input: ActivityListingViewModelInput { get }
    var output: ActivityListingViewModelOutput { get }
}

protocol ActivityListingViewModelInput {
    var getActivityTip: PublishRelay<Void> { get }
}

protocol ActivityListingViewModelOutput {

}

extension ActivityListingViewModelProtocol where Self: ActivityListingViewModelInput & ActivityListingViewModelOutput {
    var input: ActivityListingViewModelInput { return self }
    var output: ActivityListingViewModelOutput { return self }
}

final class ActivityListingViewModel:
    ActivityListingViewModelProtocol,
    ActivityListingViewModelInput,
    ActivityListingViewModelOutput {

    let activityListingUseCase: ActivityListingUseCaseProtocol

    let getActivityTip = PublishRelay<Void>()

    private let disposeBag = DisposeBag()

    init(
        activityListingUseCase: ActivityListingUseCaseProtocol
    ) {
        self.activityListingUseCase = activityListingUseCase

        bindRx()
    }

    func bindRx() {
        let responseResultObservable = getActivityTip
            .flatMap(weak: self) { this, _ -> Observable<Result<ActivityResponse, NetworkError>> in
                return this.activityListingUseCase.getActivityTip()
                    .asObservable()
            }
            .share()

        responseResultObservable
            .withUnretained(self)
            .subscribe(onNext: { this, result in
                switch result {
                case let .success(response):
                    print(response)
                case let .failure(error):
                    print(error)
                }
            })
            .disposed(by: disposeBag)
    }

}
