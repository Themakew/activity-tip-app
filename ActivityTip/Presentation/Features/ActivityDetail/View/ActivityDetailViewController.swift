//
//  ActivityDetailViewController.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 30/12/22.
//

import UIKit
import RxSwift
import RxCocoa

final class ActivityDetailViewController: UIViewController {

    // MARK: - Private Properties

    private let viewModel: ActivityDetailViewModelProtocol
    private let disposeBag = DisposeBag()

    private let activityView = ActivityView(translateMask: false).apply {
        $0.backgroundColor = .white
    }

    private let activityTipLabel = UILabel(translateMask: false).apply {
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        $0.textAlignment = .left
    }

    private let statusSegmented = UISegmentedControl(items: ["Ongoing", "Done", "Skipped"]).apply {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.selectedSegmentIndex = 1
        $0.tintColor = .white
        $0.backgroundColor = .white
    }

    private let timeLabel = UILabel(translateMask: false).apply {
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        $0.textAlignment = .left
    }

    private let timePicker = UIDatePicker(translateMask: false).apply {
        $0.datePickerMode = .countDownTimer
    }

    private let saveButton = UIButton(type: .system).apply {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintColor = .white
        $0.backgroundColor = .blue
    }

    // MARK: - Initializers

    init(viewModel: ActivityDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindRx()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.getActivityData.accept(())
    }

    // MARK: - Private Methods

    private func bindRx() {
        statusSegmented.rx.selectedSegmentIndex
            .bind(to: viewModel.input.activityStatus)
            .disposed(by: disposeBag)

        timePicker.rx.countDownDuration
            .bind(to: viewModel.input.timeIntervalValue)
            .disposed(by: disposeBag)

        saveButton.rx.tap
            .bind(to: viewModel.input.saveActivity)
            .disposed(by: disposeBag)

        viewModel.output.viewTitleText
            .drive(rx.title)
            .disposed(by: disposeBag)

        viewModel.output.activityTipText
            .drive(activityTipLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.timeText
            .drive(timeLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.saveButtonTitleText
            .drive(saveButton.rx.title(for: .normal))
            .disposed(by: disposeBag)

        viewModel.output.activityData
            .subscribe(onNext: { [weak self] data in
                if let data {
                    self?.activityView.configure(content: data)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - ViewCode Extension

extension ActivityDetailViewController: ViewCode {
    func buildViewHierarchy() {
        view.addSubview(activityView)
        view.addSubview(activityTipLabel)
        view.addSubview(statusSegmented)
        view.addSubview(timeLabel)
        view.addSubview(timePicker)
        view.addSubview(saveButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            activityView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            activityView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            activityTipLabel.topAnchor.constraint(equalTo: activityView.bottomAnchor, constant: 30),
            activityTipLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            activityTipLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),

            statusSegmented.topAnchor.constraint(equalTo: activityTipLabel.bottomAnchor, constant: 10),
            statusSegmented.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            statusSegmented.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),

            timeLabel.topAnchor.constraint(equalTo: statusSegmented.bottomAnchor, constant: 30),
            timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 15),

            timePicker.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 10),
            timePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            timePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            timePicker.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -10),

            saveButton.heightAnchor.constraint(equalToConstant: 30),
            saveButton.widthAnchor.constraint(equalToConstant: 150),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }

    func setupAdditionalConfiguration() {
        view.backgroundColor = .white
    }
}
