//
//  ActivityFilterViewModel.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 03/01/23.
//

import RxRelay
import RxSwift
import RxCocoa
import UIKit
import XCoordinator

protocol ActivityFilterViewModelProtocol {
    var input: ActivityFilterViewModelInput { get }
    var output: ActivityFilterViewModelOutput { get }
}

protocol ActivityFilterViewModelInput {
    var dismissScreen: PublishRelay<Void> { get }
    var participantValue: BehaviorRelay<String?> { get }
    var budgetValue: BehaviorRelay<Float?> { get }
    var activitySelectedType: BehaviorRelay<Int> { get }
    var applyFilter: PublishRelay<Void> { get }
}

protocol ActivityFilterViewModelOutput {
    var backButtonTitleText: Driver<String> { get }
    var participantsTitleText: Driver<String> { get }
    var budgetTitleText: Driver<String> { get }
    var typeTitleText: Driver<String> { get }
    var applyTitleText: Driver<String> { get }
    var sliderMinTitleText: Driver<String> { get }
    var sliderMaxTitleText: Driver<String> { get }
    var filterApplied: BehaviorRelay<ActivityFilter?> { get }
    var pickerViewList: BehaviorRelay<[ActivityType]> { get }
    var activityType: BehaviorRelay<ActivityType> { get }
}

extension ActivityFilterViewModelProtocol where Self: ActivityFilterViewModelInput & ActivityFilterViewModelOutput {
    var input: ActivityFilterViewModelInput { return self }
    var output: ActivityFilterViewModelOutput { return self }
}

final class ActivityFilterViewModel:
    ActivityFilterViewModelProtocol,
    ActivityFilterViewModelInput,
    ActivityFilterViewModelOutput {

    // MARK: - Internal Properties

    // Inputs
    let dismissScreen = PublishRelay<Void>()
    let applyFilter = PublishRelay<Void>()

    let participantValue = BehaviorRelay<String?>(value: nil)
    let budgetValue = BehaviorRelay<Float?>(value: nil)
    let activitySelectedType = BehaviorRelay<Int>(value: 0)

    // Outputs
    let backButtonTitleText: Driver<String> = .just("Close")
    let participantsTitleText: Driver<String> = .just("Participants:")
    let budgetTitleText: Driver<String> = .just("Budget:")
    let typeTitleText: Driver<String> = .just("Type:")
    let applyTitleText: Driver<String> = .just("Apply")
    let sliderMinTitleText: Driver<String> = .just("Cheap")
    let sliderMaxTitleText: Driver<String> = .just("Expensive")

    let filterApplied = BehaviorRelay<ActivityFilter?>(value: nil)
    let pickerViewList = BehaviorRelay<[ActivityType]>(value: ActivityType.allCases)
    let activityType = BehaviorRelay<ActivityType>(value: .education)

    // MARK: - Private Properties

    private let disposeBag = DisposeBag()
    private let router: WeakRouter<ActivityListingRouter>

    // MARK: - Initializer

    init(router: WeakRouter<ActivityListingRouter>) {
        self.router = router

        bindRx()
    }

    // MARK: - Private Methods

    private func bindRx() {
        dismissScreen
            .subscribe(onNext: { [weak self] in
                self?.router.trigger(.dismiss)
            })
            .disposed(by: disposeBag)

        let pickerObservers = Observable.combineLatest(activitySelectedType, pickerViewList)
        activitySelectedType
            .withLatestFrom(pickerObservers)
            .subscribe(onNext: { [weak self] result in
                let selectedType = result.1[result.0]
                self?.activityType.accept(selectedType)
            })
            .disposed(by: disposeBag)

        let filter = Observable.combineLatest(participantValue.map { Int($0 ?? "") }, budgetValue, activityType)
        applyFilter
            .withLatestFrom(filter)
            .map { filter -> ActivityFilter in
                return ActivityFilter(numberOfParticipants: filter.0, budgetNumber: filter.1, type: filter.2)
            }
            .bind(to: filterApplied)
            .disposed(by: disposeBag)
    }
}
