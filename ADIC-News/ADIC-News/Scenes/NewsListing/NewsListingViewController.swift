//
//  ViewController.swift
//  ADIC-News
//
//  Created by Edwin Wilson on 01/09/2021.
//

import UIKit

class NewsListingViewController: UIViewController {

    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var searchbar: UISearchBar!
    @IBOutlet weak private var filterView: FilterView!

    private let model = NewsListingViewModel()
    private var presentation = NewsListingPresentation()

    var dataSource: UITableViewDiffableDataSource<NewsListingSection, NewsListingCellPresentation>?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        model.delegate = self
        model.fetchNews()
        configureSearchBar()
        configureFilterView()
    }

    private func configureFilterView() {

        filterView.isHidden = true
        filterView.delegate = self
        filterView.configureFilterView()
        if let news = model.state.news {
            filterView.UpdatePresetnation(news: news)
        }
    }

    private func configureSearchBar() {

        searchbar.delegate = self
        searchbar.isHidden = true
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

    // MARK: - action
    @IBAction func showSearch() {

        if searchbar.isHidden == false {
            searchbar.isHidden = true
            return
        }

        let orginalSearchFrame = searchbar.frame
        let newFrame = CGRect(
            x: orginalSearchFrame.origin.x,
            y: -orginalSearchFrame.height,
            width: orginalSearchFrame.width,
            height: orginalSearchFrame.height
        )
        searchbar.frame = newFrame
        UIViewPropertyAnimator(duration: 0.2, curve: .easeOut) {
            self.searchbar.frame = orginalSearchFrame
            self.searchbar.isHidden = false
        }.startAnimation()
    }

    @IBAction func showFilterView() {

        if filterView.isHidden == false {
            filterView.isHidden = true
            return
        }

        let orginalFilterFrame = filterView.frame
        let newFrame = CGRect(
            x: -orginalFilterFrame.width,
            y: orginalFilterFrame.origin.y,
            width: orginalFilterFrame.width,
            height: orginalFilterFrame.height
        )
        filterView.frame = newFrame
        UIViewPropertyAnimator(duration: 0.2, curve: .easeOut) {
            self.filterView.frame = orginalFilterFrame
            self.filterView.isHidden = false
        }.startAnimation()
    }
}

extension NewsListingViewController: NewsListingViewModelDelegate {

    func didUpdateResults() {

        guard var snapshot = dataSource?.snapshot() else { return }
        snapshot.deleteItems(presentation.cellPresentation ?? [])
        if model.state.filteredItems != nil {
            presentation.update(news: model.state.filteredItems)
        } else {
            presentation.update(news: model.state.news)
        }
        snapshot.appendItems(presentation.cellPresentation ?? [])
        dataSource?.apply(snapshot)
    }


    func didFetchNews(isSuccessFull: Bool) {

        presentation.update(news: model.state.news)
        DispatchQueue.main.async {
            self.updateTableViewDataSource()
            if let news = self.model.state.news {
                self.filterView.UpdatePresetnation(news: news)
            }
        }
    }
}

extension NewsListingViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        model.search(for: searchbar.text)
        searchbar.resignFirstResponder()
        searchbar.isHidden = true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.count > 2 ||
            searchText.count == 0
            {
            model.search(for: searchText)
        }
    }
}

extension NewsListingViewController: FilterViewDelegate {

    func didApplyFilter(type: FilterSection, value: String, didEnabled: Bool) {

        model.applyFilter(type: type, value: value, didEnabled: didEnabled)
    }
}
