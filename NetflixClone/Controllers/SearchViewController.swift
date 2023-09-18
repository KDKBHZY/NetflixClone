//
//  SearchViewController.swift
//  NetflixClone
//
//  Created by ZY H on 2023-09-08.
//

import UIKit

class SearchViewController: UIViewController {

    private var titles:[Title] = [Title]()
    private let discoverTable:UITableView = {
        let table = UITableView()
        table.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        return table
    }()
    
    private let searchController:UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a movie or a TV show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
        view.addSubview(discoverTable)
        navigationItem.searchController = searchController
        discoverTable.delegate = self
        discoverTable.dataSource = self
        fetchDiscoverMovies()
        searchController.searchResultsUpdater = self
    }
    
    private func fetchDiscoverMovies(){
        APICaller.shared.getDiscoverMovies{
            results in
            switch results{
            case .success(let titles):
                self.titles = titles
                DispatchQueue.main.async {
                    self.discoverTable.reloadData()
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    

   

}

extension SearchViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    } 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.identifier, for: indexPath) as? UpcomingTableViewCell else{
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        let model = TitleViewModel(titleName: title.original_name ?? title.original_title ?? "Unknown", posterUrl: title.poster_path ?? "")
        cell.configure(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_name ?? title.original_title else{return }
        APICaller.shared.getMovie(with: titleName + " trailer") { [weak self]result in
            switch result {
            case .success(let videos):
                DispatchQueue.main.async{
                    let vc = TitlePreviewViewController()
                    vc.configure(with:  TitlePreviewModel(title:titleName, youtubeView: videos, titleOVerview: title.overview!))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
               

            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
}

extension SearchViewController:UISearchResultsUpdating,SearchResultsViewControllerDelegate{
    func SearchResultsViewControllerDidTapItem(viewModel: TitlePreviewModel) {
        DispatchQueue.main.async {[weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
                !query.trimmingCharacters(in: .whitespaces).isEmpty,
                query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchResultsViewController else{
            return
        }
        resultController.delegate = self
        APICaller.shared.search(with: query) { result in
                switch result{
                case .success(let titles):
                    resultController.configureTitle(with: titles)
                case .failure(let err):
                    print(err.localizedDescription)
                    
                }
        }
    }
    
     
}
