//
//  CarouselCell.swift
//  Graphic Components
//
//  Created by Fabrizio Prosperi on 27/09/22.
//

import UIKit

class CarouselCell: UICollectionViewCell {
        
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    // MARK: - Properties
    static let id = "CarouselCell"
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonSetup()
    }
    
    // MARK: - Private
    private func commonSetup() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.layer.cornerRadius = 4
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 2
    }
    
    // MARK: - Public
    public func setup(filterType: FilterType, number: Int) {
        titleLabel.text = filterType.title
        numberLabel.text = String(number)
        numberLabel.textColor = filterType.mainColor
        subtitleLabel.text = filterType.description
        
    }
}
