//
//  RSCardNode.swift
//  RainforestStarter
//
//  Created by 夏路遥 on 2016/12/14.
//  Copyright © 2016年 Razeware LLC. All rights reserved.
//

import Foundation

class RSCardNode: ASCellNode {
    var animal:RainforestCardInfo?
    var backImgNode:ASImageNode?
    var animalImgNode:ASImageNode?
    var animalNameLblNode:ASTextNode?
    var descriptionLblNode:ASTextNode?
    
    required override init() {
        super.init()
    }
    
    convenience init(with animal:RainforestCardInfo){
        self.init()
        self.animal = animal
        self.backImgNode = ASImageNode()
        self.animalImgNode = ASImageNode()
        self.animalNameLblNode = ASTextNode()
        self.descriptionLblNode = ASTextNode()
        
        self.addSubnode(backImgNode!)
        self.addSubnode(animalImgNode!)
        self.addSubnode(animalNameLblNode!)
        self.addSubnode(descriptionLblNode!)
        
        self.animalImgNode?.contentMode = .scaleAspectFill
        
        self.descriptionLblNode?.backgroundColor = UIColor.clear
        
        self.clipsToBounds = true
    }
    
    override func layout() {
        super.layout()
        
        
        
    }
}
