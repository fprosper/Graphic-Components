//
//  LineChartContainerView.swift
//  Graphic Components
//
//  Created by Fabrizio Prosperi on 27/09/22.
//


import UIKit
import Charts
import TinyConstraints

class LineChartContainerView: NibView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
        
    // MARK: - Properties
    private var filterType: FilterType = .web {
        didSet {
            titleLabel.text = filterType.title
            descriptionLabel.text = filterType.description
        }
    }
    
    private var filterDuration: FilterDuration = .month {
        didSet {
            filterLabel.text = filterDuration.text
        }
    }
    
    private var entries: [ChartDataEntry] = []
    private var circleHoleColors = [UIColor]()
    private var resetCircleHoleColors = [UIColor]()

    lazy var lineChartView: LineChartView = {
        let lineChartView = LineChartView()
        lineChartView.delegate = self
        lineChartView.backgroundColor = .white
        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.enabled = false
        lineChartView.legend.enabled = false
        lineChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        lineChartView.xAxis.gridLineDashLengths = [5]
        lineChartView.xAxis.drawAxisLineEnabled = true
        lineChartView.xAxis.valueFormatter = DateValueFormatter(startDate: Date())
        lineChartView.pinchZoomEnabled = false
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.xAxis.drawLimitLinesBehindDataEnabled = false
        lineChartView.xAxis.drawGridLinesBehindDataEnabled = false
        lineChartView.xAxis.drawAxisLineEnabled = false        
       return lineChartView
    }()
    
    // MARK: - Public
    func setup(with filterType: FilterType,
               filterDuration: FilterDuration,
               entries: [(x: Double, y: Double)]) {
        self.filterType = filterType
        self.filterDuration = filterDuration
        
        self.entries = [] // reset existing entries
        for entry in entries {
            self.entries.append(ChartDataEntry(x: entry.x, y: entry.y))
            circleHoleColors.append(.white)
            resetCircleHoleColors.append(.white)
        }
        
        guard let lastX = self.entries.last?.x,
              let lastY = self.entries.last?.y else { return }
        
        filterLabel.layer.borderWidth = 1
        filterLabel.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        filterLabel.layer.cornerRadius = 8
        
        containerView.backgroundColor = .white
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.7
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 4
        containerView.addSubview(lineChartView)
        
        // after having added the subview, we can add constraints to it
        lineChartView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20).isActive = true
        lineChartView.width(to: containerView)
        lineChartView.height(200)
        
        lineChartView.data = data
        
        /* THIS SHOULD STAY AFTER SETTING DATA */
        switch filterDuration {
        case .day:
            lineChartView.setVisibleXRange(
                minXRange: 1,
                maxXRange: 1)
                lineChartView.moveViewToX(lastX)
        case .week:
            lineChartView.setVisibleXRange(
                minXRange: 7,
                maxXRange: 7)
                lineChartView.moveViewToX(lastX)
        case .month:
                lineChartView.setVisibleXRange(
                    minXRange: 7,
                    maxXRange: 7)
                lineChartView.moveViewToX(lastX)
        }
        
        // select last entry - call the delegate
        let highlight = Highlight(x: lastX, y: lastY, dataSetIndex: 0)
        lineChartView.highlightValue(highlight, callDelegate: true)
    }
    
    // MARK: - Private
    private var data: ChartData? {
        let dataSet = LineChartDataSet(entries: entries, label: "")
        
        dataSet.mode = .cubicBezier
        dataSet.lineWidth = 2
        dataSet.setColor(filterType.mainColor)
        
        if let gradient = filterType.gradient {
            dataSet.fill = LinearGradientFill(gradient: gradient, angle: 90.0)
            dataSet.drawFilledEnabled = true
        }
        
        dataSet.circleHoleColor = .white
        dataSet.setCircleColor(filterType.mainColor)
        dataSet.circleRadius = 6.0
        dataSet.highlightEnabled = true
        dataSet.highlightLineWidth = 40.0
        dataSet.highlightColor = UIColor.darkGray.withAlphaComponent(0.5)
        dataSet.highlightEnabled = true
        dataSet.drawValuesEnabled = false
        dataSet.drawVerticalHighlightIndicatorEnabled = true
        dataSet.drawHorizontalHighlightIndicatorEnabled = false

        return LineChartData(dataSet: dataSet)
    }
    
    // MARK: - Actions
    @IBAction func infoClick(_ sender: UIButton) {
        print("Info button clicked for type: \(filterType.title)")
    }
    
}

extension LineChartContainerView: ChartViewDelegate {
    
    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("x = \(highlight.x) y = \(highlight.y)")
        
        let value = String(Int(highlight.y))
        print("x = \(highlight.x) y = \(highlight.y) value: \(value)")

        valueLabel.text = value
        
        if let dataSet = chartView.data?.dataSets.first as? LineChartDataSet,
           let index = dataSet.entries.firstIndex(where: {$0.x == highlight.x})  {
            circleHoleColors = resetCircleHoleColors
            circleHoleColors[index] = filterType.mainColor
            dataSet.circleHoleColors = circleHoleColors
            // notify chart to update
            chartView.data?.notifyDataChanged()
            chartView.notifyDataSetChanged()
        }
    }
    
    public func chartValueNothingSelected(_ chartView: ChartViewBase) {
        if let dataSet = chartView.data?.dataSets[0] as? LineChartDataSet {
            dataSet.circleHoleColors = resetCircleHoleColors
            // notify chart to update
            chartView.data?.notifyDataChanged()
            chartView.notifyDataSetChanged()
        }
    }
    
}
