//
//  MoviesVC.swift
//  Movie Demo
//
//  Created by Charles Reitz on 3/31/19.
//

import UIKit

class MoviesVC : UIViewController {

    private let TO_DETAIL_SEGUE_ID = "ToMovieDetail"
    
    @IBOutlet var NoResultsView: UIView!
    @IBOutlet var NoResultsLabel: UILabel!
    @IBOutlet var NoResultsSecondaryLabel: UILabel!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    private var movies = [Movie]()
    
    private var lastSearch = ""
    
    private let NO_RESULTS_TEXT_COLOR = UIColor.white
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "MovieDB".localized
        
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .THEME
        self.view.backgroundColor = .THEME
        self.NoResultsView.backgroundColor = .THEME
        
        self.NoResultsLabel.textColor = NO_RESULTS_TEXT_COLOR
        self.NoResultsSecondaryLabel.textColor = NO_RESULTS_TEXT_COLOR
        
        self.searchBar.placeholder = "Search for a Movie".localized
        self.searchBar.delegate = self
        self.searchBar.backgroundImage = nil
        self.searchBar.backgroundColor = .clear
        self.searchBar.tintColor = .white
        self.searchBar.barStyle = .black
        
        self.tableView.backgroundColor = .clear
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 71
        self.tableView.tableFooterView = UIView.init(frame: .zero)
        self.tableView.register(UINib.init(nibName: MovieCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: MovieCell.reuseIdentifier)
        
        loadFavorites()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == TO_DETAIL_SEGUE_ID {
            if let iPath = self.tableView.indexPathForSelectedRow, iPath.row < self.movies.count {
                let movieDetailVC = segue.destination as! MovieDetailVC
                movieDetailVC.movie = self.movies[iPath.row]
            }
        }
        
    }
    
    private func loadFavorites() {
        
        if Reachability.isConnectedToNetwork() {
            MovieDB.sInstance.getPopularMovies { [weak self] (response, movies) in
                self?.handleMoviesResponse(response, movies: movies)
            }
        } else {
            if let savedMovies = EntityManager.movie.load() as? [Movie] {
                self.movies = savedMovies
            }
            
            if self.movies.isEmpty {
                self.tableView.reloadData()
                showNoConnectionLabel()
            } else {
                reloadTable()
            }
        }
    }
    
    private func search(query :String) {
        
        if Reachability.isConnectedToNetwork() {
            MovieDB.sInstance.searchMovies(query: query) { [weak self] (response, movies) in
                if query == self?.lastSearch {
                    self?.handleMoviesResponse(response, movies: movies)
                }
            }
        } else {
            self.movies.removeAll()
            self.tableView.reloadData()
            showNoConnectionLabel()
        }
    }
    
    private func handleMoviesResponse(_ response :NetworkResponse, movies :[Movie]) {

        if response.success() {
            self.movies = movies
            reloadTable()
        } else {
            self.tableView.reloadData()
            showErrorLabel()
        }
    }
}

extension MoviesVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let deqCell = tableView.dequeueReusableCell(withIdentifier: MovieCell.reuseIdentifier, for: indexPath) as? MovieCell
        guard let cell = deqCell, indexPath.row < self.movies.count else {
            return UITableViewCell()
        }
        
        let movie = self.movies[indexPath.row]
        cell.configure(movie: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row < self.movies.count {
            self.performSegue(withIdentifier: TO_DETAIL_SEGUE_ID, sender: self)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func reloadTable() {
        
        DispatchQueue.main.async {
            if self.movies.isEmpty {
                self.showNoResultsLabel()
            } else {
                self.tableView.backgroundView = nil
            }
            self.tableView.reloadData()
        }
    }
    
}

extension MoviesVC : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let text = searchText.trimmingCharacters(in: .whitespaces)
        self.lastSearch = text

        //'timeout' to avoid over-searching
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
            //don't search if text has changed
            if text == self.lastSearch {
                if text.isEmpty {
                    self.loadFavorites()
                } else {
                    self.search(query: text)
                }
            }
        }
    }
}

extension MoviesVC {
    
    private func showNoConnectionLabel() {
        showLabel(title: "No Connection".localized, message: "Try again later".localized)
    }
    
    private func showNoResultsLabel() {
        showLabel(title: "No Results".localized, message: "Try searching for something else".localized)
    }
    
    private func showErrorLabel() {
        showLabel(title: "Sorry".localized, message: "Something went wrong".localized)
    }
    
    private func showLabel(title :String, message :String) {
        self.tableView.backgroundView = self.NoResultsView
        self.NoResultsLabel.text = title
        self.NoResultsSecondaryLabel.text = message
    }
}
