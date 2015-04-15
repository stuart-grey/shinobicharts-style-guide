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

enum SparkChartType {
  case Steps
  case Flights
  case WalkingDistance
  case CyclingDistance
  
  static var allValues: [SparkChartType] = [.Steps, .Flights, .WalkingDistance, .CyclingDistance]
}

class SparkChartDatasource: NSObject {
  let datapoints: [SChartData]
  
  init(data: [HealthSpark], chartType: SparkChartType) {
    datapoints = data.map {
      switch chartType {
      case .Steps:
        return $0.stepsDataPoint()
      case .Flights:
        return $0.flightsDataPoint()
      case .WalkingDistance:
        return $0.walkingDistanceDataPoint()
      case .CyclingDistance:
        return $0.cyclingDistanceDataPoint()
      }
    }
    super.init()
  }
}

extension SparkChartDatasource : SChartDatasource {
  func numberOfSeriesInSChart(chart: ShinobiChart!) -> Int {
    return 1
  }
  
  func sChart(chart: ShinobiChart!, seriesAtIndex index: Int) -> SChartSeries! {
    return SChartLineSeries()
  }
  
  func sChart(chart: ShinobiChart!, numberOfDataPointsForSeriesAtIndex seriesIndex: Int) -> Int {
    return datapoints.count
  }
  
  func sChart(chart: ShinobiChart!, dataPointAtIndex dataIndex: Int, forSeriesAtIndex seriesIndex: Int) -> SChartData! {
    return datapoints[dataIndex]
  }
  
  func sChart(chart: ShinobiChart!, dataPointsForSeriesAtIndex seriesIndex: Int) -> [AnyObject]! {
    return datapoints
  }
}

extension SparkChartDatasource {
  static func defaultData(chartType: SparkChartType) -> SparkChartDatasource? {
    if let sparkData = HealthSpark.loadDataFromDefaultPlist() {
      return SparkChartDatasource(data: sparkData, chartType: chartType)
    }
    return .None
  }
}

