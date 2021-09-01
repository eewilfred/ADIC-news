//
//  ViewController.swift
//  ADIC-News
//
//  Created by Edwin Wilson on 01/09/2021.
//

import UIKit

class NewsListingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let model = NewsListingViewModel()
    private var presentation = NewsListingPresentation()

    var dataSource: UITableViewDiffableDataSource<NewsListingSection, NewsListingCellPresentation>?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        model.delegate = self
        model.fetchNews()
    }

    private func configureTableView() {

        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension

        tableView.register(
            NewsListingTableViewCell.nib,
            forCellReuseIdentifier: NewsListingTableViewCell.identifier
        )

        dataSource = UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { (tableView, indexPath, cellPresentation) in
                self.updateCell(at: indexPath, with: cellPresentation)
        })

        guard let dataSource = dataSource else { return }
        var snapShot = NSDiffableDataSourceSnapshot<NewsListingSection, NewsListingCellPresentation>()
        snapShot.appendSections(NewsListingSection.allCases)
        dataSource.apply(snapShot)
    }

    private func updateCell(
        at indexpath: IndexPath,
        with presentation: NewsListingCellPresentation
    ) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsListingTableViewCell.identifier,
            for: indexpath
        ) as? NewsListingTableViewCell {

            cell.presentation = presentation
            return cell
        }

        return UITableViewCell()
    }

    private func updateTableViewDataSource() {

        guard var snapshot = dataSource?.snapshot() else { return }
        snapshot.appendItems(presentation.cellPresentation ?? [])
        dataSource?.apply(snapshot)
    }
}

extension NewsListingViewController: NewsListingViewModelDelegate {

    func didFetchNews(isSuccessFull: Bool) {

        presentation.update(news: model.state.news)
        DispatchQueue.main.async {
            self.updateTableViewDataSource()
        }
    }
}
