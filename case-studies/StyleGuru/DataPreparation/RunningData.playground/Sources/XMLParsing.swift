import Foundation

public class Parser : NSObject {
  private let parser: NSXMLParser
  
  private let timeParser = NSDateFormatter()
  private let numberParser = NSNumberFormatter()
  
  // Eurgh - state
  private var trackpointHandler: (Trackpoint) -> () = { tp in return }
  private var currentTrackpoint: Trackpoint?
  private var currentChars: String?
  
  public init(fileName: String) {
    let url = NSBundle.mainBundle().URLForResource(fileName, withExtension: nil)
    parser = NSXMLParser(contentsOfURL: url)!
    super.init()
    parser.delegate = self
    timeParser.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
  }
  
  public func beginParsing(trackpointHandler: (Trackpoint) -> ()) {
    self.trackpointHandler = trackpointHandler
    parser.parse()
  }
}

extension Parser : NSXMLParserDelegate {
  public func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
    switch elementName {
    case "Trackpoint":
      currentTrackpoint = Trackpoint()
    default:
      break
    }
    currentChars = ""
  }
  
  public func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    switch elementName {
    case "Trackpoint":
      trackpointHandler(currentTrackpoint!)
      currentTrackpoint = .None
    case "Time":
      if let time = timeParser.dateFromString(currentChars!) {
        currentTrackpoint?.time = time
      }
    case "AltitudeMeters":
      if let altitude = numberParser.numberFromString(currentChars!) {
        currentTrackpoint?.elevation = altitude as! Float
      }
    case "DistanceMeters":
      if let distance = numberParser.numberFromString(currentChars!) {
        currentTrackpoint?.distance = distance as! Float
      }
    default:
      break
    }
    
    currentChars = .None
  }
  
  public func parser(parser: NSXMLParser, foundCharacters string: String?) {
    if let string = string,
      let currentChars = currentChars {
        self.currentChars = currentChars + string
    }
  }
}

