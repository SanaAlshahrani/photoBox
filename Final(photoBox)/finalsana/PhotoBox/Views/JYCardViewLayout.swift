//
//  JYCardViewLayout.swift
//  JYCardView
//
//  Created by Sana Alshahrani on 20/04/1443 AH.
//

import UIKit

class JYCardViewLayout: UICollectionViewLayout {

    var cachedAttributes: [UICollectionViewLayoutAttributes] = []
    var contentBounds: CGRect!
  
    var lineSpacing: CGFloat = 15
 
    var interitemSpacing: CGFloat = 15
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        cachedAttributes.removeAll()
        contentBounds = CGRect(origin: .zero, size: collectionView.bounds.size)
        
        let count = collectionView.numberOfItems(inSection: 0)
        var currentIndex = 0
        
        while currentIndex < count {
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: currentIndex, section: 0))
            attributes.frame = collectionView.bounds
            
           
            let width = collectionView.bounds.width - CGFloat(currentIndex) * lineSpacing * 2.0
            let height = collectionView.bounds.height - CGFloat(currentIndex) * interitemSpacing * 2.0
       
            let scaleX = width / attributes.bounds.width
            let scaleY = height / attributes.bounds.height
            
            if height > 0 {
            let scaleTransform = CGAffineTransform(scaleX: scaleX, y: scaleY)
            let transform = scaleTransform.translatedBy(x: 0, y: CGFloat(currentIndex) * interitemSpacing * 2.0)
            
            attributes.transform = transform
            }
            cachedAttributes.insert(attributes, at: 0)

            if currentIndex == 0 {
                attributes.transform = .identity
            }
            
            currentIndex += 1
        }
    }
    
    override var collectionViewContentSize: CGSize {
        contentBounds.size
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cachedAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cachedAttributes[indexPath.item]
    }
    
    
}
