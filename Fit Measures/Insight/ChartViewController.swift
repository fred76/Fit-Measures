//
//  ChartViewController.swift
//  Fit Measures
//
//  Created by Alberto Lunardini on 04/12/2018.
//  Copyright © 2018 Alberto Lunardini. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet var viewToRender: CustomViewDoubleColor!
    @IBOutlet var labelName: UILabel!
    var dateArray : [NSDate] = []
    var userMeasurement : [Double] = []
    var dateAsDouble : [Double] = []
    var dateArrayOverlay : [NSDate] = []
    var dateAsDoubleOverlay : [Double] = []
    var overlayGraph : [Double] = []
    var data = LineChartData()
    var set2 = LineChartDataSet()
    var maxLim: Double!
    var minLim: Double!
    var leftAxis : YAxis!
    var weightButtonisHidden : Bool = false
    var weightButtonTitle : String! = loc("LOCALOverlayWeight")
    
    @IBOutlet var weightButton: UIButton!
    var insightMainController : InsightMainController!
    @IBOutlet weak var chartView: LineChartView!
    var titleGraph : String! = "Non passa"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weightButton.isHidden = weightButtonisHidden
        weightButton.setTitle((weightButtonTitle),for: .normal)
        
//        let last = overlayGraph.last ?? 0
//        let add = userMeasurement.count-overlayGraph.count
//        for _ in 0..<add { overlayGraph.append(last) }
        labelName.text = titleGraph

                maxLim = userMeasurement.max()! + 5
                minLim = userMeasurement.min()! - 5
        chartSetup()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppUtility.lockOrientation(.landscapeLeft, andRotateTo: .landscapeLeft)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AppUtility.lockOrientation(.all, andRotateTo: .portrait)
    }
    var ds : [String] = []
    var isWeight : Bool = false
    
    @IBAction func shareButton(_ sender: Any) {
        shareImage()
    }
    
    
    @IBAction func togleWeight(_ sender: Any) {
        isWeight = !isWeight
        if isWeight{
            data.addDataSet(set2)
            let max = (userMeasurement+overlayGraph).max()! + 10
            let min = (userMeasurement+overlayGraph).min()! - 10
            maxLim = max
            minLim = min 
            chartView.animate(xAxisDuration: 2)
            chartView.setNeedsDisplay()
            let range = (dateArray.first! as Date)...(dateArray.last! as Date)
            
            if let dateGirthFirst = dateArrayOverlay.first, let dateGirthLast = dateArrayOverlay.last, let datePlicheFirst = dateArray.first, let datePlicheLast = dateArray.last  {
          
                let dateGirthFirstString = StaticClass.dateFormat(d: dateGirthFirst)
                let dateGirthLastString = StaticClass.dateFormat(d: dateGirthLast)
                let datePlicheFirstString = StaticClass.dateFormat(d: datePlicheFirst)
                let datePlicheLastString = StaticClass.dateFormat(d: datePlicheLast)
                if !range.contains(dateArrayOverlay.first! as Date) && !range.contains(dateArrayOverlay.last! as Date) {
                    let text1 = loc("First Girth's date: ")
                    let text2 = loc("Last Girth's date: ")
                    let text3 = loc("Are not in range with first Skinfold's date: ")
                    let text4 = loc("last Skinfold's date: ")
                    DataManager.shared.allertWithParameter(title: """
                        \(text1) \(dateGirthFirstString)
                        &
                        \(text2)\(dateGirthLastString)
                        """, message: """
                        \(text3)\(datePlicheFirstString)
                        &
                        \(text4)\(datePlicheLastString)
                        """, viecontroller: self)
                }
            }
          
            
           
            
        } else {
            data.removeDataSet(set2)
            maxLim = userMeasurement.max()! + 5
            minLim = userMeasurement.min()! - 5
            chartView.animate(xAxisDuration: 2)
        }
        leftAxis.resetCustomAxisMax()
        leftAxis.axisMaximum = maxLim
        leftAxis.axisMinimum = minLim
        chartView.notifyDataSetChanged()
    }
    
    @objc open func getChartImage(transparent: Bool, color : UIColor) -> UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(viewToRender.bounds.size, true, 1)
        guard let context = UIGraphicsGetCurrentContext()
            else { return nil }
        viewToRender.layer.render(in: context)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func shareImage(){
        
        let t = getChartImage(transparent: true, color: StaticClass.alertViewBackgroundColor)
        let vc = UIActivityViewController(activityItems: [t!], applicationActivities: [])
        vc.excludedActivityTypes = [
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo,
            UIActivity.ActivityType.postToTwitter,
            UIActivity.ActivityType.openInIBooks,
            UIActivity.ActivityType.postToFacebook,
            UIActivity.ActivityType.airDrop,
            UIActivity.ActivityType.mail
        ]
        present(vc, animated: true, completion: nil)
    }
    
    
    func chartSetup() {
        for i in dateArray {
            
            let t = StaticClass.dateFromNSDateSince1970(i)
            dateAsDouble.append(t)
            let s = StaticClass.dateFormat(d: i)
            ds.append(s)
        }
        
        for i in dateArrayOverlay {
            let t = StaticClass.dateFromNSDateSince1970(i)
            dateAsDoubleOverlay.append(t)
            let s = StaticClass.dateFormat(d: i)
            ds.append(s)
        }
        
        
        chartView.delegate = self
        
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        chartView.drawBordersEnabled = false
        chartView.legend.form = .line 
        
        
        leftAxis = chartView.leftAxis
        
        leftAxis.removeAllLimitLines()
        leftAxis.axisMaximum = maxLim
        leftAxis.axisMinimum = minLim
        leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled = false
        leftAxis.enabled = true
        leftAxis.labelTextColor = .white
        
        let rightAxis = chartView.rightAxis
        rightAxis.enabled = false
        rightAxis.labelTextColor = .white
        
        let xAxis = chartView.xAxis
        xAxis.enabled = true
        xAxis.valueFormatter = DateValueFormatter()
        xAxis.centerAxisLabelsEnabled = false
        xAxis.drawLimitLinesBehindDataEnabled = true
        xAxis.granularityEnabled = true
        xAxis.granularity = 1
        xAxis.avoidFirstLastClippingEnabled = false
        xAxis.labelCount = dateAsDouble.count
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        
        //        let xValuesNumberFormatter = ChartXAxisFormatter()
        //        xValuesNumberFormatter.dateFormatter = dateFormatter // e.g. "wed 26"
        //        xAxis.valueFormatter = xValuesNumberFormatter
        xAxis.labelTextColor = .white
        
        setDataCount()
    }
    
    func setDataCount() {
        var allline = [LineChartDataSet]()
        var lineChartEntry = [ChartDataEntry]()
        
        for (index, doubleValue) in dateAsDouble.enumerated() {
            let datetime = doubleValue
            let measure: Double = userMeasurement[index]
            lineChartEntry.append(ChartDataEntry(x: datetime, y: measure))
        }
        var lineChartEntry1 = [ChartDataEntry]()
        
        for (index, doubleValue) in dateAsDoubleOverlay.enumerated() {
            let datetime = doubleValue
            let measure: Double = overlayGraph[index]
            lineChartEntry1.append(ChartDataEntry(x: datetime, y: measure))
        }
        
        
        
        let values = lineChartEntry
        let values1 = lineChartEntry1
        let set1 = LineChartDataSet(values: values, label: titleGraph)
        set2 = LineChartDataSet(values: values1, label: weightButtonTitle)
        allline.append(set1)
        allline.append(set2)
        set1.drawIconsEnabled = true 
        set1.lineDashLengths = [5, 2.5]
        set1.highlightLineDashLengths = [5, 2.5]
        set1.setColor(.white)
        set1.setCircleColor(.orange)
        set1.lineWidth = 1
        set1.circleRadius = 3
        set1.drawCircleHoleEnabled = false
        set1.valueFont = .systemFont(ofSize: 9)
        set1.formLineDashLengths = [5, 2.5]
        set1.formLineWidth = 1
        set1.formSize = 15
        set1.drawCirclesEnabled = true
        set1.valueTextColor = .white
        
        set2.drawIconsEnabled = true
        
        //        set2.lineDashLengths = [5, 2.5]
        //        set2.highlightLineDashLengths = [5, 2.5]
        set2.setColor(.orange)
        set2.setCircleColor(.blue)
        set2.lineWidth = 2
        set2.circleRadius = 3
        set2.drawCircleHoleEnabled = false
        set2.valueFont = .systemFont(ofSize: 9)
        //        set2.formLineDashLengths = [5, 2.5]
        //        set2.formLineWidth = 1
        set2.formSize = 15
        set2.drawCirclesEnabled = true
        set2.valueTextColor = .white
        
        
        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
                                   font: .systemFont(ofSize: 12),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        
        chartView.marker = marker 
        
        let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
                              ChartColorTemplates.colorFromString("#ffff0000").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        set1.fillAlpha = 1
        set1.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
        set1.drawFilledEnabled = true
        
        set2.fillAlpha = 1
        set2.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
        set2.drawFilledEnabled = false
        
        
        
        data = LineChartData(dataSets: [set1])
        
        data.notifyDataChanged()
        data.setValueFormatter(DigitValueFormatterDouble())
        
        //chartView.animate(xAxisDuration: 2)
        chartView.animate(yAxisDuration: 2)
        chartView.data = data
        
    }
    
    
}


public class DateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter .dateStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "dd/MM/yy"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}


class DigitValueFormatterDouble : NSObject, IValueFormatter {
    
    func stringForValue(_ value: Double,
                        entry: ChartDataEntry,
                        dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String {
        let valueWithoutDecimalPart = String(format: "%.2f", value)
        return "\(valueWithoutDecimalPart)"
    }
}


class ChartXAxisFormatter: NSObject {
    var dateFormatter: DateFormatter?
}





