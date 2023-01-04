//
//  ActivityDetailViewModel.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 30/12/22.
//

import RxCocoa
import RxRelay
import RxSwift
import UIKit
import XCoordinator

protocol ActivityDetailViewModelProtocol {
    var input: ActivityDetailViewModelInput { get }
    var output: ActivityDetailViewModelOutput { get }
}

protocol ActivityDetailViewModelInput {
    var getActivityData: PublishRelay<Void> { get }
    var activityStatus: PublishRelay<Int> { get }
    var timeIntervalValue: PublishRelay<TimeInterval> { get }
    var saveActivity: PublishRelay<Void> { get }
}

protocol ActivityDetailViewModelOutput {
    var activityData: BehaviorRelay<ActivityInfoEntity?> { get }
    var viewTitleText: Driver<String> { get }
    var activityTipText: Driver<String> { get }
    var timeText: Driver<String> { get }
    var saveButtonTitleText: Driver<String> { get }
    var showSuccessAlert: BehaviorRelay<AlertEntity?> { get }
}

extension ActivityDetailViewModelProtocol where Self: ActivityDetailViewModelInput & ActivityDetailViewModelOutput {
    var input: ActivityDetailViewModelInput { return self }
    var output: ActivityDetailViewModelOutput { return self }
}

final class ActivityDetailViewModel:
    ActivityDetailViewModelProtocol,
    ActivityDetailViewModelInput,
    ActivityDetailViewModelOutput {

    // MARK: - Internal Properties

    // Inputs
    let getActivityData = PublishRelay<Void>()
    let activityStatus = PublishRelay<Int>()
    let timeIntervalValue = PublishRelay<TimeInterval>()
    let saveActivity = PublishRelay<Void>()

    // Outputs
    let activityData = BehaviorRelay<ActivityInfoEntity?>(value: nil)
    let showSuccessAlert = BehaviorRelay<AlertEntity?>(value: nil)

    let viewTitleText: Driver<String> = .just("Activity Detail")
    let activityTipText: Driver<String> = .just("Enter your current status:")
    let timeText: Driver<String> = .just("Time spent on the activity:")
    let saveButtonTitleText: Driver<String> = .just("Save")

    // MARK: - Private Properties

    private let disposeBag = DisposeBag()
    private let router: WeakRouter<ActivityListingRouter>
    private let activityInfoEntity: ActivityInfoEntity
    private let activityDetailUseCase: ActivityDetailUseCaseProtocol

    private let statusOptions = ["Ongoing", "Done", "Skipped"]

    // MARK: - Initializer

    init(
        router: WeakRouter<ActivityListingRouter>,
        activityInfoEntity: ActivityInfoEntity,
        activityDetailUseCase: ActivityDetailUseCaseProtocol
    ) {
        self.router = router
        self.activityInfoEntity = activityInfoEntity
        self.activityDetailUseCase = activityDetailUseCase

        bindRx()
    }

    // MARK: - Private Methods

    private func bindRx() {
        getActivityData
            .subscribe(onNext: { [weak self] in
                self?.activityData.accept(self?.activityInfoEntity)
            })
            .disposed(by: disposeBag)

        let activityStatusData = Observable.combineLatest(activityStatus, timeIntervalValue)
        saveActivity
            .withLatestFrom(activityStatusData)
            .withUnretained(self)
            .subscribe(onNext: { this, result in
                let status = self.statusOptions[result.0]
                let time = self.stringFromTime(interval: result.1)
                let activityStatusEntity = this.activityDetailUseCase.getActivityStatusEntity(
                    basedOn: status,
                    and: time
                )

                if let activityData = this.activityData.value {
                    this.activityDetailUseCase.saveData(data: (activityData.activityInfo, activityStatusEntity))
                    this.showSuccessAlert.accept(this.getAlertEntity())
                }
            })
            .disposed(by: disposeBag)
    }

    private func stringFromTime(interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .spellOut
        formatter.allowedUnits = [.hour, .minute]
        return formatter.string(from: interval) ?? ""
    }

    private func getAlertEntity() -> AlertEntity {
        return AlertEntity(
            title: "Success",
            message: "Activity info saved",
            preferredStyle: .alert,
            actionTitle: "Ok"
        )
    }
}
