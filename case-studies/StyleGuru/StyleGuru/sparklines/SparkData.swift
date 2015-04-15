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

struct HealthSpark {
  let date: NSDate
  let flights: Int
  let steps: Int
  let walkingDistance: Double
  let cyclingDistance: Double
}

extension HealthSpark {
  private init?(dict: [String : AnyObject]) {
    if let date = dict["date"] as? NSDate,
      let flights = dict["flights"] as? Int,
      let steps = dict["steps"] as? Int,
      let walkingDistance = dict["walkingDistance"] as? Double,
      let cyclingDistance = dict["cyclingDistance"] as? Double {
        self.init(date: date, flights: flights, steps: steps,
             walkingDistance: walkingDistance, cyclingDistance: cyclingDistance)
    } else {
      return nil
    }
  }
}

extension HealthSpark {
  static func loadDataFromPlistNamed(name: String) -> [HealthSpark]? {
    if let path = NSBundle.mainBundle().pathForResource(name, ofType: "plist"),
      let array = NSArray(contentsOfFile: path) as? [[String: AnyObject]] {
        return array.map { HealthSpark(dict: $0)! }
    }
    return .None
  }
  
  static func loadDataFromDefaultPlist() -> [HealthSpark]? {
    return HealthSpark.loadDataFromPlistNamed("healthspark")
  }
}

extension HealthSpark {
  func flightsDataPoint() -> SChartData {
    return generateDataPoint(flights)
  }
  
  func stepsDataPoint() -> SChartData {
    return generateDataPoint(steps)
  }
  
  func walkingDistanceDataPoint() -> SChartData {
    return generateDataPoint(walkingDistance)
  }
  
  func cyclingDistanceDataPoint() -> SChartData {
    return generateDataPoint(cyclingDistance)
  }
  
  private func generateDataPoint(yValue: AnyObject) -> SChartData {
    let dp = SChartDataPoint()
    dp.xValue = date
    dp.yValue = yValue
    return dp
  }
}
