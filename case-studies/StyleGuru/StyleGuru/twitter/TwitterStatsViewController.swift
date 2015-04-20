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
    // Chart background should be transparent, not grey
    chart.backgroundColor = UIColor.clearColor()
    
    // Disable double tap to improve responsiveness of the single tap
    chart.gestureDoubleTapEnabled = false
    
    // Finally, hand this axis to the chart
    chart.xAxis = AxisStyler.twitterStatsXAxis()
    
    // Provide the axis to the chart as the y-axis
    chart.yAxis = AxisStyler.twitterStatsYAxis()
  }
}

class TwitterChartDelegate: NSObject, SChartDelegate {
  // This method is called as tick marks are drawn on the chart. It's used here
  // to both hide tick marks we don't want, and to reposition the ones we do.
  func sChart(chart: ShinobiChart!, alterTickMark tickMark: SChartTickMark!,
              beforeAddingToAxis axis: SChartAxis!) {
    if axis.isXAxis() {
      AxisStyler.twitterRepositionXAxisTickMark(tickMark)
    } else {
      AxisStyler.twitterRepositionYAxisTickMark(tickMark)
    }
  }
}
