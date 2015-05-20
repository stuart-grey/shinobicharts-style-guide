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


extension AxisStyler {
  static func runningXAxis() -> SChartAxis {
    let axis = SChartNumberAxis()
    axis.enableTouch()
    return axis
  }
  
  static func runningElevationYAxis() -> SChartAxis {
    let axis = SChartNumberAxis()
    axis.enableTouch()
    axis.axisPosition = SChartAxisPositionReverse
    axis.rangePaddingHigh = 1500
    
    // Want to see tick marks. Set their colour, thickness and length
    axis.style.majorTickStyle.showTicks = true
    axis.style.majorTickStyle.lineWidth = 0.5
    axis.style.majorTickStyle.lineLength = 20
    axis.style.majorTickStyle.lineColor = UIColor.blackColor()

    return axis
  }
  
  static func runningPaceYAxis() -> SChartAxis {
    let axis = SChartNumberAxis()
    axis.rangePaddingLow = 5
    return axis
  }
}

private extension SChartAxis {
  func enableTouch() {
    enableGesturePanning = true
    enableGestureZooming = true
    enableMomentumPanning = true
    enableMomentumZooming = true
  }
}


extension AxisStyler {
  static func negateTickMarkLabelsForTickMark(tickMark: SChartTickMark, axis: SChartAxis) {
    let negatedValue = -tickMark.value
    if let tickLabel = tickMark.tickLabel,
      let formatter = axis.labelFormatter {
        tickLabel.text = formatter.stringForObjectValue(negatedValue, onAxis: axis)
    }
  }
}
