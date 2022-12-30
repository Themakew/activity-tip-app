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
    var data: PublishRelay<ActivityInfoEntity> { get }
}

extension ActivityListingViewModelProtocol where Self: ActivityListingViewModelInput & ActivityListingViewModelOutput {
    var input: ActivityListingViewModelInput { return self }
    var output: ActivityListingViewModelOutput { return self }
}

final class ActivityListingViewModel:
    ActivityListingViewModelProtocol,
    ActivityListingViewModelInput,
    ActivityListingViewModelOutput {

    // MARK: - Internal Properties

    let activityListingUseCase: ActivityListingUseCaseProtocol

    // Inputs
    let getActivityTip = PublishRelay<Void>()

    // Outputs
    let data = PublishRelay<ActivityInfoEntity>()

    // MARK: - Private Properties

    private let disposeBag = DisposeBag()

    // MARK: - Initializer

    init(
        activityListingUseCase: ActivityListingUseCaseProtocol
    ) {
        self.activityListingUseCase = activityListingUseCase

        bindRx()
    }

    // MARK: - Private Methods

    private func bindRx() {
        let responseResultObservable = getActivityTip
            .flatMap(weak: self) { this, _ -> Observable<Result<ActivityInfoEntity, NetworkError>> in
                return this.activityListingUseCase.getActivityTip()
                    .asObservable()
            }
            .share()

        responseResultObservable
            .withUnretained(self)
            .subscribe(onNext: { this, result in
                switch result {
                case let .success(response):
                    self.data.accept(response)
                case let .failure(error):
                    print(error)
                }
            })
            .disposed(by: disposeBag)
    }
}
