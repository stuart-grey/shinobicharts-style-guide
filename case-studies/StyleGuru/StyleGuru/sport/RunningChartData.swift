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


class RunningChartDataSource: NSObject {
  let datapoints: [[SChartData]]
  
  init(data: [RunningTrackpoint]) {
    datapoints = [ data.map { $0.elevationDataPoint() },
                   data.map { $0.paceDataPoint() } ]
    super.init()
  }
}

extension RunningChartDataSource : SChartDatasource {
  func numberOfSeriesInSChart(chart: ShinobiChart!) -> Int {
    return datapoints.count
  }
  
  func sChart(chart: ShinobiChart!, seriesAtIndex index: Int) -> SChartSeries! {
    return SChartLineSeries()
  }
  
  func sChart(chart: ShinobiChart!, numberOfDataPointsForSeriesAtIndex seriesIndex: Int) -> Int {
    return datapoints[seriesIndex].count
  }
  
  func sChart(chart: ShinobiChart!, dataPointAtIndex dataIndex: Int, forSeriesAtIndex seriesIndex: Int) -> SChartData! {
    return datapoints[seriesIndex][dataIndex]
  }
  
  func sChart(chart: ShinobiChart!, dataPointsForSeriesAtIndex seriesIndex: Int) -> [AnyObject]! {
    return datapoints[seriesIndex]
  }
}

extension RunningChartDataSource {
  static func defaultData() -> RunningChartDataSource? {
    if let runningData = RunningTrackpoint.loadDataFromDefaultPlist() {
      return RunningChartDataSource(data: runningData)
    }
    return .None
  }
}