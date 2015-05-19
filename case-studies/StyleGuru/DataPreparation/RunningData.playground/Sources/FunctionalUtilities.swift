import Foundation

private func dropN<T>(xs: [T], n: Int) -> [T] {
  switch n {
  case 0:
    return xs
  default:
    if let (head, tail) = xs.decompose {
      return dropN(tail, n-1)
    } else {
      return [T]()
    }
  }
}

private func takeEveryN<T>(xs: [T], n: Int) -> [T] {
  switch dropN(xs, n-1).decompose {
  case .Some(let y, let ys):
    return [y] + takeEveryN(ys, n)
  case .None:
    return [T]()
  }
}

extension Array {
  var decompose : (head: T, tail: [T])? {
    return (count > 0) ? (self[0], Array(self[1..<count])) : nil
  }
  
  func drop(n: Int) -> [T] {
    return dropN(self, n)
  }
  
  func takeEvery(n: Int) -> [T] {
    return takeEveryN(self, n)
  }
}

