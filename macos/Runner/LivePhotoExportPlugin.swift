import Cocoa
import FlutterMacOS
import AVFoundation
import Photos

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
    case "injectImageMetadata":
        guard let args = call.arguments as? [String: Any],
              let inputPath = args["inputPath"] as? String,
              let outputPath = args["outputPath"] as? String,
              let assetIdentifier = args["assetIdentifier"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing arguments", details: nil))
            return
        }
        injectLivePhotoMetadataToImage(inputPath: inputPath, outputPath: outputPath, assetIdentifier: assetIdentifier, result: result)
    case "importLivePhoto":
        guard let args = call.arguments as? [String: Any],
              let coverPath = args["coverPath"] as? String,
              let videoPath = args["videoPath"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing arguments", details: nil))
            return
        }
        importLivePhotoToLibrary(coverPath: coverPath, videoPath: videoPath, result: result)
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
    identifierItem.keySpace = AVMetadataKeySpace.quickTimeMetadata
    identifierItem.key = AVMetadataKey.quickTimeMetadataKeyContentIdentifier as NSString
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

  private func injectLivePhotoMetadataToImage(inputPath: String, outputPath: String, assetIdentifier: String, result: @escaping FlutterResult) {
    let inputURL = URL(fileURLWithPath: inputPath)
    let outputURL = URL(fileURLWithPath: outputPath)
    
    // Remove output file if it already exists
    if FileManager.default.fileExists(atPath: outputPath) {
        try? FileManager.default.removeItem(at: outputURL)
    }

    guard let imageSource = CGImageSourceCreateWithURL(inputURL as CFURL, nil),
          let imageType = CGImageSourceGetType(imageSource) else {
        result(FlutterError(code: "IMAGE_READ_FAILED", message: "Cannot read source image", details: nil))
        return
    }

    guard let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any] else {
        result(FlutterError(code: "IMAGE_PROPERTIES_FAILED", message: "Cannot read image properties", details: nil))
        return
    }

    var metadata = imageProperties
    var appleMakerDict = metadata[kCGImagePropertyMakerAppleDictionary] as? [String: Any] ?? [String: Any]()
    appleMakerDict["17"] = assetIdentifier
    metadata[kCGImagePropertyMakerAppleDictionary] = appleMakerDict

    guard let destination = CGImageDestinationCreateWithURL(outputURL as CFURL, imageType, 1, nil) else {
        result(FlutterError(code: "IMAGE_WRITE_FAILED", message: "Cannot create image destination", details: nil))
        return
    }

    CGImageDestinationAddImageFromSource(destination, imageSource, 0, metadata as CFDictionary)
    if CGImageDestinationFinalize(destination) {
        result(true)
    } else {
        result(FlutterError(code: "IMAGE_FINALIZE_FAILED", message: "Cannot finalize image destination", details: nil))
    }
  }

  private func importLivePhotoToLibrary(coverPath: String, videoPath: String, result: @escaping FlutterResult) {
      let coverURL = URL(fileURLWithPath: coverPath)
      let videoURL = URL(fileURLWithPath: videoPath)

      let performImport = {
          PHPhotoLibrary.shared().performChanges({
              let request = PHAssetCreationRequest.forAsset()
              request.addResource(with: .photo, fileURL: coverURL, options: nil)
              
              let videoOptions = PHAssetResourceCreationOptions()
              request.addResource(with: .pairedVideo, fileURL: videoURL, options: videoOptions)
          }) { success, error in
              DispatchQueue.main.async {
                  if success {
                      result(true)
                  } else {
                      let errorMsg = error?.localizedDescription ?? "Unknown error"
                      result(FlutterError(code: "IMPORT_FAILED", message: errorMsg, details: nil))
                  }
              }
          }
      }

      if #available(macOS 11.0, *) {
          PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
              if status == .authorized || status == .limited {
                  performImport()
              } else {
                  DispatchQueue.main.async {
                      result(FlutterError(code: "UNAUTHORIZED", message: "Photo library access not authorized. Please grant access in System Settings > Privacy & Security > Photos.", details: nil))
                  }
              }
          }
      } else {
          PHPhotoLibrary.requestAuthorization { status in
              if status == .authorized {
                  performImport()
              } else {
                  DispatchQueue.main.async {
                      result(FlutterError(code: "UNAUTHORIZED", message: "Photo library access not authorized", details: nil))
                  }
              }
          }
      }
  }
}
