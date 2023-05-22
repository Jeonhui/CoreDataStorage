//
//  MovieCell.swift
//  CoreDataStorage_Example
//
//  Created by 이전희 on 2023/05/21.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    static let identifier = String(describing: MovieCell.self)
    
    var movie: Movie!
    
    private lazy var movieTitle: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
    }
    
    private func addSubviews() {
        [movieTitle, releaseDateLabel].forEach { view in
            self.addSubview(view)
        }
    }
    
    private func makeConstraints() {
        movieTitle.translatesAutoresizingMaskIntoConstraints = false
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let releaseDateLabelWidthAnchorConstraint = releaseDateLabel.widthAnchor.constraint(equalToConstant: 100)
        releaseDateLabelWidthAnchorConstraint.priority = .defaultLow
        
        let constraints: [NSLayoutConstraint] = [
            movieTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            movieTitle.heightAnchor.constraint(equalToConstant: 80),
            movieTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            movieTitle.trailingAnchor.constraint(equalTo: releaseDateLabel.leadingAnchor),
            releaseDateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            releaseDateLabelWidthAnchorConstraint,
            releaseDateLabel.heightAnchor.constraint(equalTo: movieTitle.heightAnchor, multiplier: 1),
            releaseDateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

    func setMovie(_ movie: Movie){
        self.movie = movie
        self.movieTitle.text = movie.title
        self.releaseDateLabel.text = movie.releaseDate.toDateString()
        layoutIfNeeded()
    }

}
