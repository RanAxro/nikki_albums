import Cocoa
import FlutterMacOS
import AVFoundation

public class LivePhotoExportPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.ranaxro.nikki.nikkiAlbums/live_photo", binaryMessenger: registrar.messenger)
    let instance = LivePhotoExportPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "remuxMp4ToMov":
        guard let args = call.arguments as? [String: Any],
              let inputPath = args["inputPath"] as? String,
              let outputPath = args["outputPath"] as? String,
              let assetIdentifier = args["assetIdentifier"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing arguments", details: nil))
            return
        }
        remuxAndInjectVideoMetadata(inputPath: inputPath, outputPath: outputPath, assetIdentifier: assetIdentifier, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func remuxAndInjectVideoMetadata(inputPath: String, outputPath: String, assetIdentifier: String, result: @escaping FlutterResult) {
    let inputURL = URL(fileURLWithPath: inputPath)
    let outputURL = URL(fileURLWithPath: outputPath)

    // Remove output file if it already exists
    if FileManager.default.fileExists(atPath: outputPath) {
        try? FileManager.default.removeItem(at: outputURL)
    }

    let asset = AVAsset(url: inputURL)
    guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetPassthrough) else {
        result(FlutterError(code: "EXPORT_SESSION_FAILED", message: "Cannot create AVAssetExportSession", details: nil))
        return
    }

    let identifierItem = AVMutableMetadataItem()
    identifierItem.keySpace = .quicktimeMetadata
    identifierItem.key = "com.apple.quicktime.content.identifier" as NSString
    identifierItem.value = assetIdentifier as NSString

    exportSession.metadata = [identifierItem]
    exportSession.outputURL = outputURL
    exportSession.outputFileType = .mov
    exportSession.shouldOptimizeForNetworkUse = true

    exportSession.exportAsynchronously {
        DispatchQueue.main.async {
            switch exportSession.status {
            case .completed:
                result(true)
            case .failed:
                let errorMsg = exportSession.error?.localizedDescription ?? "Unknown error"
                result(FlutterError(code: "EXPORT_FAILED", message: errorMsg, details: nil))
            default:
                result(FlutterError(code: "EXPORT_UNKNOWN", message: "Unknown export status", details: nil))
            }
        }
    }
  }
}
