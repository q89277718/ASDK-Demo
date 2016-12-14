//
//  ViewController.swift
//  Layers
//
//  Created by René Cacheaux on 9/1/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

class RainforestViewController: UICollectionViewController {
  let rainforestCardsInfo = getAllCardInfo()
                            
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func collectionView(_ collectionView: UICollectionView,
      numberOfItemsInSection section: Int) -> Int {
    return rainforestCardsInfo.count
  }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! RainforestCardCell
        let cardInfo = rainforestCardsInfo[indexPath.item]
        cell.configureCellDisplayWithCardInfo(cardInfo: cardInfo)
        return cell
    }
}
