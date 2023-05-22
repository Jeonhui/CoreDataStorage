//
//  ViewController.swift
//  CoreDataStorage
//
//  Created by Jeonhui on 02/12/2023.
//  Copyright (c) 2023 Jeonhui. All rights reserved.
//

import UIKit
import Combine
import CoreDataStorage

class ViewController: UIViewController {
    private let coreDataStorage: CoreDataStorage = CoreDataStorage.shared(name: "MovieStorage")
    private var cancellable:Set<AnyCancellable> = Set<AnyCancellable>()
    private var titleId: Int  = 0
    
    private lazy var movieEnrollButton: UIBarButtonItem = {
        UIBarButtonItem(title: "enroll",
                        style: .plain,
                        target: self,
                        action: #selector(enroll))
    }()
    
    private lazy var movieResetButton: UIBarButtonItem = {
        UIBarButtonItem(title: "reset",
                        style: .plain,
                        target: self,
                        action: #selector(reset))
    }()
    
    private lazy var movieListView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieCell.self,
                           forCellReuseIdentifier: MovieCell.identifier)
        return tableView
    }()
    
    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.text = "desc"
        label.backgroundColor = .white
        return label
    }()
    
    var movieList: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sink()
        configure()
        addSubviews()
        makeConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func configure() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "Movie"
    }
    
    private func addSubviews() {
        [movieListView, descLabel].forEach { view in
            self.view.addSubview(view)
        }
        
        self.navigationController?
            .navigationBar.topItem?
            .rightBarButtonItem = movieEnrollButton
        self.navigationController?
            .navigationBar.topItem?
            .leftBarButtonItem = movieResetButton
    }
    
    private func makeConstraints() {
        movieListView.translatesAutoresizingMaskIntoConstraints = false
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints: [NSLayoutConstraint] = [
            movieListView.topAnchor.constraint(equalTo: view.topAnchor),
            movieListView.bottomAnchor.constraint(equalTo: descLabel.topAnchor),
            movieListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            descLabel.heightAnchor.constraint(equalToConstant: 100),
            descLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func sink(){
        coreDataStorage.read(type: Movie.self)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] movieList in
                self?.movieList = movieList
                self?.movieListView.reloadData()
            })
            .store(in: &cancellable)
    }
}

extension ViewController {
    @objc
    func enroll() {
        self.titleId += 1
        let movie = Movie(id: UUID().uuidString, title: "\(titleId)", releaseDate: Date(), desc: "\(titleId) - desc")
        coreDataStorage.create(movie)
            .map{ movie -> Movie? in movie }
            .replaceError(with: nil)
            .sink(receiveValue: { [weak self] _ in
                self?.sink()
            })
            .store(in: &cancellable)
    }
    
    @objc
    func reset() {
        coreDataStorage.deleteAll(Movie.self)
            .replaceError(with: false)
            .sink { [weak self]_ in
                self?.sink()
            }
            .store(in: &cancellable)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movieCell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier) as? MovieCell else {
            return UITableViewCell()
        }
        movieCell.setMovie(movieList[indexPath.row])
        
        return movieCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.descLabel.text = movieList[indexPath.row].desc
    }
}

