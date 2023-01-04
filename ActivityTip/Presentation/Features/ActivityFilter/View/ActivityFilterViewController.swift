//
//  ActivityFilterViewController.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 03/01/23.
//

import UIKit
import RxSwift
import RxCocoa

final class ActivityFilterViewController: UIViewController {

    // MARK: - Private Properties

    private let viewModel: ActivityFilterViewModelProtocol
    private let disposeBag = DisposeBag()
    private let closeButton = UIButton(type: .system).apply {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintColor = .black
    }

    private let participantsLabel = UILabel(translateMask: false).apply {
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        $0.textAlignment = .left
    }

    private let participantTextField = UITextField(translateMask: false).apply {
        $0.keyboardType = .numberPad
        $0.backgroundColor = .gray.withAlphaComponent(0.1)
        $0.text = "1"
    }

    private let budgetLabel = UILabel(translateMask: false).apply {
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        $0.textAlignment = .left
    }

    private let budgetSlider = UISlider(translateMask: false).apply {
        $0.minimumValue = 0
        $0.maximumValue = 1
        $0.value = 0.5
    }

    private let sliderMinLabel = UILabel(translateMask: false).apply {
        $0.font = UIFont.boldSystemFont(ofSize: 10)
        $0.textAlignment = .left
    }

    private let sliderMaxLabel = UILabel(translateMask: false).apply {
        $0.font = UIFont.boldSystemFont(ofSize: 10)
        $0.textAlignment = .right
    }

    private let typeLabel = UILabel(translateMask: false).apply {
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        $0.textAlignment = .left
    }

    private let typePicker = UIPickerView(translateMask: false).apply {
        $0.backgroundColor = .white
    }

    private let applyButton = UIButton(type: .system).apply {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintColor = .white
        $0.backgroundColor = .blue
    }

    // MARK: - Initializers

    init(viewModel: ActivityFilterViewModelProtocol) {
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

        hideKeyboardWhenTappedAround()
    }

    // MARK: - Private Methods

    private func bindRx() {
        closeButton.rx.tap
            .bind(to: viewModel.input.dismissScreen)
            .disposed(by: disposeBag)

        applyButton.rx.tap
            .bind(to: viewModel.input.applyFilter)
            .disposed(by: disposeBag)

        viewModel.output.participantsTitleText
            .drive(participantsLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.budgetTitleText
            .drive(budgetLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.typeTitleText
            .drive(typeLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.typeTitleText
            .drive(typeLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.sliderMinTitleText
            .drive(sliderMinLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.sliderMaxTitleText
            .drive(sliderMaxLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.applyTitleText
            .drive(applyButton.rx.title(for: .normal))
            .disposed(by: disposeBag)

        viewModel.output.backButtonTitleText
            .drive(closeButton.rx.title(for: .normal))
            .disposed(by: disposeBag)

        participantTextField.rx.text
            .bind(to: viewModel.input.participantValue)
            .disposed(by: disposeBag)

        budgetSlider.rx.value
            .bind(to: viewModel.input.budgetValue)
            .disposed(by: disposeBag)

        viewModel.output.pickerViewList
            .bind(to: typePicker.rx.itemTitles) { _, item in
                return item.rawValue
            }
            .disposed(by: disposeBag)

        typePicker.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.input.activitySelectedType)
            .disposed(by: disposeBag)
    }
}

// MARK: - ViewCode Extension

extension ActivityFilterViewController: ViewCode {
    func buildViewHierarchy() {
        view.addSubview(closeButton)
        view.addSubview(participantsLabel)
        view.addSubview(participantTextField)
        view.addSubview(budgetLabel)
        view.addSubview(budgetSlider)
        view.addSubview(sliderMinLabel)
        view.addSubview(sliderMaxLabel)
        view.addSubview(typeLabel)
        view.addSubview(typePicker)
        view.addSubview(applyButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            participantsLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20),
            participantsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            participantsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            participantTextField.topAnchor.constraint(equalTo: participantsLabel.bottomAnchor, constant: 10),
            participantTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            participantTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            participantTextField.heightAnchor.constraint(equalToConstant: 30),

            budgetLabel.topAnchor.constraint(equalTo: participantTextField.bottomAnchor, constant: 20),
            budgetLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            budgetLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            budgetSlider.topAnchor.constraint(equalTo: budgetLabel.bottomAnchor, constant: 10),
            budgetSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            budgetSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            sliderMinLabel.topAnchor.constraint(equalTo: budgetSlider.bottomAnchor),
            sliderMinLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            sliderMinLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor),

            sliderMaxLabel.topAnchor.constraint(equalTo: budgetSlider.bottomAnchor),
            sliderMaxLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            sliderMaxLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),

            typeLabel.topAnchor.constraint(equalTo: sliderMinLabel.bottomAnchor, constant: 20),
            typeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            typeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            typePicker.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 10),
            typePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            typePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            applyButton.heightAnchor.constraint(equalToConstant: 30),
            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    func setupAdditionalConfiguration() {
        view.backgroundColor = .white
    }
}
