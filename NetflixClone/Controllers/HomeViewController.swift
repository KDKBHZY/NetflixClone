//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by ZY H on 2023-09-08.
//

import UIKit

enum Section:Int{
    case TrendingMovies = 0
    case TrendingTv = 1
    case popular = 2
    case upcoming = 3
    case TopRated = 4
    
}

class HomeViewController: UIViewController {
   
    let sectionTitles:[String] = ["Trending Movies", "Trending TV","Popular", "Upcoming Movies", "Top Rated"]
    private var homeFeedTable:UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        //Customize NavBar
        configureNavBar()
        
        //Customize tableHeader
        let headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
    }
    
    private func configureNavBar(){
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        let logo = UIBarButtonItem(image: image, style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = logo
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
    }
    
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else{
            return UITableViewCell()
        }
        switch(indexPath.section){
        case Section.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { result in
                switch result{
                case .success(let titles):cell.configureTitle(with: titles)
                case .failure(let error): print(error.localizedDescription)
                }
            }
        case Section.TrendingTv.rawValue:
            APICaller.shared.getTrendingTv { result in
                switch result{
                case .success(let titles): cell.configureTitle(with: titles)
                case .failure(let error): print(error.localizedDescription)
                }
            }
        case Section.popular.rawValue:
            APICaller.shared.getPopular{ result in
                switch result{
                case .success(let titles): cell.configureTitle(with: titles)
                case .failure(let error): print(error.localizedDescription)
                }
            }
        case Section.upcoming.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result{
                case .success(let titles): cell.configureTitle(with: titles)
                case .failure(let error): print(error.localizedDescription)
                }
            }
        case Section.TopRated.rawValue:
            APICaller.shared.getTopRated{ result in
                switch result{
                case .success(let titles): cell.configureTitle(with: titles)
                case .failure(let error): print(error.localizedDescription)
                }
            }
        default:
            return cell
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    //Make the topBar not stick at the top
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view
            .safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0,-offset))
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
    }
    
}


extension HomeViewController:CollectionViewTableViewCellDelegate{
    func collectionViewTableViewCelldidtab(cell: CollectionViewTableViewCell, viewModel: TitlePreviewModel) {
        DispatchQueue.main.async {[weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
    
    
}
