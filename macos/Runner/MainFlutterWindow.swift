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

    // Let AppKit lay out the standard window controls in a compact 40-point
    // title bar. This keeps macOS-specific rendering and interaction effects
    // while aligning the controls with the Flutter title-bar content.
    let titlebarToolbar = NSToolbar(identifier: "NikkiAlbumsTitlebar")
    titlebarToolbar.allowsUserCustomization = false
    titlebarToolbar.autosavesConfiguration = false
    titlebarToolbar.displayMode = .iconOnly
    toolbarStyle = .unifiedCompact
    toolbar = titlebarToolbar
  }

  override public func order(_ place: NSWindow.OrderingMode, relativeTo otherWin: Int) {
    super.order(place, relativeTo: otherWin)
    hiddenWindowAtLaunch()
  }
}
