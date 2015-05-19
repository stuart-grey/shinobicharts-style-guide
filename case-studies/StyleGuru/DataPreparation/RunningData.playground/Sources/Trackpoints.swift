import Foundation

public struct Trackpoint {
  public var time: NSDate = NSDate(timeIntervalSince1970: 0)
  public var elevation: Float = 0.0
  public var distance: Float = 0.0
  public var pace: Float = 0.0
  
  public init() { }
  public init(trackpoint: Trackpoint) {
    time = trackpoint.time
    elevation = trackpoint.elevation
    distance = trackpoint.distance
    pace = trackpoint.pace
  }
}

extension Trackpoint {
  public func toDict() -> [String : AnyObject] {
    return [ "time"      : time,
             "elevation" : elevation,
             "distance"  : distance,
             "pace"      : pace]
  }
}


public func calculatePace(trackpoints: [Trackpoint]) -> [Trackpoint] {
  return trackpoints.reduce((prevTime: NSDate(), prevDist: 0.0 as Float, tps:[Trackpoint]())) {
      cum, tp in
      var newTP = Trackpoint(trackpoint: tp)
      let elapsedTime = tp.time.timeIntervalSinceDate(cum.prevTime)
      if elapsedTime > 0 {
        let distTravelled = tp.distance - Float(cum.prevDist)
        let pace = Float(elapsedTime) / distTravelled * 1000.0 / 60.0
        
        newTP.pace = pace
      }
      if newTP.pace < 20 {
        return (tp.time, tp.distance, cum.tps + [newTP])
      } else {
        return (tp.time, tp.distance, cum.tps)
      }
    }.tps
}


public func paceMovingAverage(trackpoints: [Trackpoint], windowSize : Int = 20) -> [Trackpoint] {
  return trackpoints.reduce((runningAverage: 0 as Float, currentWindow: [Float](), result: [Trackpoint]())) {
    cum, tp in
    var newWindow = cum.currentWindow + [tp.pace]
    var newrunningAverage = cum.runningAverage + tp.pace
    var newResult = cum.result
    if count(newWindow) >= windowSize {
      
      var newTP = Trackpoint(trackpoint: tp)
      newTP.pace = newrunningAverage / Float(windowSize)
      newResult += [newTP]
      
      newrunningAverage -= newWindow[0]
      newWindow = Array(newWindow[1..<count(newWindow)])
    }
    
    return (newrunningAverage, newWindow, newResult)
  }.result
}

public func filterTrackpoints(trackpoints: [Trackpoint]) -> [Trackpoint] {
  return trackpoints.filter {
    tp in
    return tp.distance.isNormal && tp.elevation.isNormal && tp.pace.isNormal
  }
}

public func loadTrackpoints(subsample: Int, windowSize: Int) -> [Trackpoint] {
  let p = Parser(fileName: "running.tcx")
  var trackpoints = [Trackpoint]()
  p.beginParsing { trackpoints.append($0) }
  
  trackpoints = trackpoints.takeEvery(subsample)
  trackpoints = calculatePace(trackpoints)
  trackpoints = filterTrackpoints(trackpoints)
  trackpoints = paceMovingAverage(trackpoints, windowSize: windowSize)
  
  
  return trackpoints
}



