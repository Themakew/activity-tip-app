//
//  ActivityListingViewModel.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 29/12/22.
//

import RxRelay
import RxSwift
import RxCocoa
import UIKit
import XCoordinator

protocol ActivityListingViewModelProtocol {
    var input: ActivityListingViewModelInput { get }
    var output: ActivityListingViewModelOutput { get }
}

protocol ActivityListingViewModelInput {
    var getActivityTip: PublishRelay<Void> { get }
    var openDetailScreen: PublishRelay<Void> { get }
}

protocol ActivityListingViewModelOutput {
    var data: PublishRelay<ActivityInfoEntity> { get }
    var titleText: Driver<String> { get }
    var subTitleText: Driver<String> { get }
    var addDetailButtonTitleText: Driver<String> { get }
    var anotherTipButtonTitleText: Driver<String> { get }
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
    let openDetailScreen = PublishRelay<Void>()

    // Outputs
    let data = PublishRelay<ActivityInfoEntity>()

    let titleText: Driver<String> = .just("Are you bored?")
    let subTitleText: Driver<String> = .just("Here an exercise tip for you now")
    let addDetailButtonTitleText: Driver<String> = .just("Add Details")
    let anotherTipButtonTitleText: Driver<String> = .just("New Activity Tip")

    // MARK: - Private Properties

    private let disposeBag = DisposeBag()
    private let router: StrongRouter<ActivityListingRouter>

    private let activityData = BehaviorRelay<ActivityInfoEntity?>(value: nil)

    // MARK: - Initializer

    init(
        router: StrongRouter<ActivityListingRouter>,
        activityListingUseCase: ActivityListingUseCaseProtocol
    ) {
        self.router = router
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
                    self.activityData.accept(response)
                    self.data.accept(response)
                case let .failure(error):
                    print(error)
                }
            })
            .disposed(by: disposeBag)

        openDetailScreen
            .withLatestFrom(activityData)
            .subscribe(onNext: { [weak self] object in
                if let object {
                    self?.router.trigger(.detailScreen(object: object))
                }
            })
            .disposed(by: disposeBag)
    }
}
