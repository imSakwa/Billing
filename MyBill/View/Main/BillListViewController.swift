//
//  ViewController.swift
//  MyBill
//
//  Created by ChangMin on 2022/07/25.
//

import UIKit

import RealmSwift
import SnapKit

final class BillListViewController: UIViewController {
    private lazy var presenter = BillListPresenter(viewController: self)
    private var dataSource: UICollectionViewDiffableDataSource<Info ,Bill>!
    private var billList: [Bill] = []
    private var info: Info = Info(name: "", amount: "")
    let realm = try! Realm()
        
    private lazy var billCollectionView: UICollectionView = {
        let flowLayout = CustomCollectionViewFlowLayout()
        flowLayout.sectionHeadersPinToVisibleBounds = false
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.delegate = presenter
        collectionView.dataSource = dataSource
        collectionView.register(BillInfoCollectionCell.self, forCellWithReuseIdentifier: BillInfoCollectionCell.identifier)
        collectionView.register(BillInfoCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BillInfoCollectionHeaderView.identifier)
        collectionView.backgroundColor = .systemGray6
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        readRealm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getBillList()
    }
    
}

extension BillListViewController: BillListProtocol {
    func setupNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
         
        view.backgroundColor = .systemGray6
    }
    
    func setupLayout() {
        [billCollectionView].forEach { view.addSubview($0) }
                
        billCollectionView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    func configureCollectionDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: billCollectionView) { [weak self] collectionView, indexPath, itemIdentifier -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BillInfoCollectionCell.identifier,
                for: indexPath
            ) as? BillInfoCollectionCell else { return UICollectionViewCell() }
            
            cell.backgroundColor = .systemGray3
            cell.layer.borderColor = UIColor.systemGray.cgColor
            cell.layer.borderWidth = 1
            cell.setupCell(bill: (self?.billList[indexPath.row])!)
            
            return cell
        }
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) in
            
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: BillInfoCollectionHeaderView.identifier,
                for: indexPath
            ) as? BillInfoCollectionHeaderView else { fatalError() }
            
            sectionHeader.delegate = self
            sectionHeader.backgroundColor = .systemGray6
            sectionHeader.nameLabel.text = self?.dataSource.snapshot().sectionIdentifiers[0].name
            sectionHeader.balanceLabel.text = self?.dataSource.snapshot().sectionIdentifiers[0].amount
            
            return sectionHeader
         }
    }
    
    func configureSnapShot() {
        // snapshot 생성
        var snapshot = NSDiffableDataSourceSnapshot<Info, Bill>()

        // snapshot에 data 추가
        let name = UserDefaults.standard.value(forKey: "name") as? String ?? ""
        let amount = UserDefaults.standard.value(forKey: "cost") as? String ?? ""
        info = Info(name: name, amount: amount)
        snapshot.appendSections([info])
        snapshot.appendItems(billList)

        // snapshot 반영
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

private extension BillListViewController {
    func getBillList() {
        APIService.getBillList() { [weak self] result in
            switch result {
            case .success(let data):
                AppDelegate().NSLog("%@", data)
                
                self?.billList = data
                self?.configureSnapShot()
                self?.createRealm(data: data)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func createRealm(data: [Bill]) {
        try! realm.write {
            realm.deleteAll()
        }
        
        for bill in data {
            let billObject = BillObject(
                title: bill.title,
                cost: bill.cost,
                memo: bill.memo,
                date: bill.date
            )
            
            try! realm.write {
                realm.add(billObject)
            }
        }
    }
    
    func readRealm() {
        let billObject = realm.objects(BillObject.self)
        
        for bill in billObject {
            billList.append(Bill(title: bill.title, cost: bill.cost, memo: bill.memo, date: bill.date))
        }
        configureSnapShot()
        
    }
}

extension BillListViewController: BillInfoHeaderDelegate {
    func tapSettingButton() {
        let goalVC = MonthlyGoalViewController()
        goalVC.completionHandler = { [weak self] in
            
            // TODO: billCollectionView 헤더 갱신해주기
//            self?.dataSource.appl
            self?.configureSnapShot()
        }
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .buttonColor
        navigationItem.backBarButtonItem = backBarButtonItem
        
        navigationController?.pushViewController(goalVC, animated: true)
    }
    
    func tapAddButton() {
        let addBillVC = AddBillViewController()
        addBillVC.delegate = self
        
        // TODO: 추가 후 갱신
        present(addBillVC, animated: true) { [weak self] in
            print("addBill close")
        }
    }
}

extension BillListViewController: AddBillDelegate {
    func updateBillList() {
        getBillList()
    }
}
