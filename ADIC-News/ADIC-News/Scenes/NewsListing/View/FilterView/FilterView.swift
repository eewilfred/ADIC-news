//
//  FilterView.swift
//  ADIC-News
//
//  Created by Edwin Wilson on 02/09/2021.
//

import UIKit


enum FilterSection: String, CaseIterable {

    case sourceLocation = "source location"
    case publishedDate = "published date"
    case type = "type"
}

protocol FilterViewDelegate: AnyObject {

    func didApplyFilter(type: FilterSection, value: String, didEnabled: Bool)
}

class FilterView: UIView {

    @IBOutlet weak private var collectionView: UICollectionView!

    var presentation: FilterViewPresentation?
    weak var delegate: FilterViewDelegate?

    var dataSource: UICollectionViewDiffableDataSource<FilterSection, FilterViewCellPresentation>?

    func configureFilterView() {

        presentation = FilterViewPresentation()
        configureCollectionView()

    }

    private func configureCollectionView() {

        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        layoutConfig.headerMode = .supplementary
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)

        collectionView.collectionViewLayout = listLayout
        collectionView.delegate = self

        collectionView.register(
            FilterViewCollectionViewCell.nib,
            forCellWithReuseIdentifier: FilterViewCollectionViewCell.identifier
        )

        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, cellPresentation) in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: FilterViewCollectionViewCell.identifier,
                    for: indexPath
                ) as? FilterViewCollectionViewCell else { return UICollectionViewCell() }

                cell.presentation = cellPresentation
                return cell
            }
        )

        configureHeader()
        configureData()
    }

    private func configureHeader() {

        let headerRegistration = UICollectionView.SupplementaryRegistration
        <UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) {
            [unowned self] (headerView, elementKind, indexPath) in
            let headerItem = self.dataSource?.snapshot().sectionIdentifiers[indexPath.section]
            var configuration = headerView.defaultContentConfiguration()
            configuration.text = headerItem?.rawValue
            configuration.directionalLayoutMargins = .init(top: 20.0, leading: 0.0, bottom: 10.0, trailing: 0.0)
            headerView.contentConfiguration = configuration
        }

        dataSource?.supplementaryViewProvider = { [unowned self]
            (collectionView, elementKind, indexPath) -> UICollectionReusableView? in

            if elementKind == UICollectionView.elementKindSectionHeader {
                return self.collectionView.dequeueConfiguredReusableSupplementary(
                    using: headerRegistration, for: indexPath)
            }
            return nil
        }
    }

    private func configureData() {

        var snaphot = NSDiffableDataSourceSnapshot<FilterSection, FilterViewCellPresentation>()
        snaphot.appendSections(FilterSection.allCases)
        for type in FilterSection.allCases {
            if let cellPresentation = presentation?.filters[type] {
                snaphot.appendItems(cellPresentation, toSection: type)
            }
        }
        dataSource?.apply(snaphot)
    }

    func UpdatePresetnation(news: [News]) {

        guard var presentation = presentation,
              var snapshot = dataSource?.snapshot()else { return }

        let values = presentation.filters.values.flatMap({$0})
        snapshot.deleteItems(values)
        presentation.update(news: news)
        snapshot.appendItems(presentation.filters[.sourceLocation] ?? [], toSection: .sourceLocation)
        snapshot.appendItems(presentation.filters[.publishedDate] ?? [], toSection: .publishedDate)
        snapshot.appendItems(presentation.filters[.type] ?? [], toSection: .type)
        dataSource?.apply(snapshot)
        self.presentation = presentation
    }
}

extension FilterView: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {

        guard let sectionType = FilterSection.allCases[safe: indexPath.section],
              let presentations = presentation?.filters[sectionType],
              presentations[safe: indexPath.row] != nil,
              var snapshot = dataSource?.snapshot(),
              let cellPresentation = dataSource?.itemIdentifier(for: indexPath) else {
            return
        }

        cellPresentation.isSelected.toggle()
        snapshot.reloadItems([cellPresentation])
        self.dataSource?.apply(snapshot)

        delegate?.didApplyFilter(
            type: sectionType,
            value: cellPresentation.name,
            didEnabled: cellPresentation.isSelected)
    }
}
