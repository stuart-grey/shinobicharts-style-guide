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


struct RunningTrackpoint {
  let time: NSDate
  let distance: Float
  let elevation: Float
  let pace: Float
}

extension RunningTrackpoint {
  init?(dict: NSDictionary) {
    if let time = dict["time"] as? NSDate,
      let distance = dict["distance"] as? Float,
      let elevation = dict["elevation"] as? Float,
      let pace = dict["pace"] as? Float
      where distance.isFinite && elevation.isFinite && pace.isFinite {
        self.init(time: time, distance: distance, elevation: elevation, pace: pace)
    } else {
      return nil
    }
  }
}

extension RunningTrackpoint {
  static func loadDataFromPlistNamed(name: String) -> [RunningTrackpoint]? {
    if let path = NSBundle.mainBundle().pathForResource(name, ofType: "plist"),
      let array = NSArray(contentsOfFile: path) as? [NSDictionary] {
        return array.map { RunningTrackpoint(dict: $0) }
                    .filter { $0 != nil }
                    .map { $0! }
    }
    return .None
  }
  
  static func loadDataFromDefaultPlist() -> [RunningTrackpoint]? {
    return RunningTrackpoint.loadDataFromPlistNamed("running-data")
  }
}

extension RunningTrackpoint {
  func elevationDataPoint() -> SChartDataPoint {
    let dp = SChartDataPoint()
    dp.xValue = distance
    dp.yValue = elevation
    return dp
  }
  
  func paceDataPoint() -> SChartDataPoint {
    let dp = SChartDataPoint()
    dp.xValue = distance
    // Negate this value so that the axis will plot the "correct" way round
    dp.yValue = -pace
    return dp
  }
}
