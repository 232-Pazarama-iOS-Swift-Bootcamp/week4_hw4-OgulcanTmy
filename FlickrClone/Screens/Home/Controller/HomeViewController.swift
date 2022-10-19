//
//  HomeViewController.swift
//  FlickrClone
//
//  Created by Oğulcan Tamyürek on 19.10.2022.
//

import UIKit

class HomeViewController: UIViewController {
    private let viewModel: HomeViewModel

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "HomeTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "homeTableViewCell")

        viewModel.fetchPhotos()
        // Do any additional setup after loading the view.
        viewModel.changeHandler = { change in
            switch change {
                
            case .success:
                self.tableView.reloadData()
            case .failure(let error):
                self.showError(error)
            }
        }
    }
    
    // MARK: - Init
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.configureCell(with: (viewModel.photosResponse?.photos?.photo?[indexPath.row])!, index: indexPath.row)
        return cell
    }
    
    
}

