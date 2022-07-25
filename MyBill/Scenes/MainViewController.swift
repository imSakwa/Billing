//
//  ViewController.swift
//  MyBill
//
//  Created by ChangMin on 2022/07/25.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {

    private lazy var billCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .secondarySystemBackground
    }


}

