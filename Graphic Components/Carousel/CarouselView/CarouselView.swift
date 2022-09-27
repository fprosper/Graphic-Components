//
//  CarouselView.swift
//  Graphic Components
//
//  Created by Fabrizio Prosperi on 27/09/22.
//

import UIKit

protocol CarouselViewDelegate: AnyObject {
    func carouselView(_ carouselView: CarouselView, didSelectItemAt indexPath: IndexPath)
}

struct CarouselItem {
    var filterType: FilterType
    var entries: [(x: Double, y: Double)]
}

class CarouselView: NibView {

    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    private weak var delegate: CarouselViewDelegate?
    private var items: [CarouselItem] = []
    
    
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
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            UINib(nibName: CarouselCell.id, bundle: nil),
            forCellWithReuseIdentifier: CarouselCell.id)

        collectionView.backgroundColor = .clear
        
        let cellPadding: CGFloat = 10
        let carouselLayout = UICollectionViewFlowLayout()
        carouselLayout.scrollDirection = .horizontal
        carouselLayout.itemSize = .init(width: 130, height: 172)
        carouselLayout.sectionInset = .init(
            top: 0,
            left: cellPadding,
            bottom: 0,
            right: cellPadding)
        carouselLayout.minimumLineSpacing = cellPadding * 2
        collectionView.collectionViewLayout = carouselLayout
    }
    
    // MARK: - Public
    func setup(with items: [CarouselItem], delegate: CarouselViewDelegate) {
        self.items = items
        self.delegate = delegate
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension CarouselView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.id, for: indexPath) as? CarouselCell else { return UICollectionViewCell() }
        
        let item = items[indexPath.item]
        let number = item.entries.reduce(0) { $0 + Int($1.y)}
        cell.setup(filterType: item.filterType, number: number)
        
        return cell
    }
}

// MARK: - UICollectionView Delegate
extension CarouselView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.carouselView(self, didSelectItemAt: indexPath)
    }
}
