import FlatBuffers

public struct NotExpr<T: Expr>: Expr where T.ResultType == Bool {
  public typealias ResultType = Bool
  public let unary: T
  public func evaluate(object: Evaluable) -> (result: ResultType, unknown: Bool) {
    let val = unary.evaluate(object: object)
    return (!val.result, val.unknown)
  }
  public func canUsePartialIndex(_ availableIndexes: Set<String>) -> IndexUsefulness {
    unary.canUsePartialIndex(availableIndexes) == .full ? .full : .none
  }
}

public prefix func ! <T>(unary: T) -> NotExpr<T> where T.ResultType == Bool {
  return NotExpr(unary: unary)
}
