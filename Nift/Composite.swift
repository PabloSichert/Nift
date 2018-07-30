import struct Foundation.UUID

open class Composite: CompositeNode {
    public typealias Single = CompositeComponentSingle
    public typealias Multiple = CompositeComponentMultiple

    public struct NoProperties {
        public init() {}
    }

    public var type: UUID
    public var create: Composite.Create
    public var properties: Any
    public var children: [Node]
    public var key: String?

    public init(type: UUID, create: @escaping Composite.Create, properties: Any = NoProperties(), key: String? = nil, _ children: [Node] = []) {
        self.type = type
        self.create = create
        self.properties = properties
        self.children = children
        self.key = create is CompositeComponentSingle && key == nil ? "single" : key
    }
}

public protocol CompositeNode: Node {
    typealias Create = (Any, [Node]) -> CompositeComponent
    var create: Create { get }
}

public protocol CompositeComponent {
    var rerender: () -> Void { get set }

    init(properties: Any, children: [Node])

    func update(properties: Any)
}

public protocol CompositeComponentSingle: CompositeComponent {
    func render() -> Node
}

public protocol CompositeComponentMultiple: CompositeComponent {
    func render() -> [Node]
}
