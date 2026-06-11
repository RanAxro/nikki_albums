import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {

  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)
    LivePhotoExportPlugin.register(with: flutterViewController.registrar(forPlugin: "LivePhotoExportPlugin"))

    super.awakeFromNib()

    // Offset traffic light buttons to be vertically centered in the title bar
    repositionTrafficLights()
  }

  override func didChangeValue(forKey key: String) {
    super.didChangeValue(forKey: key)
    if key == "effectiveAppearance" {
      repositionTrafficLights()
    }
  }

  override func layoutIfNeeded() {
    super.layoutIfNeeded()
    repositionTrafficLights()
  }

  private func repositionTrafficLights() {
    guard let closeButton = standardWindowButton(.closeButton),
          let miniaturizeButton = standardWindowButton(.miniaturizeButton),
          let zoomButton = standardWindowButton(.zoomButton),
          let titleBarContainer = closeButton.superview?.superview else { return }

    let titleBarHeight: CGFloat = 46
    let buttonHeight = closeButton.frame.height

    // Resize the titlebar container to match our custom titlebar height
    var containerFrame = titleBarContainer.frame
    containerFrame.size.height = titleBarHeight
    containerFrame.origin.y = frame.height - titleBarHeight
    titleBarContainer.frame = containerFrame

    let yOffset = (titleBarHeight - buttonHeight) / 2
    let xOffset = yOffset

    let buttonWidth = closeButton.frame.width

    if buttonWidth >= 25 {
      // Large buttons (macOS 26+ Tahoe, 28px): use explicit HIG-standard 8px gaps
      let buttonGap: CGFloat = 8
      let step = buttonWidth + buttonGap

      closeButton.setFrameOrigin(NSPoint(x: xOffset, y: yOffset))
      miniaturizeButton.setFrameOrigin(NSPoint(x: xOffset + step, y: yOffset))
      zoomButton.setFrameOrigin(NSPoint(x: xOffset + step * 2, y: yOffset))
    } else {
      // Smaller buttons (macOS 14–15, ~23px): vertically center with default system spacing
      let spacing = miniaturizeButton.frame.origin.x - closeButton.frame.origin.x

      closeButton.setFrameOrigin(NSPoint(x: xOffset, y: yOffset))
      miniaturizeButton.setFrameOrigin(NSPoint(x: xOffset + spacing, y: yOffset))
      zoomButton.setFrameOrigin(NSPoint(x: xOffset + spacing * 2, y: yOffset))
    }
  }

  override public func order(_ place: NSWindow.OrderingMode, relativeTo otherWin: Int) {
    super.order(place, relativeTo: otherWin)
    hiddenWindowAtLaunch()
  }
}
