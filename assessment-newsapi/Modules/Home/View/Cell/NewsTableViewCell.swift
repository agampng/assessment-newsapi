//
//  NewsTableViewCell.swift
//  assessment-newsapi
//
//  Created by Agam on 23/06/23.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    
    static let identifier = String(describing: NewsTableViewCell.self)
    static let nib = UINib(
        nibName: identifier,
        bundle: nil)
    
    func setupData(_ article: Article) {
        newImage.image = .none
        if let imgUrl = URL(string: article.urlToImage ?? "") {
            newImage.load(url: imgUrl)
        }
        titleLabel.text = article.title
        descLabel.text = article.description
        sourceLabel.text = "📄 \(article.source?.name ?? "")  🗓️ \(article.publishedAt ?? "")"
    }
    
}
