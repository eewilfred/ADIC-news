//
//  NewsListingViewModel.swift
//  ADIC-News
//
//  Created by Edwin Wilson on 01/09/2021.
//

import Foundation

// NOTE: model does not support search items to be filtered

struct NewsListingState {

    var news: [News]?
    var filteredItems: [News]?
    var applyedFilters: [FilterSection: [String]]
}

protocol NewsListingViewModelDelegate: AnyObject {

    func didFetchNews(isSuccessFull: Bool)
    func didUpdateResults()
}

class NewsListingViewModel {

    var state: NewsListingState
    var delegate: NewsListingViewModelDelegate?

    init() {

        let applyedFilters: [FilterSection: [String]] = [
            .sourceLocation: [],
            .publishedDate: [],
            .type: []
        ]

        state = NewsListingState(
            news: nil,
            filteredItems: nil,
            applyedFilters: applyedFilters
        )
    }

    func fetchNews() {

        guard let url = NetworkManager.URLForApi(path: NYNews.apiKey) else { return }

        NetworkManager.shared.start(request: url) { [unowned self] (response: Response<NYNews>) in

            state.news = response.result?.news
            delegate?.didFetchNews(isSuccessFull: response.error == nil)
        }
    }

    func search(for title: String?) {

        let isAnyFiltersApplyed = isAnyFiltersApplyed()
        guard let text = title,
           !text.isEmpty else {

            state.filteredItems = nil
            if isAnyFiltersApplyed {
                state.filteredItems = applyFilter()
            }
            delegate?.didUpdateResults()
            return
        }

        state.filteredItems = (isAnyFiltersApplyed ? state.filteredItems : state.news)?.filter(
            { $0.title?.lowercased().contains(text.lowercased()) ?? false }
        )
        delegate?.didUpdateResults()
    }

    func applyFilter(type: FilterSection, value: String, didEnabled: Bool) {

        if let index = state.applyedFilters[type]?.firstIndex(where: {$0 == value}) {
            state.applyedFilters[type]?.remove(at: index)
        }
        if didEnabled {
            state.applyedFilters[type]?.append(value)
        }

        if isAnyFiltersApplyed() {
            state.filteredItems = applyFilter()

        } else {
            state.filteredItems = nil
        }
        delegate?.didUpdateResults()
    }

    private func applyFilter() -> [News] {

        return state.news?.filter({ news in
            for key in state.applyedFilters.keys {
                switch key {
                case .sourceLocation:
                    let filter = Set(state.applyedFilters[key] ?? [])
                    let fullList = Set(news.geoFacet ?? [])

                    if !filter.intersection(fullList).isEmpty {
                        return true
                    }
                case .publishedDate:
                    if state.applyedFilters[key]?.contains(news.publishedDate ?? "") ?? false {
                        return true
                    }
                case .type:
                    if state.applyedFilters[key]?.contains(news.type ?? "") ?? false {
                        return true
                    }
                }
            }
            return false
        }) ?? []

    }

    private func isAnyFiltersApplyed() -> Bool {

        return state.applyedFilters.values.first(where: {!$0.isEmpty}) != nil
    }
}
