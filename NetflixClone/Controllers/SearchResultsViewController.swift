//
//  SearchResultsViewController.swift
//  NetflixClone
//
//  Created by ZY H on 2023-09-12.
//

import UIKit

protocol SearchResultsViewControllerDelegate:AnyObject {
    func SearchResultsViewControllerDidTapItem(viewModel: TitlePreviewModel)
}

class SearchResultsViewController: UIViewController {

    private var titles:[Title] = [Title]()
    public weak var delegate: SearchResultsViewControllerDelegate?
    private let searchResultCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3-10, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        layout.minimumInteritemSpacing = 0
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        view.addSubview(searchResultCollectionView)
        
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollectionView.frame = view.bounds
    }
    
    public func configureTitle(with titles:[Title]){
        self.titles = titles
        DispatchQueue.main.async {
            [weak self] in
            self?.searchResultCollectionView.reloadData()
        }
    }
    
}

extension SearchResultsViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else{
            return UICollectionViewCell()
        }
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        let titleName = title.original_title ?? ""
        APICaller.shared.getMovie(with: titleName + " trailer") { [weak self]result in
            switch result {
            case .success(let videos):
                self?.delegate?.SearchResultsViewControllerDidTapItem(viewModel: TitlePreviewModel(title:titleName, youtubeView: videos, titleOVerview: title.overview!))
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
        
    }
}
