//
//  MonthlyGoalViewController.swift
//  MyBill
//
//  Created by ChangMin on 2022/08/02.
//

import SnapKit
import UIKit

final class MonthlyGoalViewController: UIViewController {
    private lazy var presenter = MonthlyGoalPresenter(viewController: self)
    
    private lazy var settingButton: UIBarButtonItem = {
        let image = UIImage(named: "gearshape")
        let barButton = UIBarButtonItem(image: image, style: .plain, target: self, action: nil)
        return barButton
    }()
    
    private lazy var nameView: SettingBoxView = {
        let view = SettingBoxView()
        
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension MonthlyGoalViewController: MonthlyGoalProtocol {
    func setupNavigationBar() {
        view.backgroundColor = .systemBackground
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.navigationItem.rightBarButtonItem = settingButton
        
    }
    
    func setupLayout() {
        [nameView].forEach { view.addSubview($0) }
        
        nameView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(80)
        }
    }
}

private extension MonthlyGoalViewController {
    
}
