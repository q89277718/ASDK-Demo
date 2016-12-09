//
//  TestCollectionCellNode.swift
//  Layers
//
//  Created by 夏路遥 on 2016/11/10.
//  Copyright © 2016年 Razeware LLC. All rights reserved.
//

import Foundation

class TestCollectionCellNode: ASCellNode {
    var data:RainforestCardInfo?
    var placeholderLayer: CALayer!
    var featureImageSizeOptional: CGSize?
    var backgroundImageNode: ASImageNode?
    var isShow: Bool = false
    var featureImageNode:ASImageNode?
    var titleTextNode:ASTextNode?
    var descriptionTextNode : ASTextNode?
    
    override func awakeFromNib() {
        
    }
    
    required override init() {
        super.init()
    }
    
    convenience init(data:RainforestCardInfo) {
        self.init()
        self.data = data
        self.layoutViews()
        self.configureCellDisplayWithCardInfo(cardInfo: data)
    }
    
    func layoutViews() -> Void {
        self.isLayerBacked = true
        self.shouldRasterizeDescendants = true
        self.borderColor = UIColor(hue: 0, saturation: 0, brightness: 0.85, alpha: 0.2).cgColor
        self.borderWidth = 1
        
        let placeholderNode = ASImageNode()
        placeholderNode.image = UIImage(named: "cardPlaceholder")!
        placeholderNode.contentsScale = UIScreen.main.scale
        placeholderNode.contentMode = .scaleAspectFill
        placeholderNode.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.85, alpha: 1)
        
        self.addSubnode(placeholderNode)
        self.placeholderLayer = placeholderNode.layer
//        placeholderLayer.contentsGravity = kCAGravityCenter
    }
    
    override func layout() {
        super.layout()
        
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        placeholderLayer?.frame = bounds
        
        featureImageNode?.frame = FrameCalculator.frameForFeatureImage(
            featureImageSize: (UIImage(named:(data?.imageName)!)?.size)!,
            containerFrameWidth: self.frame.size.width)
        
        titleTextNode?.frame = FrameCalculator.frameForTitleText(
            containerBounds: self.bounds,
            featureImageFrame: (featureImageNode?.frame)!)
        descriptionTextNode?.frame = FrameCalculator.frameForDescriptionText(
            containerBounds: self.bounds,
            featureImageFrame: (featureImageNode?.frame)!)
        CATransaction.commit()
    }
    
    
    override func calculateSizeThatFits(_ constrainedSize: CGSize) -> CGSize {
        if let featureImageSize = self.featureImageSizeOptional {
            return featureImageSize
//            return FrameCalculator.sizeThatFits(size: constrainedSize, withImageSize: featureImageSize)
        } else {
            return CGSize.zero
        }
    }
    
    override func willEnterHierarchy() {
        
    }
    
    func configureCellDisplayWithCardInfo(cardInfo: RainforestCardInfo) {
        data = cardInfo
        //MARK: Image Size Section
        let image = UIImage(named: cardInfo.imageName)!
        featureImageSizeOptional = image.size
        
        self.backgroundImageNode = ASImageNode()
        self.backgroundImageNode?.image = image
        self.backgroundImageNode?.contentMode = .scaleAspectFill
        self.backgroundImageNode?.isLayerBacked = true
    
        backgroundImageNode?.imageModificationBlock = { input in
            if let blurredImage = input.applyBlur(
                withRadius: 30,
                tintColor: UIColor(white: 0.5, alpha: 0.3),
                saturationDeltaFactor: 1.8,
                maskImage: nil,
                didCancel:{ return false }) {
                return blurredImage
            } else {
                return image
            }
        }
        
        self.backgroundImageNode?.frame = FrameCalculator.frameForContainer(featureImageSize: image.size)
        
        featureImageSizeOptional = self.backgroundImageNode?.frame.size
        
        self.addSubnode(backgroundImageNode!)
        
        let featureImageNode = ASImageNode()
        featureImageNode.isLayerBacked = true
        featureImageNode.contentMode = .scaleAspectFit
        featureImageNode.image = image
        self.addSubnode(featureImageNode)
        
        featureImageNode.frame = FrameCalculator.frameForFeatureImage(
            featureImageSize: image.size,
            containerFrameWidth: self.frame.size.width)
        self.featureImageNode = featureImageNode
        
        let titleTextNode = ASTextNode()
        titleTextNode.isLayerBacked = true
        titleTextNode.backgroundColor = UIColor.clear
        titleTextNode.attributedText = NSAttributedString.attributedStringForTitleText(text: cardInfo.name)
        self.addSubnode(titleTextNode)
        self.titleTextNode = titleTextNode

        let descriptionTextNode = ASTextNode()
        descriptionTextNode.isLayerBacked = true
        descriptionTextNode.backgroundColor = UIColor.clear
        descriptionTextNode.attributedText =
            NSAttributedString.attributedStringForDescriptionText(text: cardInfo.description)
        self.descriptionTextNode = descriptionTextNode
        self.addSubnode(descriptionTextNode)
    }
    
    override func didEnterVisibleState() {
        super.didEnterVisibleState()
        self.isShow = true
    }
    
    override func didExitVisibleState() {
        super.didExitVisibleState()
        self.isShow = false
    }
}
