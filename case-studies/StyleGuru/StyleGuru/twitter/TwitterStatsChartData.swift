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

class TwitterStatsChartDataSource: NSObject {
  let datapoints: [SChartData]
  
  init(data: [TwitterImpressionCount]) {
    datapoints = data.map { $0.shinobiDataPoint() }
    super.init()
  }
}

extension TwitterStatsChartDataSource : SChartDatasource {
  func numberOfSeriesInSChart(chart: ShinobiChart!) -> Int {
    return 1
  }
  
  func sChart(chart: ShinobiChart!, seriesAtIndex index: Int) -> SChartSeries! {
    //*************************//
    // Column Series Styling   //
    //*************************//
    
    // Create the column series
    let columnSeries = SChartColumnSeries()
    
    // Get hold of the SChartColumnSeriesStyle object
    let style = columnSeries.style()
    
    // Specify the colour for the columns, and that they shouldn't use gradient fill
    style.areaColor = UIColor(red: 170/255.0, green: 213/255.0, blue: 243/255.0, alpha: 1)
    style.showAreaWithGradient = false
    
    // Get hold of the style object for when a column is selected
    let selectedStyle = columnSeries.selectedStyle()
    
    // Once again, set the colour and disable gradient fill
    selectedStyle.areaColor = UIColor(red: 51/255.0, green: 148/255.0, blue: 225/255.0, alpha: 1)
    selectedStyle.showAreaWithGradient = false
    
    // Set that the selection mode should be single point (as opposed to series)
    columnSeries.selectionMode = SChartSelectionPoint
    
    // We're done - hand the series back
    return columnSeries
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

extension TwitterStatsChartDataSource {
  static func defaultData() -> TwitterStatsChartDataSource? {
    if let twitterStats = TwitterImpressionCount.loadDataFromDefaultPlist() {
      return TwitterStatsChartDataSource(data: twitterStats)
    }
    return .None
  }
}
