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



import Foundation

// CONSTANTS
private let XAxisTickLabelRelativeOffset = CGPoint(x:  0.5,  y: -1.4)
private let YAxisTickLabelRelativeOffset = CGPoint(x: -1.45, y:  0.5)

private extension UIColor {
  private static var twitterLightBlue: UIColor {
    return UIColor(red: 170/255.0, green: 213/255.0, blue: 243/255.0, alpha: 1)
  }
  
  private  static var twitterDarkBlue: UIColor {
    return UIColor(red: 51/255.0, green: 148/255.0, blue: 225/255.0, alpha: 1)
  }
  
  private static var twitterLineColor: UIColor {
    // All the lines used (axis, grid lines etc) should be the same colour
    return UIColor(white: 0.7, alpha: 1.0)
  }
}


extension SeriesStyler {
  static func blueColumnSeries() -> SChartSeries {
    //*************************//
    // Column Series Styling   //
    //*************************//
    
    // Create the column series
    let columnSeries = SChartColumnSeries()
    
    // Get hold of the SChartColumnSeriesStyle object
    let style = columnSeries.style()
    
    // Specify the colour for the columns, and that they shouldn't use gradient fill
    style.areaColor = UIColor.twitterLightBlue
    style.showAreaWithGradient = false
    
    // Get hold of the style object for when a column is selected
    let selectedStyle = columnSeries.selectedStyle()
    
    // Once again, set the colour and disable gradient fill
    selectedStyle.areaColor = UIColor.twitterDarkBlue
    selectedStyle.showAreaWithGradient = false
    
    // Set that the selection mode should be single point (as opposed to series)
    columnSeries.selectionMode = SChartSelectionPoint
    
    // We're done - hand the series back
    return columnSeries
  }
}

extension AxisStyler {
  static func twitterStatsYAxis() -> SChartAxis {
    // Create the y-axis. Vertically we're showing numbers
    let axis = SChartNumberAxis()
    
    // Want the axis to appear on the right hand side - so sets its position as reverse
    axis.axisPosition = SChartAxisPositionReverse
    
    // Don't want to 'see' this axis, so set its line width to 0
    axis.style.lineWidth = 0
    
    // Manually specify the tick frequency
    axis.majorTickFrequency = 1000
    
    // Lazy way to format the number in 1000s as k. Standard NSNumberFormatter work.
    let formatter = axis.labelFormatter.numberFormatter()
    formatter.multiplier = 0.001
    formatter.numberStyle = .DecimalStyle
    formatter.minimumFractionDigits = 1
    formatter.maximumFractionDigits = 1
    formatter.positiveSuffix = "k"
    formatter.negativeSuffix = "k"
    
    // Enable grid lines, make them "dashed" with a 1px dot style
    axis.style.majorGridLineStyle.showMajorGridLines = true
    axis.style.majorGridLineStyle.dashedMajorGridLines = true
    axis.style.majorGridLineStyle.dashStyle = [1]
    
    // Don't want any space for this axis. Not allowed to set width of 0, so 1 it is
    axis.width = 1
    
    // Add an extra padding at the top. This is measured in the axis scale.
    axis.rangePaddingHigh = 100

    return axis
  }
  
  static func twitterStatsXAxis() -> SChartAxis {
    // Create an x-axis. We're showing time
    let axis = SChartDateTimeAxis()
    
    // Only want ticks once per week
    axis.majorTickFrequency = SChartDateFrequency(week: 1)
    // Ticks marks should represent saturday. Use anchorPoint to offset them
    axis.anchorPoint = NSCalendar.midnightSaturday()
    
    // Style the axis itself. Thin line width and the appropriate colour
    axis.style.lineWidth = 0.5
    axis.style.lineColor = UIColor.twitterLineColor
    
    // Want to see tick marks. Set their colour, thickness and length
    axis.style.majorTickStyle.showTicks = true
    axis.style.majorTickStyle.lineWidth = 0.5
    axis.style.majorTickStyle.lineLength = 20
    axis.style.majorTickStyle.lineColor = UIColor.twitterLineColor
    
    // Enable grid lines as well. Also set colour and thickness.
    axis.style.majorGridLineStyle.showMajorGridLines = true
    axis.style.majorGridLineStyle.lineWidth = 0.5
    axis.style.majorGridLineStyle.lineColor = UIColor.twitterLineColor
    
    // Specify the "width" of the axis. For an x-axis this is its height.
    axis.width = 25
    
    // Configure column spacing. These values are a %age of the space available
    axis.style.interSeriesPadding = 0
    axis.style.interSeriesSetPadding = 0.2
    
    return axis
  }
  
  static func twitterRepositionXAxisTickMark(tickMark: SChartTickMark) {
    if let tickLabel = tickMark.tickLabel {
      // The x-axis tick marks need moving over to the right and upwards to their desired position.
      tickLabel.frame = tickLabel.frame.rectByOffsetting(dx:  tickLabel.bounds.width * XAxisTickLabelRelativeOffset.x,
        dy: tickLabel.bounds.height * XAxisTickLabelRelativeOffset.y)
    }
  }
  
  static func twitterRepositionYAxisTickMark(tickMark: SChartTickMark) {
    // y Axis
    if abs(tickMark.value) < 1e-4 {
      // Hide the tick mark and grid line view at origin
      tickMark.tickEnabled = false
      tickMark.gridLineView.hidden = true
    } else if let tickLabel = tickMark.tickLabel {
      // The y-axis tick marks need moving to the left and down. Note that the axis has
      // zero-width, so we're actually moving these labels outside of their container view.
      tickLabel.frame = tickLabel.frame.rectByOffsetting(dx: tickLabel.bounds.width  * YAxisTickLabelRelativeOffset.x,
        dy:  tickLabel.bounds.height * YAxisTickLabelRelativeOffset.y)
    }
  }
}


private extension NSCalendar {
  private static func midnightSaturday() -> NSDate {
    let midnightToday = NSCalendar.currentCalendar().dateBySettingHour(0, minute: 0, second: 0, ofDate: NSDate(), options: .allZeros)
    return NSCalendar.currentCalendar().dateBySettingUnit(.CalendarUnitWeekday, value: 7, ofDate: midnightToday!, options: .allZeros)!
  }
}