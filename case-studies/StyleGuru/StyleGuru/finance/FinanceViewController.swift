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

class FinanceViewController: UIViewController {
  
  @IBOutlet weak var chart: ShinobiChart!
  let chartDatasource = FinanceChartDataSource.defaultData()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    if let chartDatasource = chartDatasource {
      chart.datasource = chartDatasource
    }
    prepareChart()
  }
  
  private func prepareChart() {
    let xAxis = SChartDateTimeAxis()
    chart.xAxis = xAxis
    
    let yAxis = SChartNumberAxis()
    chart.yAxis = yAxis
  }
  
}
