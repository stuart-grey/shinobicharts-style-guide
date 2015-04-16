//
// Copyright 2015 Scott Logic
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//


import UIKit

class TwitterStatsViewController: UIViewController {
  
  @IBOutlet weak var chart: ShinobiChart!
  let chartDatasource = TwitterStatsChartDataSource.defaultData()
  let chartDelegate = TwitterChartDelegate()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    if let chartDatasource = chartDatasource {
      chart.datasource = chartDatasource
    }
    chart.delegate = chartDelegate
    
    prepareChart()
  }
  
  private func prepareChart() {
    chart.backgroundColor = UIColor.clearColor()
    
    let lineColour = UIColor(white: 0.7, alpha: 1.0)
    
    let xAxis = SChartDateTimeAxis()
    xAxis.majorTickFrequency = 60*60*24*7
    xAxis.style.lineWidth = 0.5
    
    xAxis.style.majorGridLineStyle.showMajorGridLines = true
    xAxis.style.majorGridLineStyle.lineWidth = 0.5
    xAxis.style.majorGridLineStyle.lineColor = lineColour
    xAxis.style.majorTickStyle.showTicks = true
    xAxis.style.majorTickStyle.lineWidth = 0.5
    xAxis.style.majorTickStyle.lineLength = 20
    xAxis.style.majorTickStyle.lineColor = lineColour
    xAxis.style.lineColor = lineColour
    
    xAxis.width = 25
    
    // Ticks marks should represent saturday. Have to deal with daylight saving
    let midnightToday = NSCalendar.currentCalendar().dateBySettingHour(0, minute: 0, second: 0, ofDate: NSDate(), options: .allZeros)
    let anchor = NSCalendar.currentCalendar().dateBySettingUnit(.CalendarUnitWeekday, value: 1, ofDate: midnightToday!, options: .allZeros)
    xAxis.anchorPoint = anchor
    
    
    chart.xAxis = xAxis

    
    
    let yAxis = SChartNumberAxis()
    yAxis.axisPosition = SChartAxisPositionReverse
    yAxis.style.lineWidth = 0
    yAxis.majorTickFrequency = 1000
    let formatter = yAxis.labelFormatter.numberFormatter()
    formatter.multiplier = 0.001
    formatter.numberStyle = .DecimalStyle
    formatter.minimumFractionDigits = 1
    formatter.maximumFractionDigits = 1
    formatter.positiveSuffix = "k"
    formatter.negativeSuffix = "k"
    
    yAxis.style.majorGridLineStyle.showMajorGridLines = true
    yAxis.style.majorGridLineStyle.dashedMajorGridLines = true
    yAxis.style.majorGridLineStyle.dashStyle = [1]
    
    yAxis.width = 1
    yAxis.rangePaddingHigh = 100
    
    chart.yAxis = yAxis
  }
  
}

class TwitterChartDelegate: NSObject, SChartDelegate {
  func sChart(chart: ShinobiChart!, alterTickMark tickMark: SChartTickMark!, beforeAddingToAxis axis: SChartAxis!) {
    if let tickLabel = tickMark.tickLabel {
      if axis.isXAxis() {
        tickLabel.frame = tickLabel.frame.rectByOffsetting(dx: tickLabel.bounds.width * 0.5,
          dy: -tickLabel.bounds.height * 1.4)
      } else {
        // y Axis
        if abs(tickMark.value) < 1e-4 {
          // Hide the tick mark and grid line view at origin
          tickMark.tickEnabled = false
          tickMark.gridLineView.hidden = true
        } else {
          // Re-position the tick label
          tickLabel.frame = tickLabel.frame.rectByOffsetting(dx: -tickLabel.bounds.width * 1.45,
            dy: tickLabel.bounds.height / 2.0)
        }
      }
    }
  }
}
