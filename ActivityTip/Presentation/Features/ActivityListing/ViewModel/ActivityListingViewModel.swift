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
    var openFilterScreen: PublishRelay<Void> { get }
}

protocol ActivityListingViewModelOutput {
    var data: PublishRelay<ActivityInfoEntity> { get }
    var titleText: Driver<String> { get }
    var subTitleText: Driver<String> { get }
    var addDetailButtonTitleText: Driver<String> { get }
    var anotherTipButtonTitleText: Driver<String> { get }
    var errorMessageLabelText: Driver<String> { get }
    var setErrorAlert: PublishRelay<Void> { get }
    var filterNavButtonTitleText: BehaviorRelay<String> { get }
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
    let openFilterScreen = PublishRelay<Void>()

    // Outputs
    let data = PublishRelay<ActivityInfoEntity>()
    let setErrorAlert = PublishRelay<Void>()

    let titleText: Driver<String> = .just("Are you bored?")
    let subTitleText: Driver<String> = .just("Here an exercise tip for you now")
    let addDetailButtonTitleText: Driver<String> = .just("Add Details")
    let anotherTipButtonTitleText: Driver<String> = .just("New Activity Tip")
    let errorMessageLabelText: Driver<String> = .just("No activity Found. Tip: try to clear the filters")

    var filterNavButtonTitleText = BehaviorRelay<String>(value: "Filter")

    // MARK: - Private Properties

    private let disposeBag = DisposeBag()
    private let router: WeakRouter<ActivityListingRouter>

    private let activityData = BehaviorRelay<ActivityInfoEntity?>(value: nil)
    private let filter = BehaviorRelay<ActivityFilter?>(value: nil)

    // MARK: - Initializer

    init(
        router: WeakRouter<ActivityListingRouter>,
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
                return this.activityListingUseCase.getActivityTip(parameters: this.filter.value)
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
                case .failure(_):
                    self.setErrorAlert.accept(())
                }
            })
            .disposed(by: disposeBag)

        filter
            .skip(1)
            .map { _ in () }
            .bind(to: getActivityTip)
            .disposed(by: disposeBag)

        openDetailScreen
            .withLatestFrom(activityData)
            .subscribe(onNext: { [weak self] object in
                if let object {
                    self?.router.trigger(.detailScreen(object: object))
                }
            })
            .disposed(by: disposeBag)

        openFilterScreen
            .withLatestFrom(filter)
            .subscribe(onNext: { [weak self] object in
                if object == nil {
                    guard let self else {
                        return
                    }

                    let viewModel = ActivityFilterViewModel(router: self.router)

                    viewModel.filterApplied
                        .bind(to: self.filter)
                        .disposed(by: self.disposeBag)

                    self.router.trigger(.filterScreen(viewModel: viewModel))
                }
            })
            .disposed(by: disposeBag)

        openFilterScreen
            .withLatestFrom(filter)
            .subscribe(onNext: { [weak self] object in
                if object != nil {
                    self?.filter.accept(nil)
                }
            })
            .disposed(by: disposeBag)

        filter
            .subscribe(onNext: { [weak self] object in
                if object == nil {
                    self?.filterNavButtonTitleText.accept("Filter")
                } else {
                    self?.filterNavButtonTitleText.accept("Clear Filter")
                }
            })
            .disposed(by: disposeBag)
    }
}
