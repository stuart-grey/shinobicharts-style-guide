import Foundation



let p = Parser(fileName: "running.tcx")
var trackpoints = [Trackpoint]()
p.beginParsing { trackpoints.append($0) }
trackpoints = calculatePace(trackpoints)


let outputArray = trackpoints[1..<5000].map { $0.toDict() }

// Write it out
let outputPath = NSBundle.mainBundle().pathForResource("output", ofType: "plist")

let nsarray = Array(outputArray[5..<4000]) as NSArray

let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! NSString
let plistOut = documentsPath.stringByAppendingPathComponent("output.plist")

nsarray.writeToFile(plistOut, atomically: false)

println(documentsPath)

