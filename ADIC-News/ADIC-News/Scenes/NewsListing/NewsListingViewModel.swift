//
//  NewsListingViewModel.swift
//  ADIC-News
//
//  Created by Edwin Wilson on 01/09/2021.
//

import Foundation

struct NewsListingState {

    var news: [News]?

    var filteredItems: [News]?
}

protocol NewsListingViewModelDelegate: AnyObject {

    func didFetchNews(isSuccessFull: Bool)
    func didUpdateResults()
}

class NewsListingViewModel {

    var state = NewsListingState()
    var delegate: NewsListingViewModelDelegate?

    func fetchNews() {

        guard let url = NetworkManager.URLForApi(path: NYNews.apiKey) else { return }

        NetworkManager.shared.start(request: url) { [unowned self] (response: Response<NYNews>) in

            state.news = response.result?.news
            delegate?.didFetchNews(isSuccessFull: response.error == nil)
        }
    }

    func search(for title: String?) {

        guard let text = title,
           !text.isEmpty else {

            state.filteredItems = nil
            delegate?.didUpdateResults()
            return
        }

        state.filteredItems = state.news?.filter(
            { $0.title?.lowercased().contains(text.lowercased()) ?? false }
        )
        delegate?.didUpdateResults()
    }
}
