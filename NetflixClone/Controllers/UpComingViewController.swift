//
//  UpComingViewController.swift
//  NetflixClone
//
//  Created by ZY H on 2023-09-08.
//

import UIKit

class UpComingViewController: UIViewController{
    
    private var titles:[Title] = [Title]()
    private let upcomingTable:UITableView = {
        let table = UITableView()
        table.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        fetchUpcoming()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    private func fetchUpcoming(){
        APICaller.shared.getUpcomingMovies { result in
            switch result{
            case .success(let titles):
                self.titles = titles
                DispatchQueue.main.async {
                    self.upcomingTable.reloadData()
                }
            case .failure(let error): print(error.localizedDescription)
            }
        }
    }
}

extension UpComingViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.identifier, for: indexPath) as? UpcomingTableViewCell else{
            print("here")
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: title.original_title ?? title.original_name ?? "Unknown", posterUrl: title.poster_path ?? ""))
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
