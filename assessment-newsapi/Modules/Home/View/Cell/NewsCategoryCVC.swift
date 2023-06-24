//
//  NewsCategoryCVC.swift
//  assessment-newsapi
//
//  Created by Agam on 24/06/23.
//

import UIKit

class NewsCategoryCVC: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    static let identifier = String(describing: NewsCategoryCVC.self)
    static let nib = UINib(
        nibName: identifier,
        bundle: nil)
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .blue : .clear
            titleLabel.textColor = isSelected ? .white : .black
        }
    }
}
