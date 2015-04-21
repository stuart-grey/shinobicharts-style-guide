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

enum RunningChartSeries: Int {
  case Pace
  case Elevation
}

typealias SeriesAxisMapping = [RunningChartSeries : SChartAxis]

class RunningChartDataSource: NSObject {
  let datapoints: [RunningChartSeries : [SChartData]]
  let axisMapping: SeriesAxisMapping
  
  init(data: [RunningTrackpoint], axisMapping: SeriesAxisMapping) {
    datapoints = [ .Elevation : data.map { $0.elevationDataPoint() },
                   .Pace :      data.map { $0.paceDataPoint() } ]
    self.axisMapping = axisMapping
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
    return datapoints[RunningChartSeries(rawValue: seriesIndex)!]?.count ?? 0
  }
  
  func sChart(chart: ShinobiChart!, dataPointAtIndex dataIndex: Int, forSeriesAtIndex seriesIndex: Int) -> SChartData! {
    return datapoints[RunningChartSeries(rawValue: seriesIndex)!]?[dataIndex]
  }
  
  func sChart(chart: ShinobiChart!, dataPointsForSeriesAtIndex seriesIndex: Int) -> [AnyObject]! {
    return datapoints[RunningChartSeries(rawValue: seriesIndex)!]
  }
  
  func sChart(chart: ShinobiChart!, yAxisForSeriesAtIndex index: Int) -> SChartAxis! {
    return axisMapping[RunningChartSeries(rawValue: index)!]
  }
}

extension RunningChartDataSource {
  static func defaultData(axisMapping: SeriesAxisMapping) -> RunningChartDataSource? {
    if let runningData = RunningTrackpoint.loadDataFromDefaultPlist() {
      return RunningChartDataSource(data: runningData, axisMapping: axisMapping)
    }
    return .None
  }
}