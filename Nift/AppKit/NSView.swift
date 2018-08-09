import class AppKit.NSEvent
import class AppKit.NSText
import class AppKit.NSView
import class CoreGraphics.CGColor
import struct Foundation.UUID

public func NSView(
    backgroundColor: CGColor? = nil,
    key: String? = nil,
    mouseDown: Handler<NSEventClosure> = Handler({ (_: NSEvent) in }),
    rightMouseDown: Handler<NSEventClosure> = Handler({ (_: NSEvent) in }),
    wantsLayer: Bool = false,
    _ children: [Node] = []
) -> Node {
    return Native.create(
        Component: Component.self,
        key: key,
        properties: Component.Properties(
            backgroundColor: backgroundColor,
            mouseDown: mouseDown,
            rightMouseDown: rightMouseDown,
            wantsLayer: wantsLayer
        ),
        children
    )
}

private class Component: Native.Renderable {
    struct Properties: Equatable {
        let backgroundColor: CGColor?
        let mouseDown: Handler<NSEventClosure>
        let rightMouseDown: Handler<NSEventClosure>
        let wantsLayer: Bool
    }

    class View: AppKit.NSView {
        weak var parent: Component?

        override func mouseDown(with event: NSEvent) {
            parent?.properties?.mouseDown.call(event)
        }

        override func rightMouseDown(with event: NSEvent) {
            parent?.properties?.rightMouseDown.call(event)
        }
    }

    var view: View
    var properties: Properties?

    required init(properties: Any, children: [Any]) {
        self.properties = properties as? Properties

        view = View()
        view.parent = self

        apply(properties as! Properties)

        for child in children {
            if let subview = child as? AppKit.NSView {
                view.addSubview(subview)
            }
        }
    }

    func apply(_ properties: Properties) {
        view.wantsLayer = properties.wantsLayer
        view.layer?.backgroundColor = properties.backgroundColor
        self.properties = properties
    }

    func update(properties: Any) {
        apply(properties as! Properties)
    }

    func update(operations: [Operation]) {
        for operation in operations {
            switch operation {
            case let .add(mount):
                if let subview = mount as? AppKit.NSView {
                    view.addSubview(subview)
                }
            case .reorder:
                break
            case let .replace(old, new):
                if let old = old as? AppKit.NSView {
                    if let new = new as? AppKit.NSView {
                        old.removeFromSuperview()
                        view.addSubview(new)
                    }
                }
            case let .remove(mount):
                remove(mount)
            }
        }
    }

    func update(properties: Any, operations: [Operation]) {
        update(properties: properties)
        update(operations: operations)
    }

    func remove(_ mount: Any) {
        if let view = mount as? AppKit.NSView {
            view.removeFromSuperview()
        }
    }

    func render() -> Any {
        return view
    }
}
