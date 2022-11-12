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
//            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(32)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
    }
}
