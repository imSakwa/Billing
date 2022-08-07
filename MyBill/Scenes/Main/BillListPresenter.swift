//
//  BillListPresenter.swift
//  MyBill
//
//  Created by ChangMin on 2022/08/02.
//

import Foundation
import UIKit

protocol BillListProtocol: AnyObject {
    func setupNavigationBar()
    func setupLayout()
    func configureCollectionDataSource()
    func configureSnapShot()
    
}

final class BillListPresenter: NSObject {
    private weak var viewController: BillListProtocol?
    
    init(viewController: BillListProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        viewController?.setupNavigationBar()
        viewController?.configureCollectionDataSource()
        viewController?.configureSnapShot()
        viewController?.setupLayout()
    }
}

extension BillListPresenter: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {

    }
}

extension BillListPresenter: UICollectionViewDelegateFlowLayout {
    // 셀 크기
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = UIScreen.main.bounds.width - 32
        return CGSize(width: width, height: 150)
    }
    
    // 셀간 간격
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 35
    }
}

