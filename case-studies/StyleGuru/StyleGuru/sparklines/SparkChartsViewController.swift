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

class SparkChartsViewController: UIViewController {
  
  @IBOutlet var charts: [ShinobiChart]!
  var chartDatasources = [SparkChartDatasource]()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    for chartType in SparkChartType.allValues {
      chartDatasources.append(SparkChartDatasource.defaultData(chartType)!)
    }
    
    for i in 0..<charts.count {
      charts[i].datasource = chartDatasources[i]
    }
    
    prepareCharts()
    
  }
  
  private func prepareCharts() {
    for chart in charts {
      let xAxis = SChartDateTimeAxis()
      chart.xAxis = xAxis
      
      let yAxis = SChartNumberAxis()
      chart.yAxis = yAxis
    }
  }

}
