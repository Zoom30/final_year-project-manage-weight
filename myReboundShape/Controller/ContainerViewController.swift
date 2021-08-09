//
//  ContainerViewController.swift
//  myReboundShape
//
//  Created by Daniel Ghebrat on 08/03/2021.
//

import UIKit
import Charts
import TinyConstraints
import RealmSwift

class ContainerViewController: UIViewController {
    var accessToWeightHistoryEntry : Results<WeightHistoryData>?
    
    lazy var lineChartView : LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .clear
        chartView.alpha = 0.85
        chartView.rightAxis.enabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 17)
        chartView.xAxis.axisLineColor = .systemRed
        chartView.animate(xAxisDuration: 0.75)
        
        
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 17)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .label
        yAxis.axisLineColor = .systemGreen
        
        return chartView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
       
        view.addSubview(lineChartView)
        lineChartView.width(to: view)
        lineChartView.centerInSuperview()
        lineChartView.heightToWidth(of: view)
        setData()
        
    }
    
    
    
    func setData() {
        var yValues = [ChartDataEntry]()
        let weightHistoryEntry = accessToWeightHistoryEntry
        for entry in 0...weightHistoryEntry!.count-1{
            yValues.append(ChartDataEntry(x: Double(entry), y: weightHistoryEntry![entry].weightEntry))
        }
        
        let set1 = LineChartDataSet(entries: yValues, label: "Number of entries")
        set1.drawCirclesEnabled = true
        set1.circleHoleColor = .clear
        set1.drawCircleHoleEnabled = true
        set1.circleRadius = CGFloat(5)
        set1.mode = .cubicBezier
        set1.lineWidth = 1
        
        set1.setColor(.brown)
        set1.fill = Fill(color: .systemGreen)
        set1.fillAlpha = 0.75
        set1.drawFilledEnabled = true
        let data = LineChartData(dataSet: set1)
        lineChartView.data = data
    }
    
    func loadData(){
        if let realm = try? Realm(){
            accessToWeightHistoryEntry = realm.objects(WeightHistoryData.self)
        }
    }
    
}
