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

    if let chartDatasource = chartDatasource {
      chart.datasource = chartDatasource
    }
    chart.delegate = chartDelegate
    
    prepareChart()
  }
  
  private func prepareChart() {
    //*************************//
    // Chart Configuration     //
    //*************************//
    
    // Chart background should be transparent, not grey
    chart.backgroundColor = UIColor.clearColor()
    
    // Disable double tap to improve responsiveness of the single tap
    chart.gestureDoubleTapEnabled = false
    
    // All the lines used (axis, grid lines etc) should be the same colour
    let lineColour = UIColor(white: 0.7, alpha: 1.0)

    
    //*************************//
    // x-Axis Configuration    //
    //*************************//
    
    // Create an x-axis. We're showing time
    let xAxis = SChartDateTimeAxis()
    
    // Only want ticks once per week. The units are in seconds.
    xAxis.majorTickFrequency = 60*60*24*7
    // Ticks marks should represent saturday. Use anchorPoint to offset them
    let midnightToday = NSCalendar.currentCalendar().dateBySettingHour(0, minute: 0, second: 0, ofDate: NSDate(), options: .allZeros)
    let anchor = NSCalendar.currentCalendar().dateBySettingUnit(.CalendarUnitWeekday, value: 1, ofDate: midnightToday!, options: .allZeros)
    xAxis.anchorPoint = anchor
    
    // Style the axis itself. Thin line width and the appropriate colour
    xAxis.style.lineWidth = 0.5
    xAxis.style.lineColor = lineColour

    // Want to see tick marks. Set their colour, thickness and length
    xAxis.style.majorTickStyle.showTicks = true
    xAxis.style.majorTickStyle.lineWidth = 0.5
    xAxis.style.majorTickStyle.lineLength = 20
    xAxis.style.majorTickStyle.lineColor = lineColour
    
    // Enable grid lines as well. Also set colour and thickness.
    xAxis.style.majorGridLineStyle.showMajorGridLines = true
    xAxis.style.majorGridLineStyle.lineWidth = 0.5
    xAxis.style.majorGridLineStyle.lineColor = lineColour

    // Specify the "width" of the axis. For an x-axis this is its height.
    xAxis.width = 25
    
    // Configure column spacing. These values are a %age of the space available
    xAxis.style.interSeriesPadding = 0
    xAxis.style.interSeriesSetPadding = 0.2
    
    // Finally, hand this axis to the chart
    chart.xAxis = xAxis
    
    
    //*************************//
    // y-Axis Configuration    //
    //*************************//
    
    // Create the y-axis. Vertically we're showing numbers
    let yAxis = SChartNumberAxis()
    
    // Want the axis to appear on the right hand side - so sets its position as reverse
    yAxis.axisPosition = SChartAxisPositionReverse
    
    // Don't want to 'see' this axis, so set its line width to 0
    yAxis.style.lineWidth = 0
    
    // Manually specify the tick frequency
    yAxis.majorTickFrequency = 1000
    
    // Lazy way to format the number in 1000s as k. Standard NSNumberFormatter work.
    let formatter = yAxis.labelFormatter.numberFormatter()
    formatter.multiplier = 0.001
    formatter.numberStyle = .DecimalStyle
    formatter.minimumFractionDigits = 1
    formatter.maximumFractionDigits = 1
    formatter.positiveSuffix = "k"
    formatter.negativeSuffix = "k"
    
    // Enable grid lines, make them "dashed" with a 1px dot style
    yAxis.style.majorGridLineStyle.showMajorGridLines = true
    yAxis.style.majorGridLineStyle.dashedMajorGridLines = true
    yAxis.style.majorGridLineStyle.dashStyle = [1]
    
    // Don't want any space for this axis. Not allowed to set width of 0, so 1 it is
    yAxis.width = 1
    
    // Add an extra padding at the top. This is measured in the axis scale.
    yAxis.rangePaddingHigh = 100
    
    // Provide the axis to the chart as the y-axis
    chart.yAxis = yAxis
  }
}

class TwitterChartDelegate: NSObject, SChartDelegate {
  // This method is called as tick marks are drawn on the chart. It's used here
  // to both hide tick marks we don't want, and to reposition the ones we do.
  func sChart(chart: ShinobiChart!, alterTickMark tickMark: SChartTickMark!,
              beforeAddingToAxis axis: SChartAxis!) {
    if let tickLabel = tickMark.tickLabel {
      
      if axis.isXAxis() {
        // The x-axis tick marks need moving over to the right and upwards to their desired position.
        tickLabel.frame = tickLabel.frame.rectByOffsetting(dx:  tickLabel.bounds.width  * 0.5,
                                                           dy: -tickLabel.bounds.height * 1.4)
      } else {
        
        // y Axis
        if abs(tickMark.value) < 1e-4 {
          // Hide the tick mark and grid line view at origin
          tickMark.tickEnabled = false
          tickMark.gridLineView.hidden = true
        } else {
          // The y-axis tick marks need moving to the left and down. Note that the axis has
          // zero-width, so we're actually moving these labels outside of their container view.
          tickLabel.frame = tickLabel.frame.rectByOffsetting(dx: -tickLabel.bounds.width  * 1.45,
                                                             dy:  tickLabel.bounds.height / 2.0)
        }
      }
    }
  }
}
