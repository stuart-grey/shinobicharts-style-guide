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


class FinanceChartDataSource: NSObject {
  let datapoints: [[SChartData]]
  
  init(data: [FinanceDataPoint]) {
    datapoints = [ data.map { $0.priceDataPoint() },
                   data.map { $0.volumeDataPoint() }]
    super.init()
  }
}

extension FinanceChartDataSource : SChartDatasource {
  func numberOfSeriesInSChart(chart: ShinobiChart!) -> Int {
    return datapoints.count
  }
  
  func sChart(chart: ShinobiChart!, seriesAtIndex index: Int) -> SChartSeries! {
    switch index {
    case 0:
      return SChartOHLCSeries()
    default:
      return SChartLineSeries()
    }
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

extension FinanceChartDataSource {
  static func defaultData() -> FinanceChartDataSource? {
    if let financeData = FinanceDataPoint.loadDataFromDefaultCSV() {
      return FinanceChartDataSource(data: financeData)
    }
    return .None
  }
}
