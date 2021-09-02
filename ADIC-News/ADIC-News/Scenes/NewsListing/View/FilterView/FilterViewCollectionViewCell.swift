//
//  FilterViewCollectionViewCell.swift
//  ADIC-News
//
//  Created by Edwin Wilson on 02/09/2021.
//

import UIKit

struct FilterViewCellPresentation: Hashable {

    var filterType: FilterSection
    var name: String
    var isSelected = false

    func hash(into hasher: inout Hasher) {
        hasher.combine(name + filterType.rawValue)
        }

    static func == (lhs: FilterViewCellPresentation,
                    rhs: FilterViewCellPresentation) -> Bool {
        lhs.name == rhs.name &&
            lhs.filterType == rhs.filterType
    }
}

class FilterViewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var filterNameLabel: UILabel!

    var presentation: FilterViewCellPresentation? {

        didSet {
            updateUI()
        }
    }

    private func updateUI() {

        guard let presentation = presentation else { return }

        filterNameLabel.text = presentation.name
        backgroundColor = presentation.isSelected ? .black : .white
        filterNameLabel.textColor = presentation.isSelected ? .white : .black
    }
}
