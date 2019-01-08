import let AppKit.NSApp
import class AppKit.NSApplication
import protocol AppKit.NSApplicationDelegate
import class AppKit.NSScreen
import class AppKit.NSWindow
import AppKitX
import struct CoreGraphics.CGFloat
import struct Foundation.Notification
import struct Foundation.NSRect
import class ObjectiveC.NSObject
import class Sx.Composite
import protocol Sx.Node

public class App: Composite {
    struct Properties: Equatable {}

    struct State: Equatable {}

    init(key: String? = nil) {
        super.init(
            Component.self,
            key: key,
            properties: Properties(),
            state: State()
        )
    }

    class AppDelegate: NSObject, NSApplicationDelegate {
        func applicationDidFinishLaunching(_: Notification) {
            NSApp.activate(ignoringOtherApps: true)
        }

        func applicationShouldTerminateAfterLastWindowClosed(_: AppKit.NSApplication) -> Bool {
            return true
        }
    }

    class Component: Composite<Properties, State>, Renderable {
        let width: CGFloat
        let height: CGFloat
        let x: CGFloat
        let y: CGFloat

        override init(properties: Properties, state: State, children: [Node]) {
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

            super.init(properties: properties, state: state, children: children)
        }

        func render() -> [Node?] {
            return [
                NSApplication.Node(
                    key: "application",
                    \NSApplication.delegate => AppDelegate(),
                    children: [
                        NSWindow.Node(
                            key: "window",
                            \NSWindow.contentRect => NSRect(
                                x: self.x,
                                y: self.y,
                                width: self.width,
                                height: self.height
                            ),
                            \NSWindow.styleMask => [.titled, .closable, .resizable],
                            \NSWindow.titlebarAppearsTransparent => true,
                            children: [
                                Incrementer(key: "incrementer", x: width / 2, y: height / 2),
                            ]
                        ),
                    ]
                ),
            ]
        }
    }
}
