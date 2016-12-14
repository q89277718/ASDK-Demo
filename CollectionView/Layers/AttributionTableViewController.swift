//
//  AttributionTableViewController.swift
//  Layers
//
//  Created by René Cacheaux on 10/9/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

class AttributionTableViewController: UITableViewController {
  let rainforestCardsInfo = getAllCardInfo()
  
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rainforestCardsInfo.count
  }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cardInfo = rainforestCardsInfo[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! AttributionTableViewCell
        cell.titleLabel.text = cardInfo.name
        cell.articleAttributionTextView.attributedText = attributedTextWithTitle(title: cardInfo.articleAttribution, link: cardInfo.articleOriginLink)
        cell.articleLicenseTextView.attributedText = attributedTextWithTitle(title: cardInfo.articleLicense, link: cardInfo.articleLicenseLink)
        cell.imageAttributionTextView.attributedText = attributedTextWithTitle(title: cardInfo.imageAttribution, link: cardInfo.imageOriginLink)
        cell.imageLicenseTextView.attributedText = attributedTextWithTitle(title: cardInfo.imageLicense, link: cardInfo.imageLicenseLink)
        return cell
    }
  
  func attributedTextWithTitle(title: String, link: String) -> NSAttributedString {
    let attributedText = NSMutableAttributedString(string: title)
    attributedText.addAttribute(NSLinkAttributeName, value: link, range: NSMakeRange(0, (title as NSString).length))
    attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "AvenirNext-Medium", size: 16)!, range: NSMakeRange(0, (title as NSString).length))
    return attributedText.copy() as! NSAttributedString
  }
}
