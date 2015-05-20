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

class RunningViewController: UIViewController {
  
  @IBOutlet weak var chart: ShinobiChart!
  var chartDatasource : RunningChartDataSource?
  var chartDelegate : RunningChartDelegate?

  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let axisMapping = prepareChart()
    chartDatasource = RunningChartDataSource.defaultData(axisMapping)
    chartDelegate = RunningChartDelegate(axisMapping: axisMapping)
    
    if let chartDatasource = chartDatasource {
        chart.datasource = chartDatasource
    }
    
    chart.delegate = chartDelegate
  }

  private func prepareChart() -> SeriesAxisMapping {
    chart.xAxis = AxisStyler.runningXAxis()
    
    let elevationAxis = AxisStyler.runningElevationYAxis()
    chart.addYAxis(elevationAxis)
    
    let paceAxis = AxisStyler.runningPaceYAxis()
    chart.addYAxis(paceAxis)
    
    return [.Pace      : paceAxis,
            .Elevation : elevationAxis]
  }
}


class RunningChartDelegate: NSObject, SChartDelegate {
  private let axisMapping: SeriesAxisMapping
  
  init(axisMapping: SeriesAxisMapping) {
    self.axisMapping = axisMapping
    super.init()
  }
  
  // This method is called as tick marks are drawn on the chart. It's used here
  // to both hide tick marks we don't want, and to reposition the ones we do.
  func sChart(chart: ShinobiChart!, alterTickMark tickMark: SChartTickMark!,
    beforeAddingToAxis axis: SChartAxis!) {
      if !axis.visibleRange().contains(tickMark.value) {
        tickMark.disableTick(axis)
        if let tickMarkView = tickMark.tickMarkView {
          tickMarkView.hidden = true
        }
      }
      
      if let chartSeries = runningChartSeriesForAxis(axisMapping, axis) {
        switch chartSeries {
        case .Elevation:
          break
        case .Pace:
          AxisStyler.negateTickMarkLabelsForTickMark(tickMark, axis: axis)
        }
      }
  }
}
