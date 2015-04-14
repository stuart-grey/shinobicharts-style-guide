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
    return (tp.time, tp.distance, cum.tps + [newTP])
    }.tps
}