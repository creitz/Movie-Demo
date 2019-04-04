//
//  MovieCell.swift
//  Movie Demo
//
//  Created by Charles Reitz on 4/1/19.
//

import Foundation
import UIKit
import SDWebImage

class MovieCell : UITableViewCell {
    
    static var reuseIdentifier: String {
        return "MovieCell"
    }
    
    static let dateFormatter = DateFormatter.defaultFormatter(format: "yyyy")
    
    let TEXT_COLOR = UIColor.white
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var imgViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        self.titleLabel.textColor = TEXT_COLOR
        self.descriptionLabel.textColor = TEXT_COLOR
        self.timeLabel.textColor = TEXT_COLOR
        
        self.imgView.layer.cornerRadius = 5.0
        self.imgView.clipsToBounds = true
    }
    
    func configure(movie :Movie) {
        
        self.titleLabel.text = movie.title
        self.descriptionLabel.text = movie.overview
        self.timeLabel.text = MovieCell.dateFormatter.dateFrom(date: movie.releaseDate)
        self.imgView.sd_setImage(with: movie.posterURL, completed: { [weak self] (img, err, cache, url) in
            
            guard let strongSelf = self else { return }
            
            if let image = strongSelf.imgView.image {
                let ratio = image.size.width / image.size.height
                let newHeight = strongSelf.imgView.frame.width / ratio
                strongSelf.imgViewHeightConstraint.constant = newHeight
                strongSelf.contentView.layoutIfNeeded()
            }
        })
    }
    
}
