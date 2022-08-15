//
//  ViewController.swift
//  MyBill
//
//  Created by ChangMin on 2022/07/25.
//

import UIKit
import SnapKit

final class BillListViewController: UIViewController {
    private lazy var presenter = BillListPresenter(viewController: self)
    private var dataSource: UICollectionViewDiffableDataSource<Int ,Bill>!
    private var billList: [Bill] = [
        Bill(title: "첫번째", cost: 1000, memo: "메모", date: "없음"),
        Bill(title: "두번째", cost: 1000, memo: "메모", date: "없음"),
        Bill(title: "세번째", cost: 1000, memo: "메모", date: "없음"),
        Bill(title: "네번째", cost: 1000, memo: "메모", date: "없음"),
        Bill(title: "오번째", cost: 1000, memo: "메모", date: "없음"),
        Bill(title: "육번째", cost: 1000, memo: "메모", date: "없음")
    ]
        
    private lazy var billCollectionView: UICollectionView = {
        let flowLayout = CustomCollectionViewFlowLayout()
        flowLayout.sectionHeadersPinToVisibleBounds = false
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.delegate = presenter
        collectionView.dataSource = dataSource
        collectionView.register(BillInfoCollectionCell.self, forCellWithReuseIdentifier: BillInfoCollectionCell.identifier)
        collectionView.register(BillInfoCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BillInfoCollectionHeaderView.identifier)
        collectionView.backgroundColor = .yellow
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
}

extension BillListViewController: BillListProtocol {
    func setupNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
         
        view.backgroundColor = .secondarySystemBackground
    }
    
    func setupLayout() {
        [billCollectionView].forEach { view.addSubview($0) }
                
        billCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configureCollectionDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: billCollectionView) { [weak self] collectionView, indexPath, itemIdentifier -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BillInfoCollectionCell.identifier, for: indexPath) as? BillInfoCollectionCell else { return UICollectionViewCell() }
            
            cell.backgroundColor = .brown
            cell.setupCell(bill: (self?.billList[indexPath.row])!)
            return cell
        }
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: BillInfoCollectionHeaderView.identifier,
                for: indexPath
            ) as? BillInfoCollectionHeaderView else {
                fatalError("Could not dequeue sectionHeader: \(BillInfoCollectionHeaderView.identifier)")
            }
            sectionHeader.delegate = self

            sectionHeader.backgroundColor = .green
            return sectionHeader
         }
    }
    
    func configureSnapShot() {
        // snapshot 생성
        var snapshot = NSDiffableDataSourceSnapshot<Int, Bill>()

        // snapshot에 data 추가
        snapshot.appendSections([0])
        snapshot.appendItems(billList)

        // snapshot 반영
        dataSource.apply(snapshot, animatingDifferences: true)
    }

}

private extension BillListViewController {
    
}

extension BillListViewController: BillInfoHeaderDelegate {
    func tapSettingButton() {
        let goalVC = MonthlyGoalViewController()
        
        self.navigationController?.pushViewController(goalVC, animated: true)
    }
}
