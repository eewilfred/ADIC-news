//
//  ViewController.swift
//  ADIC-News
//
//  Created by Edwin Wilson on 01/09/2021.
//

import UIKit

class NewsListingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var dataSource: UITableViewDiffableDataSource<NewsListingSection, NewsListingCellPresentation>?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    private func configureTableView() {

        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        dataSource = UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { (tableView, indexPath, cellPresentation) in
                self.updateCell(at: indexPath, with: cellPresentation)
        })
    }

    private func updateCell(at indexpath: IndexPath, with presentation: NewsListingCellPresentation) -> UITableViewCell {

        return UITableViewCell()
    }
}

