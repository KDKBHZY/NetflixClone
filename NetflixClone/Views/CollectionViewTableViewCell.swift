//
//  CollectionViewTableViewCell.swift
//  NetflixClone
//
//  Created by ZY H on 2023-09-08.
//

import UIKit

protocol CollectionViewTableViewCellDelegate:AnyObject{
    func  collectionViewTableViewCelldidtab(cell:CollectionViewTableViewCell,viewModel:TitlePreviewModel)
}


class CollectionViewTableViewCell: UITableViewCell {

   static let identifier = "CollectionViewTableViewCell"
    weak var delegate:CollectionViewTableViewCellDelegate?
    private var titles:[Title] = [Title]()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(140, 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configureTitle(with titles:[Title]){
        self.titles = titles
        DispatchQueue.main.async {
            [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func downloadTitleAt(indexPath:IndexPath){
        DataPersistenceManager.shared.downloadTitleWith(model: titles[indexPath.row]) { result in
            switch result{
            case.success(): print("download to database")
            case .failure(let err): print(err.localizedDescription)
            }
            
        }
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as?TitleCollectionViewCell else{return UICollectionViewCell()}
        
        guard let model = titles[indexPath.row].poster_path else{return UICollectionViewCell()}
        cell.configure(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_name ?? title.original_title else{return }
        APICaller.shared.getMovie(with: titleName + " trailer") { result in
            switch result {
            case .success(let videos):
                let viewModel = TitlePreviewModel(title:titleName, youtubeView: videos, titleOVerview: title.overview!)
                self.delegate?.collectionViewTableViewCelldidtab(cell: self, viewModel: viewModel)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) {[weak self] _ in
                let downloadAction = UIAction(title: "DownLoad",state: .off) { _ in
                    self?.downloadTitleAt(indexPath: indexPaths[0])
                }
                return UIMenu(title:"", options: .displayInline, children: [downloadAction])
            }
        
        return config
    }
    
    
}

