import let AppKit.NSApp
import class AppKit.NSApplication
import protocol AppKit.NSApplicationDelegate
import class AppKit.NSScreen
import struct CoreGraphics.CGFloat
import struct Foundation.Notification
import struct Foundation.NSRect
import struct Nift.Composite
import struct Nift.Node
import func Nift.NSApplication
import func Nift.NSWindow
import class ObjectiveC.NSObject

public func App() -> Node {
    return Composite.create(
        Component: Component.self,
        key: nil,
        properties: Component.Properties()
    )
}

private class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_: Notification) {
        NSApp.activate(ignoringOtherApps: true)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_: AppKit.NSApplication) -> Bool {
        return true
    }
}

private class Component: Composite.Component<Component.Properties, Component.State>, Composite.Renderable {
    public struct Properties: Equatable {}

    struct State: Equatable {}

    let width: CGFloat
    let height: CGFloat
    let x: CGFloat
    let y: CGFloat

    required init(properties _: Any, children: [Node]) {
        let frame = NSScreen.main!.visibleFrame

        let factor = CGFloat(0.5)

        let width = CGFloat(factor * frame.width)
        let height = (width / 3) * 2

        let x = CGFloat((frame.width - width) / 2)
        let y = CGFloat((frame.height - height) / 2)

        self.width = width
        self.height = height
        self.x = x
        self.y = y

        super.init(properties: Properties(), state: State(), children)
    }

    func render() -> [Node] {
        return [
            NSApplication(
                delegate: AppDelegate(),
                key: "application", [
                    NSWindow(
                        contentRect: NSRect(
                            x: self.x,
                            y: self.y,
                            width: self.width,
                            height: self.height
                        ),
                        key: "window",
                        styleMask: [.titled, .closable, .resizable],
                        titlebarAppearsTransparent: true, [
                            Incrementer(key: "incrementer", x: width / 2, y: height / 2),
                    ]),
            ]),
        ]
    }
}