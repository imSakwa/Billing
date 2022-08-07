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
        Bill(title: "두번째", cost: 1000, memo: "메모", date: "없음")
    ]
    
    private lazy var billCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = presenter
        collectionView.dataSource = dataSource
        collectionView.register(BillInfoCollectionCell.self, forCellWithReuseIdentifier: BillInfoCollectionCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension BillListViewController: BillListProtocol {
    func setupNavigationBar() {
        view.backgroundColor = .secondarySystemBackground
    }
    
    func setupLayout() {
        view.addSubview(billCollectionView)
        
        billCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureCollectionDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: billCollectionView) { [weak self] collectionView, indexPath, itemIdentifier -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BillInfoCollectionCell.identifier, for: indexPath) as? BillInfoCollectionCell else { return UICollectionViewCell() }
            
            cell.backgroundColor = .brown
            cell.setupCell(bill: (self?.billList[indexPath.row])!)
            return cell
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
