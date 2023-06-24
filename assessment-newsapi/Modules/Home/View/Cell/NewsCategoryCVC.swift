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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var isSelected: Bool {
        didSet {
            if (isSelected){
                backgroundColor = .blue
                titleLabel.textColor = .white
            }else {
                backgroundColor = .clear
                titleLabel.textColor = .black
            }
        }
    }
}
