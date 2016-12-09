//
//  TestCollectionViewController.swift
//  Layers
//
//  Created by 夏路遥 on 2016/11/10.
//  Copyright © 2016年 Razeware LLC. All rights reserved.
//

import Foundation

class TestCollectionViewController : UIViewController , ASCollectionDataSource, ASCollectionDelegate{
    let rainforestCardsInfo = getAllCardInfo()
    var collectionNode : ASCollectionNode?
    
    deinit{
        self.collectionNode?.dataSource = nil
        self.collectionNode?.delegate = nil
    }
    
    override func viewDidLoad() {
        
        let layout = UICollectionViewFlowLayout()
//        let layout = TestLayout()
        
        self.collectionNode = ASCollectionNode.init(frame: self.view.frame, collectionViewLayout: layout)
        self.collectionNode?.dataSource = self
        self.collectionNode?.delegate = self
        
        self.view.addSubnode(self.collectionNode!)
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return rainforestCardsInfo.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        return TestCollectionCellNode(data: rainforestCardsInfo[indexPath.item]);
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRangeMake(CGSize.init(width: 150.0, height: 250.0), CGSize.init(width: 150.0, height: 600.0))
    }

    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
}
//
//    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
//        return ASSizeRangeMake(CGSize.init(width: 150.0, height: 250.0), CGSize.init(width: 155.0, height: 500.0))
//    }
//}
//
class TestLayout: RainforestCollectionViewLayout, ASCollectionViewLayoutInspecting {
    
    func collectionView(_ collectionView: ASCollectionView, constrainedSizeForNodeAt indexPath: IndexPath) -> ASSizeRange {
//        return ASSizeRangeMake(self.collectionViewContentSize)
        return ASSizeRange.init(min: CGSize.init(width: 150.0, height: 250.0), max: CGSize.init(width: 155.0, height: 300.0))
    }
    func scrollableDirections() -> ASScrollDirection {
        var direction : NSInteger = ASScrollDirection.down.rawValue
        direction |= ASScrollDirection.up.rawValue
        
        return ASScrollDirection(rawValue: direction)
    }
}
