//
//  MovieDetailVC.swift
//  Movie Demo
//
//  Created by Charles Reitz on 4/2/19.
//

import Foundation
import UIKit

class MovieDetailVC : UIViewController {
    
    var movie :Movie?
    
    @IBOutlet var BudgetTitleLabel: UILabel!
    @IBOutlet var BudgetLabel: UILabel!
    @IBOutlet var VoteLabel: UILabel!
    @IBOutlet var PosterImage: UIImageView!
    @IBOutlet var TitleLabel: UILabel!
    @IBOutlet var YearLabel: UILabel!
    @IBOutlet var OverviewText: UITextView!
    @IBOutlet var LinkText: UITextView!
    
    private var dateFormatter = DateFormatter.defaultFormatter(format: "MMMM d, yyyy")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .THEME
        self.title = self.movie?.title
        self.BudgetTitleLabel.text = "Budget".localized + ":"
        self.TitleLabel.adjustsFontSizeToFitWidth = true
        
        setDetails()
        loadMovie()
    }
    
    private func loadMovie() {
        
        guard let mv = self.movie, let id = mv.id else {
            return
        }
        
        if Reachability.isConnectedToNetwork() {
            MovieDB.sInstance.getDetailsForMovie(id: id) { (response, movieDetails) in
                DispatchQueue.main.async {
                    if response.success(), let details = movieDetails {
                        self.addDetails(details)
                    }
                }
            }
        } else {
            if let detailEntities = EntityManager.movieDetails.get(id: id) {
                if let details = detailEntities.first as? MovieDetails {
                    addDetails(details)
                }
            }
        }
    }
    
    private func addDetails(_ details :MovieDetails) {
        self.movie?.movieDetails = details
        setDetails()
    }
    
    private func setDetails() {
        
        self.TitleLabel.text = movie?.title
        self.YearLabel.text = self.dateFormatter.dateFrom(date: movie?.releaseDate)
        self.OverviewText.text = movie?.overview
        self.OverviewText.setContentOffset(.zero, animated: false)
        self.PosterImage.sd_setImage(with: movie?.posterURLLarge, completed: nil)
        if let voteAvg = self.movie?.voteAverage {
            self.VoteLabel.text = String(voteAvg)
        } else {
            self.VoteLabel.text = "-"
        }
        
        var budgetText = ""
        if let budget = self.movie?.movieDetails?.budget {
            if budget.intValue > 0 {
                budgetText += "$" + budget.intValue.withCommas()
            }
        } else {
            budgetText += "$-"
        }
        self.BudgetTitleLabel.isHidden = budgetText.isEmpty
        self.BudgetLabel.text = budgetText
        self.LinkText.text = self.movie?.movieDetails?.homePage
    }
    
}
