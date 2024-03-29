//
//  CustomCollectionViewFlowLayout.swift
//  MyBill
//
//  Created by ChangMin on 2022/08/15.
//

import Foundation
import UIKit

final class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(
        in rect: CGRect
    ) -> [UICollectionViewLayoutAttributes]? {
        
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        
        guard let offset = collectionView?.contentOffset,
              let stLayoutAttributes = layoutAttributes
        else {
            return layoutAttributes
        }

        if offset.y < 0 {
            for attributes in stLayoutAttributes {
                if let elmKind = attributes.representedElementKind,
                   elmKind == UICollectionView.elementKindSectionHeader {
                    
                    let height = UIScreen.main.bounds.height / 5
                    let diffValue = abs(offset.y)
                    var frame = attributes.frame
                    frame.size.height = max(0, height + diffValue)
                    frame.origin.y = frame.minY - diffValue
                    attributes.frame = frame
                }
            }
        }
        return layoutAttributes
    }
}

