//
//  UpcomingTableViewCell.swift
//  NetflixClone
//
//  Created by ZY H on 2023-09-11.
//

import UIKit

class UpcomingTableViewCell: UITableViewCell {

   static let identifier = "UpcomingTableViewCell"
    
    private let playButton:UIButton = {
        let btn = UIButton()
        let image = UIImage(systemName: "play.circle",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        btn.setImage(image, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .white
        return btn
    }()
    
    private let titleLabel:UILabel = {
        let label = UILabel()
        //to edit the position of the label manually
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titlePosterUiImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
       imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private func applyConstraints(){
        let titlePosterUiImageViewConnstraints = [
            titlePosterUiImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titlePosterUiImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            titlePosterUiImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            titlePosterUiImageView.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let titleLabelCOnstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: titlePosterUiImageView.trailingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 200)
        ]
        
        let playBtnConstraints = [
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(titlePosterUiImageViewConnstraints)
        NSLayoutConstraint.activate(titleLabelCOnstraints)
        NSLayoutConstraint.activate(playBtnConstraints)


    }
    
    public func configure(with model:TitleViewModel){
       
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterUrl)") else{return}
        titlePosterUiImageView.sd_setImage(with: url)
        titleLabel.text = model.titleName
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titlePosterUiImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playButton)
        applyConstraints()

    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
