//
//  RainforestCollectionViewLayout.swift
//  LayersCollectionViewPlayground
//
//  Created by René Cacheaux on 10/1/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import Foundation


// NOTE: This custom layout is built specifically for the AsyncDisplayKit tutorial. If you would like
//  to use this layout outside this project you may end up needing to make modifications. 
//  However, this code is a good starting point.

protocol RainforestLayoutMetrics {
  func numberOfRowsForNumberOfItems(numberOfItems: Int) -> Int
  func rowForItemAtIndex(index: Int) -> Int
  func columnForItemAtIndex(index: Int) -> Int
  func indexForItemAboveItemAtIndex(index: Int) -> Int
  func numberOfColumns() -> Int
}

class TwoColumnLayoutMetrics: RainforestLayoutMetrics {
  func numberOfRowsForNumberOfItems(numberOfItems: Int) -> Int {
    let isOdd: Bool = numberOfItems%2 > 0
    var numberOfRows = numberOfItems/2
    if isOdd {
      numberOfRows += 1
    }
    return numberOfRows
  }
  
  func rowForItemAtIndex(index: Int) -> Int {
    return ((index + 1)/2 + (index + 1)%2) - 1
  }
  
  func columnForItemAtIndex(index: Int) -> Int {
    return index%2
  }
  
  func indexForItemAboveItemAtIndex(index: Int) -> Int {
    let aboveItemIndex = index - 2
    return aboveItemIndex >= 0 ? aboveItemIndex : index
  }
  
  func numberOfColumns() -> Int {
    return 2
  }
}

class OneColumnLayoutMetrics: RainforestLayoutMetrics {
  func numberOfRowsForNumberOfItems(numberOfItems: Int) -> Int {
    return numberOfItems
  }
  
  func rowForItemAtIndex(index: Int) -> Int {
    return index
  }
  
  func columnForItemAtIndex(index: Int) -> Int {
    return 0
  }
  
  func indexForItemAboveItemAtIndex(index: Int) -> Int {
    let aboveItemIndex = index - 1
    return aboveItemIndex >= 0 ? aboveItemIndex : index
  }
  
  func numberOfColumns() -> Int {
    return 1
  }
}

enum RainforestLayoutType {
  case OneColumn
  case TwoColumn
  
  func metrics() -> RainforestLayoutMetrics {
    switch self {
    case .OneColumn:
      return OneColumnLayoutMetrics()
    case .TwoColumn:
      return TwoColumnLayoutMetrics()
    }
  }
}

class RainforestCollectionViewLayout: UICollectionViewLayout {
  var allLayoutAttributes = [UICollectionViewLayoutAttributes]()
  let cellDefaultHeight = 300
  let cellWidth = Int(FrameCalculator.cardWidth)
  let interCellVerticalSpacing = 10
  let interCellHorizontalSpacing = 10
  var contentMaxY: CGFloat = 0
  var layoutType: RainforestLayoutType
  var layoutMetrics: RainforestLayoutMetrics
  
   init(type: RainforestLayoutType) {
    layoutType = type
    layoutMetrics = type.metrics()
    super.init()
  }
  
  override init() {
    layoutType = .TwoColumn
    layoutMetrics = layoutType.metrics()
    super.init()
  }
  
  required init(coder aDecoder: NSCoder) {
    layoutType = .TwoColumn
    layoutMetrics = layoutType.metrics()
    super.init(coder: aDecoder)!
  }
  
  override func prepare() {
    super.prepare()
    if allLayoutAttributes.count == 0 {
      if let collectionView = self.collectionView {
        if collectionView.frame.size.width < CGFloat((self.cellWidth * 2) + interCellHorizontalSpacing) {
          layoutType = .OneColumn
          layoutMetrics = layoutType.metrics()
        }
      }
      populateLayoutAttributes()
    }
  }
  
  func populateLayoutAttributes() {
    if self.collectionView == nil {
      return
    }
    let collectionView = self.collectionView!
    
    // Calculate left margin max x.
    let totalWidthOfCellsInARow = layoutMetrics.numberOfColumns() * cellWidth
    let totalSpaceBetweenCellsInARow = interCellHorizontalSpacing * max(0, layoutMetrics.numberOfColumns() - 1)
    let totalCellAndSpaceWidth = totalWidthOfCellsInARow + totalSpaceBetweenCellsInARow
    let totalHorizontalMargin = collectionView.frame.size.width - CGFloat(totalCellAndSpaceWidth)
    let leftMarginMaxX = totalHorizontalMargin / CGFloat(2.0)
    
    allLayoutAttributes.removeAll(keepingCapacity: true)
    for i in 0 ..< collectionView.numberOfItems(inSection: 0) {
      let la = UICollectionViewLayoutAttributes(forCellWith: IndexPath.init(item: i, section: 0))
      let row = layoutMetrics.rowForItemAtIndex(index: i)
      let column = layoutMetrics.columnForItemAtIndex(index: i)
      let x = ((cellWidth + interCellHorizontalSpacing) * column) + Int(leftMarginMaxX)
      let y = (row * cellDefaultHeight) + (interCellVerticalSpacing * (row + 1))

      la.frame = CGRect(x: x, y: y, width: cellWidth, height: cellDefaultHeight)
      allLayoutAttributes.append(la)
      if la.frame.maxY > contentMaxY {
        contentMaxY = ceil(la.frame.maxY)
      }
    }
  }
  
    
    override var collectionViewContentSize: CGSize{
        get{
            if self.collectionView == nil {
                return CGSize.zero
            }
            let collectionView = self.collectionView!
            return CGSize(width: collectionView.frame.size.width, height: contentMaxY)
        }
    }
//  override func collectionViewContentSize() -> CGSize {
//    if self.collectionView == nil {
//      return CGSize.zero
//    }
//    let collectionView = self.collectionView!
//    return CGSize(width: collectionView.frame.size.width, height: contentMaxY)
//  }
  
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for i in 0 ..< allLayoutAttributes.count {
            let la = allLayoutAttributes[i]
            if rect.contains(la.frame) {
                layoutAttributes.append(la)
            }
        }
        return allLayoutAttributes
    }
  
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if indexPath.item >= allLayoutAttributes.count { return nil }
        return allLayoutAttributes[indexPath.item]
    }
  
  override func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes,
      withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {
    return true
  }
  
  override func invalidationContext(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes,
      withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutInvalidationContext {
    let indexForItemAbove = layoutMetrics.indexForItemAboveItemAtIndex(index: originalAttributes.indexPath.item)
    let layoutAttributesForItemAbove = allLayoutAttributes[indexForItemAbove]
    
    if originalAttributes.indexPath.item != indexForItemAbove {
      preferredAttributes.frame.origin.y = layoutAttributesForItemAbove.frame.maxY + CGFloat(interCellVerticalSpacing)
    } else {
      preferredAttributes.frame.origin.y = 0
    }
    
    allLayoutAttributes[originalAttributes.indexPath.item] = preferredAttributes
    
    let invalidationContext = super.invalidationContext(forPreferredLayoutAttributes: preferredAttributes, withOriginalAttributes: originalAttributes)
    invalidationContext.invalidateItems(at: [originalAttributes.indexPath])
    
    if preferredAttributes.frame.maxY > contentMaxY {
     invalidationContext.contentSizeAdjustment = CGSize(width: 0, height: preferredAttributes.frame.maxY - contentMaxY)
      contentMaxY = ceil(preferredAttributes.frame.maxY)
    }
    
    return invalidationContext
  }
}
