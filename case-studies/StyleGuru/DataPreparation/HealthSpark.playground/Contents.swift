import Foundation


let days = 0...30
let startDate = NSDateComponents()
startDate.day = 15
startDate.month = 3
startDate.year = 2015

let start = NSCalendar.currentCalendar().dateFromComponents(startDate)

let dates = days.map {
  NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitDay, value: $0, toDate: start!, options: .allZeros)!
}


// Will always get the same sequence
srand48(123456)

func randomNormalSample(mean: Double, variance: Double) -> Double {
  var w = 1.0
  var x1 = 0.0
  var x2 = 0.0
  do {
    x1 = 2.0 * drand48() - 1.0
    x2 = 2.0 * drand48() - 1.0
    w = x1 * x1 + x2 * x2
  } while w >= 1.0
  
  w = sqrt( (-2.0 * log(w) ) / w)
  return x1 * w * sqrt(variance) + mean
}

randomNormalSample(4, 1)

func createSampleForDate(date: NSDate) -> [String : AnyObject] {
  return [
    "date"            : date,
    "steps"           : Int(randomNormalSample(10000, 400)),
    "flights"         : Int(randomNormalSample(30, 4)),
    "walkingDistance" : randomNormalSample(5, 2),
    "cyclingDistance" : randomNormalSample(30, 5)
  ]
}

let output = dates.map(createSampleForDate)

/*
// Write it out

let nsarray = output as NSArray

let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! NSString
let plistOut = documentsPath.stringByAppendingPathComponent("healthspark.plist")

nsarray.writeToFile(plistOut, atomically: false)

println(documentsPath)
*/
