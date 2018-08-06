import class AppKit.NSApplication
import protocol AppKit.NSApplicationDelegate
import class AppKit.NSWindow

public class NSApplication: Native {
    static let create = Handler<Native.Init>(Component.init)

    struct Properties: Equatable {
        static func == (lhs: Properties, rhs: Properties) -> Bool {
            return lhs.delegate === rhs.delegate
        }

        let delegate: AppKit.NSApplicationDelegate
    }

    static func equal(a: Any, b: Any) -> Bool { // swiftlint:disable:this identifier_name
        return a as! Properties == b as! Properties
    }

    class Component: Native.Component {
        var application: AppKit.NSApplication

        required init(properties: Any, children: [Any]) {
            application = AppKit.NSApplication.shared

            apply(properties as! Properties)

            for child in children {
                if let window = child as? AppKit.NSWindow {
                    window.orderFront(self)
                }
            }
        }

        func apply(_ properties: Properties) {
            application.delegate = properties.delegate
        }

        func update(properties: Any) {
            apply(properties as! Properties)
        }

        func update(operations: [Operation]) {
            for operation in operations {
                switch operation {
                case let .add(mount):
                    if let window = mount as? AppKit.NSWindow {
                        window.orderFront(self)
                    }
                case .reorder:
                    break
                case .replace:
                    break
                case .remove:
                    break
                }
            }
        }

        func update(properties: Any, operations: [Operation]) {
            update(properties: properties)
            update(operations: operations)
        }

        func remove(_: Any) {}

        func render() -> Any {
            return application
        }
    }

    public init(
        delegate: AppKit.NSApplicationDelegate,
        key: String? = nil,
        _ children: [Node] = []
    ) {
        super.init(
            create: NSApplication.create,
            equal: NSApplication.equal,
            key: key,
            properties: Properties(delegate: delegate),
            children
        )
    }
}
