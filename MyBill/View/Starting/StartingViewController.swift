//
//  StartingViewController.swift
//  MyBill
//
//  Created by ChangMin on 2022/11/12.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class StartingViewController: UIViewController {
    let viewModel: StartingViewModel
    let disposeBag = DisposeBag()
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome!"
        return label
    }()
    
    private lazy var startButton: CommonButtonView = {
        let button = CommonButtonView()
        button.setTitle("시작하기", for: .normal)
//        button.isEnabled = false
        return button
    }()
    
    init(viewModel: StartingViewModel = StartingViewModel()) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bindViewModel()
    }
}

private extension StartingViewController {
    func setupView() {
        view.backgroundColor = .white
        
        [welcomeLabel, startButton].forEach { view.addSubview($0) }
        
        welcomeLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        startButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(48)
        }
    }
    
    func bindViewModel() {
        let input = StartingViewModel.Input(
//            titleText: <#T##Observable<String>#>,
//            targetAmountText: <#T##Observable<String>#>,
            startButton: startButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.start
            .subscribe(onNext: { [weak self] in
                let billListVC = BillListViewController()
                self?.navigationController?.pushViewController(billListVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
