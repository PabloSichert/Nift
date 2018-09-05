public protocol Node {
    var children: [Node] { get }
    var ComponentType: Any.Type { get }
    var equal: (Any, Any) -> Bool { get }
    var key: String? { get }
    var properties: Any { get }
    var type: Behavior { get }
}