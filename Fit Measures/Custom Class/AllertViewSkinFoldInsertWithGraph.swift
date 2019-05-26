//
//  AllertViewPlicheInsertdWithGraph.swift
//  Fit Measures
//
//  Created by Alberto Lunardini on 07/12/2018.
//  Copyright © 2018 Alberto Lunardini. All rights reserved.
//

protocol AllertViewSkinFoldInsertWithGraphDelegate : class {
    func okAcceptMesure()
    //   func takeMeasureAgain()
}
import UIKit
import Charts
class AllertViewSkinFoldInsertWithGraph: UIViewController, ChartViewDelegate {
    @IBOutlet weak var alertView: CustomViewDoubleColor!
    // @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet var pieChartView: PieChartView!
    @IBOutlet var barChartView: BarChartView!
    @IBOutlet var methodLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var denidtyLabel: UILabel!
    @IBOutlet var fatLabel: UILabel!
    @IBOutlet var notPurchasedLabel: UILabel!
    
    var bodyDensity : Double!
    var bodyWeight : Double!
    var bodyFatPerc : Double!
    var method : String!
    
    var weightArray : [Double] = [] 
    var plicheMethod = PlicheMethods.jackson_7//
    var delegatePieChart: AllertViewSkinFoldInsertWithGraphDelegate?
    var selectedOption = "First"
    let alertViewGrayColor = StaticClass.alertViewHeaderColor
    let nome = [loc("LOCALlean"), loc("LOCALfat")]
    var plicheMeasure : [Double] = []
    var plichePoint : [String] = []
    var dictPlicheValue : [String:Double] = [:]
    override func viewDidLoad() {
        super.viewDidLoad() 
        weightLabel.text = String(format: "%.1f", bodyWeight) + " " + UserDefaultsSettings.weightUnitSet
        denidtyLabel.text = String(format: "%.2f", bodyDensity) + " g/cc"
        fatLabel.text = String(format: "%.3f", bodyFatPerc) + " %"
        methodLabel.text = method
        plichePoint = Array(dictPlicheValue.keys)
        plicheMeasure = Array(dictPlicheValue.values)
        plichePoint.insert("", at: 0)
        setupPieChart()
        setupBarChart()
        notPurchasedLabel.layer.cornerRadius = 5
        notPurchasedLabel.layer.borderWidth = 2
        notPurchasedLabel.layer.borderColor = UIColor.white.cgColor
        showHideNotPurchaseLabel()
    }
    
    
    func setupPieChart() {
        
        pieChartView.delegate = self
        pieChartView.holeColor = .clear 
        pieChartView.legend.enabled = true
        pieChartView.setExtraOffsets(left: 20, top: 0, right: 20, bottom: 0)
        pieChartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        let l = pieChartView.legend
        l.enabled = false
        setDataCount()
    }
    
    
    
    
    func setDataCount() {
        var pieChartEntry = [PieChartDataEntry]()
        for (index, attr) in weightArray.enumerated() {
            let n = nome[index]
            let v = attr
            pieChartEntry.append(PieChartDataEntry(value: v, label: n))
        }
        let set = PieChartDataSet(values: pieChartEntry, label: "dddd")
        set.sliceSpace = 2
        set.colors = [StaticClass.blueLean,StaticClass.redFat]
        set.valueLinePart1OffsetPercentage = 0.8
        set.valueLinePart1Length = 0.4
        set.valueLinePart2Length = 0.6
        set.yValuePosition = .outsideSlice
        set.valueLineColor = .white
        let data = PieChartData(dataSet: set)
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " " + UserDefaultsSettings.weightUnitSet
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.white)
        pieChartView.data = data
        pieChartView.highlightValues(nil)
    }
    
    func setupBarChart() {
        barChartView.delegate = self
        barChartView.drawBarShadowEnabled = false
        barChartView.drawValueAboveBarEnabled = false
        barChartView.maxVisibleCount = 60
        barChartView.dragEnabled = false
        barChartView.setScaleEnabled(false)
        barChartView.pinchZoomEnabled = false
        
        let xAxis = barChartView.xAxis
        xAxis.drawGridLinesEnabled = false
        
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        xAxis.labelRotationAngle = 45
        xAxis.labelTextColor = .white
        xAxis.valueFormatter = IndexAxisValueFormatter(values:plichePoint)
        
        let rightAxis = barChartView.rightAxis
        rightAxis.drawGridLinesEnabled = false
        rightAxis.drawLabelsEnabled = false
        
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.negativeSuffix = " mm"
        leftAxisFormatter.positiveSuffix = " mm"
        
        let leftAxis = barChartView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = plicheMeasure.count
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0
        leftAxis.labelTextColor = .white 
         
        let l = barChartView.legend
        l.enabled = false
        
        let marker = XYMarkerView(color: UIColor(white: 180/250, alpha: 1),
                                  font: .systemFont(ofSize: 12),
                                  textColor: .white,
                                  insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8),
                                  xAxisValueFormatter: barChartView.xAxis.valueFormatter!)
        marker.chartView = barChartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        barChartView.marker = marker
        barChartView.animate(yAxisDuration: 1.4, easingOption: .easeOutBack)
        barChartView.reloadInputViews()
        
        
        setDataCountBarChart()
    }
    
    func setDataCountBarChart() {
        var lineChartEntry = [BarChartDataEntry]()
        for (index, doubleValue) in plicheMeasure.enumerated() {
            let value = doubleValue 
            lineChartEntry.append(BarChartDataEntry(x:Double(index)+1, y: value))
            
        }
        let set1 = BarChartDataSet(values: lineChartEntry, label: "suca")
        set1.colors = ChartColorTemplates.joyful()
        set1.drawValuesEnabled = true
        let data = BarChartData(dataSet: set1)
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
        data.barWidth = 0.9
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .decimal
        pFormatter.maximumFractionDigits = 3
        pFormatter.multiplier = 1
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.white)
        barChartView.data = data
        barChartView.highlightValues(nil)
        barChartView.data = data
        barChartView.notifyDataSetChanged()  }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
        okButton.addBorder(color: alertViewGrayColor, width: 1)  
        
    }
    
    func setupView() {
        alertView.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }
    
    func showHideNotPurchaseLabel(){
        if !UserDefaults.standard.bool(forKey: "fred76.com.ifit.skinFolds.unlock") {
            switch plicheMethod {
            case .jackson_7:notPurchasedLabel.isHidden = false
            case .jackson_3_Man:notPurchasedLabel.isHidden = false
            case .jackson_3_Woman:notPurchasedLabel.isHidden = false
            case .sloanMen:notPurchasedLabel.isHidden = false
            case .sloanWoman:notPurchasedLabel.isHidden = false
            case .DurninMan:notPurchasedLabel.isHidden = true
                
            }
        } else {
            notPurchasedLabel.isHidden = true
        }
    }
    
    @IBAction func onTapOkButton(_ sender: Any) {
        
        delegatePieChart?.okAcceptMesure()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}


