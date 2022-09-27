//
//  ViewController.swift
//  Graphic Components
//
//  Created by Fabrizio Prosperi on 27/09/22.
//

import UIKit
import DropDown

extension UIColor {
    static let greenColor = UIColor(red: (3/255.0), green: (129/255.0), blue: (35/255.0), alpha: 1)
    static let redColor = UIColor(red: (166/255.0), green: (26/255.0), blue: (103/255.0), alpha: 1)
    static let blueColor = UIColor(red: (0/255.0), green: (83/255.0), blue: (141/255.0), alpha: 1)
}

enum FilterDuration: Int, CaseIterable {
    case day, week, month
    
    var text: String {
        switch self {
        case .day:
            return "1 giorno"
        case .week:
            return "7 giorni"
        case .month:
            return "30 giorni"
        }
    }
    
    var days: Int {
        switch self {
        case .day:
            return 1
        case .week:
            return 7
        case .month:
            return 30
        }
    }
}

enum FilterType: Int, CaseIterable {
    case web, privacy, navigation
    
    var title: String {
        switch self {
        case .web:
            return "Contenuti Web"
        case .privacy:
            return "Privacy"
        case .navigation:
            return "Navigazione Protetta"
        }
    }
    
    
    var description: String {
        switch self {
        case .web:
            return "Virus o minacce bloccati"
        case .privacy:
            return "Siti web bloccati"
        case .navigation:
            return "Virus o minacce bloccati"
        }
    }
        
    var mainColor: UIColor {
        switch self {
        case .web:
            return .greenColor
        case .privacy:
            return .redColor
        case .navigation:
            return .blueColor
        }
    }
    
    var selectedColor: UIColor {
        switch self {
        case .web:
            return .redColor
        case .privacy:
            return  .black //.blueColor
        case .navigation:
            return .redColor
        }
    }
    
    var topColor: UIColor {
        switch self {
        case .web:
            return .greenColor
        case .privacy:
            return .redColor
        case .navigation:
            return .blueColor
        }
    }
    
    var bottomColor: UIColor {
        switch self {
        case .web:
            return UIColor(red: 19/255.0, green: 165/255.0, blue: 56/255.0, alpha: 0.07)
        case .privacy:
            return UIColor(red: 249/255.0, green: 249/255.0, blue: 249/255.0, alpha: 0.07)
        case .navigation:
            return .white
        }
    }
    
    var gradient: CGGradient? {
        let topColor =  self.topColor.cgColor
        let bottomColor = self.bottomColor.cgColor
        let gradientColors = [topColor, bottomColor] as CFArray
        let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
        return CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
    }
    
}

class ViewController: UIViewController {
    
    @IBOutlet weak var webContentLineChartContainerView: LineChartContainerView!
    @IBOutlet weak var privacyContentLineChartContainerView: LineChartContainerView!
    @IBOutlet weak var navigationContentLineChartContainerView: LineChartContainerView!
    @IBOutlet weak var filterDurationView: UIView!
    @IBOutlet weak var filterDurationLabel: UILabel!
    @IBOutlet weak var carouselView: CarouselView!
    
    var visibleFilters: [FilterType] = [.privacy, .navigation, .web]
    
    var entries: [(x: Double, y: Double)] {
        var entries = [(x: Double, y: Double)]()
        for i in 0..<30 {
            entries.append((x: Double(i), y: Double.random(in: 5.0...20.0)))
        }
        return entries
    }
    
    var filteredEntries: [(x: Double, y: Double)] {
        return entries.suffix(filterDuration.days)
    }
    
    var filterDuration: FilterDuration = .month {
        didSet {
            filterDurationLabel.text = filterDuration.text
            refreshUI()
        }
    }
    
    lazy var filterDurationDropDown: DropDown = {
        let dropDown = DropDown()

        // The view to which the drop down will appear on
        dropDown.anchorView = filterDurationView
        dropDown.bottomOffset = CGPoint(
            x: 0,
            y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.selectRow(at: 0)
        
        // data source
        var dataSource: [String] = []
        for i in 0..<FilterDuration.allCases.count {
            if let str = FilterDuration(rawValue: i)?.text {
                dataSource.append(str)
            }
        }
        dropDown.dataSource = dataSource
        
        // appearance
        DropDown.appearance().textColor = .black
        DropDown.appearance().selectedTextColor = .greenColor
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 16)
        DropDown.appearance().backgroundColor = .white
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        DropDown.appearance().cellHeight = 60
        
        dropDown.selectionAction = { (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            if let filterDuration = FilterDuration(rawValue: index) {
                self.filterDuration = filterDuration
            }
            dropDown.hide()
        }
        return dropDown
    } ()

    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Report"
        self.navigationItem.rightBarButtonItem = nil // remove x

        setupUI()
    }
    
    //MARK: - SetupUI
    private func setupUI() {
        
        setupFilterDurationUI()
    }
    
    private func setupFilterDurationUI() {
        filterDurationView.layer.cornerRadius = 10
        filterDurationView.layer.borderColor = UIColor.lightGray.cgColor
        filterDurationView.layer.borderWidth = 1.0
        
        filterDuration = .week
    }
        
    //MARK: - Refresh Charts
    private func refreshUI() {
        refreshWebChart(entries: filteredEntries)
        refreshPrivacyChart(entries: filteredEntries)
        refreshNavigationChart(entries: filteredEntries)
        refreshCarousel(entries: filteredEntries)
    }
    
    private func refreshWebChart(entries: [(x: Double, y: Double)] ) {
        webContentLineChartContainerView.isHidden = true
        if visibleFilters.contains(.web) {
            webContentLineChartContainerView.isHidden = false
            webContentLineChartContainerView.setup(
                with: .web,
                filterDuration: self.filterDuration,
                entries: entries)
        }
    }
    
    private func refreshPrivacyChart(entries: [(x: Double, y: Double)]) {
        privacyContentLineChartContainerView.isHidden = true
        if visibleFilters.contains(.privacy) {
            privacyContentLineChartContainerView.isHidden = false
        privacyContentLineChartContainerView.setup(
            with: .privacy,
            filterDuration: self.filterDuration,
            entries: entries)
        }
    }
    
    private func refreshNavigationChart(entries: [(x: Double, y: Double)]) {
        navigationContentLineChartContainerView.isHidden = true
        if visibleFilters.contains(.navigation) {
            navigationContentLineChartContainerView.isHidden = false
            navigationContentLineChartContainerView.setup(
                with: .navigation,
                filterDuration: self.filterDuration,
                entries: entries)
        }
    }
    
    private func refreshCarousel(entries: [(x: Double, y: Double)]) {
        var items: [CarouselItem] = []
        
        for i in 0..<FilterType.allCases.count {
            if let filterType = FilterType(rawValue: i) {
                let item = CarouselItem(filterType: filterType,
                                        entries: filteredEntries)
                items.append(item)
            }
        }
        carouselView.setup(with: items, delegate: self)
    }
    
    
    //MARK: - IBActions
    @IBAction func filterDurationClick(_ sender: Any) {
        filterDurationDropDown.show()
    }
}


//MARK: - CarouselViewDelegate
extension ViewController: CarouselViewDelegate {
    func carouselView(_ carouselView: CarouselView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
    
    


