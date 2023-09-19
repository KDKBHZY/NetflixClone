//
//  DownloadViewController.swift
//  NetflixClone
//
//  Created by ZY H on 2023-09-08.
//

import UIKit

class DownloadViewController: UIViewController {
    private var titles:[TitleItem] = [TitleItem]()
    
    private let downLoadTable:UITableView = {
        let table = UITableView()
        table.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(downLoadTable)
        title = "upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        downLoadTable.delegate = self
        downLoadTable.dataSource = self
        fetchLocalStorage()
    }
    
    private func fetchLocalStorage(){
        DataPersistenceManager.shared.getTitlesFromDB {[weak self]result in
            switch result{
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.downLoadTable.reloadData()

                }
            case .failure(let err):
                print(err.localizedDescription)
            
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downLoadTable.frame = view.bounds
    }


}

extension DownloadViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.identifier, for: indexPath) as? UpcomingTableViewCell else{
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: title.original_title ?? title.original_name ?? "Unknown", posterUrl: title.poster_path ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle{
        case .delete:
            DataPersistenceManager.shared.deleteTitle(model: titles[indexPath.row]) {[weak self] result in
                switch result{
                case .success():
                    print("delete successfully")
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
            self.titles.remove(at: indexPath.row)

            tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            break;
        }
    }
    
    
    
}
