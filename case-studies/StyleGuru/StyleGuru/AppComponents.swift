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

enum AppComponentCategory: String {
  case Charts = "shinobicharts"

  static let allValues = [ Charts ]
}

enum AppComponentType {
  case Storyboard(String)
  case Code((UIStoryboard?) -> UIViewController?)
}

struct AppComponent {
  let name: String
  let category: AppComponentCategory
  let type: AppComponentType
  
  init(name: String, category: AppComponentCategory, type: AppComponentType) {
    self.name = name
    self.category = category
    self.type = type
  }
  
  init(name: String, category: AppComponentCategory, vcIdentifier: String) {
    let type = AppComponentType.Storyboard(vcIdentifier)
    self.init(name: name, category: category, type: type)
  }
  
  init(name: String, category: AppComponentCategory, vcInstantiation: (UIStoryboard?) -> UIViewController?) {
    let type = AppComponentType.Code(vcInstantiation)
    self.init(name: name, category: category, type: type)
  }
}

extension AppComponent {
  static func appStructure() -> [AppComponent] {
    return [
      AppComponent(name: "twitter stats", category: .Charts, vcIdentifier: "TwitterStatsVC"),
      AppComponent(name: "running", category: .Charts, vcIdentifier: "RunningVC"),
      AppComponent(name: "finance", category: .Charts, vcIdentifier: "FinanceVC"),
      AppComponent(name: "sparks", category: .Charts, vcIdentifier: "SparkChartsVC")
    ]
  }
}