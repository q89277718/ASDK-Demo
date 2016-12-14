//
//  RSTableNode.swift
//  RainforestStarter
//
//  Created by 夏路遥 on 2016/12/9.
//  Copyright © 2016年 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit

class RSTableNode: UIViewController ,ASTableDataSource, ASTableDelegate{
    var animals = Array<RainforestCardInfo>()
    var tableNode : ASTableNode = ASTableNode.init(style: .plain)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(with animals:Array<RainforestCardInfo>){
        self.init(nibName: nil, bundle:nil)
        self.animals = animals
        self.tableNode.dataSource = self
        self.tableNode.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubnode(tableNode)
        self.view.backgroundColor = UIColor.black
        self.tableNode.view.separatorStyle = .none
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tableNode.frame = self.view.bounds
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.animals.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let animal = self.animals[indexPath.row]
        return {
            return CardNode.init(animal: animal)
//            return RSCardNode.init(with: animal)
        }
    }
}
