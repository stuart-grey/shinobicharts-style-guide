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

struct TwitterImpressionCount {
  let date: NSDate
  let impressions: Int
}

extension TwitterImpressionCount {
  init?(dict: NSDictionary) {
    if let date = dict["date"] as? NSDate,
      let impressions = dict["impressions"] as? Int {
        self.init(date: date, impressions: impressions)
    } else {
      return nil
    }
  }
}

extension TwitterImpressionCount {
  static func loadDataFromPlistNamed(name: String) -> [TwitterImpressionCount]? {
    if let path = NSBundle.mainBundle().pathForResource(name, ofType: "plist"),
      let array = NSArray(contentsOfFile: path) as? [NSDictionary] {
        return array.map { TwitterImpressionCount(dict: $0)! }
    }
    return .None
  }

  static func loadDataFromDefaultPlist() -> [TwitterImpressionCount]? {
    return TwitterImpressionCount.loadDataFromPlistNamed("TwitterImpressions")
  }
}

extension TwitterImpressionCount {
  func shinobiDataPoint() -> SChartDataPoint {
    let dp = SChartDataPoint()
    dp.xValue = date
    dp.yValue = impressions
    return dp
  }
}
