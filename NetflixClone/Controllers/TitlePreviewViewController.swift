//
//  TitlePreviewViewController.swift
//  NetflixClone
//
//  Created by ZY H on 2023-09-14.
//

import UIKit
import WebKit
class TitlePreviewViewController: UIViewController {

    private let titleLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Spidrrman"
        return label
    }()
    private let webView:WKWebView = {
        let webview = WKWebView()
        webview.translatesAutoresizingMaskIntoConstraints = false
        return webview
    }()
    
    private let overViewLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .regular)
        //multiple lines
        label.numberOfLines = 0
        label.text = "Overview"
        return label
    }()
    
    private let downloadBtn:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .red
        btn.translatesAutoresizingMaskIntoConstraints = false;
        btn.setTitle("Download", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = true
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overViewLabel)
        view.addSubview(downloadBtn)
        view.backgroundColor = .systemBackground
        configureConstraints()
    }
    
    func configureConstraints(){
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.topAnchor,constant: 50),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 250)
        ]
        
        let titleConstraints = [
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ]
        let overViewConstraint = [
            overViewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),      overViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)

        ]
        let downbetConstraints = [
            downloadBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadBtn.topAnchor.constraint(equalTo: overViewLabel.bottomAnchor,constant: 25),
            downloadBtn.widthAnchor.constraint(equalToConstant: 140)
        ]
        NSLayoutConstraint.activate(titleConstraints)
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(overViewConstraint)
        NSLayoutConstraint.activate(downbetConstraints)
    }
    
    func configure(with model:TitlePreviewModel){
        titleLabel.text = model.title
        overViewLabel.text = model.titleOVerview
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)")else{
            return
        }
        webView.load(URLRequest(url: url))
        
    }
  
    

}
