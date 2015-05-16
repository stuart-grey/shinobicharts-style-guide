//
//  RangeExtensions.swift
//  StyleGuru
//
//  Created by Sam Davies on 15/05/2015.
//  Copyright (c) 2015 shinobicontrols. All rights reserved.
//

import Foundation

public extension SChartRange {
  func contains(value: NSNumber) -> Bool {
    return Double(value) >= Double(minimum) && Double(value) <= Double(maximum)
  }
}