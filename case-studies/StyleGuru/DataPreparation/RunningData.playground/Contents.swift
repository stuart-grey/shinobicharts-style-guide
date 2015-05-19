import Foundation


/*
let p = Parser(fileName: "running.tcx")
var trackpoints = [Trackpoint]()
p.beginParsing { trackpoints.append($0) }

trackpoints = calculatePace(trackpoints)

trackpoints = paceMovingAverage(trackpoints, windowSize: 20)
*/

let trackpoints = loadTrackpoints(30, 5)



trackpoints.map { $0.elevation }

trackpoints.map { $0.pace }

trackpoints.map { $0.distance }

let outputArray = trackpoints.map { $0.toDict() }

// Write it out
let outputPath = NSBundle.mainBundle().pathForResource("output", ofType: "plist")



let nsarray = Array(outputArray[5..<count(outputArray)]) as NSArray

let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! NSString
let plistOut = documentsPath.stringByAppendingPathComponent("output.plist")

nsarray.writeToFile(plistOut, atomically: false)

println(documentsPath)
