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
import SwiftCSV

private let numberParser = NSNumberFormatter()
private let dateParser = NSDateFormatter()

struct FinanceDataPoint {
  let date: NSDate
  let open: Float
  let high: Float
  let low: Float
  let close: Float
  let volume: Int
}

extension FinanceDataPoint {
  private init?(stringDict: [String : String]) {
    if let dateString = stringDict["Date"],
      let openString = stringDict["Open"],
      let highString = stringDict["High"],
      let lowString = stringDict["Low"],
      let closeString = stringDict["Close"],
      let volumeString = stringDict["Volume"] {
        self.init(stringDate: dateString, stringOpen: openString, stringHigh: highString,
          stringLow: lowString, stringClose: closeString, stringVolume: volumeString)
    } else {
      return nil
    }
  }
  
  private init?(stringDate: String, stringOpen: String, stringHigh: String, stringLow: String,
    stringClose: String, stringVolume: String) {
      dateParser.dateFormat = "yyyy'-'MM'-'dd"
      if let date = dateParser.dateFromString(stringDate),
        let open = numberParser.numberFromString(stringOpen) as? Float,
        let high = numberParser.numberFromString(stringHigh) as? Float,
        let low = numberParser.numberFromString(stringLow) as? Float,
        let close = numberParser.numberFromString(stringClose) as? Float,
        let volume = numberParser.numberFromString(stringVolume) as? Int {
          self.init(date: date, open: open, high: high, low: low, close: close, volume: volume)
      } else {
        return nil
      }
  }
}

extension FinanceDataPoint {
  static func loadDataFromCSVNamed(name: String) -> [FinanceDataPoint]? {
    let csvURL = NSBundle.mainBundle().URLForResource(name, withExtension: "csv")
    var error: NSErrorPointer = nil
    if let csvURL = csvURL,
      let csv = CSV(contentsOfURL: csvURL, error: error) {
        return csv.rows.map { FinanceDataPoint(stringDict: $0) }
                       .filter { $0 != nil}
                       .map { $0! }
    }
    return nil
  }
  
  static func loadDataFromDefaultCSV() -> [FinanceDataPoint]? {
    return self.loadDataFromCSVNamed("AAPL")
  }
}

extension FinanceDataPoint {
  func volumeDataPoint() -> SChartData {
    let dp = SChartDataPoint()
    dp.xValue = date
    dp.yValue = volume
    return dp
  }
  
  func priceDataPoint() -> SChartData {
    let dp = SChartMultiYDataPoint()
    dp.xValue = date
    dp.yValues = NSMutableDictionary(dictionary: [SChartOHLCKeyOpen  : open,
                                                  SChartOHLCKeyHigh  : high,
                                                  SChartOHLCKeyLow   : low,
                                                  SChartOHLCKeyClose : close])
    return dp
  }
}

