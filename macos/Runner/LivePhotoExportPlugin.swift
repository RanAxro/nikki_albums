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
    case "normalizeVideo":
        guard let args = call.arguments as? [String: Any],
              let inputPath = args["inputPath"] as? String,
              let outputPath = args["outputPath"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing arguments", details: nil))
            return
        }
        normalizeVideo(inputPath: inputPath, outputPath: outputPath, result: result)
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
    case "importToPhotoLibrary":
        guard let args = call.arguments as? [String: Any],
              let filePath = args["filePath"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing arguments", details: nil))
            return
        }
        importFileToPhotoLibrary(filePath: filePath, result: result)
    case "importBatchToPhotoLibrary":
        guard let args = call.arguments as? [String: Any],
              let filePaths = args["filePaths"] as? [String] else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing arguments", details: nil))
            return
        }
        importBatchToPhotoLibrary(filePaths: filePaths, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func remuxAndInjectVideoMetadata(inputPath: String, outputPath: String, assetIdentifier: String, result: @escaping FlutterResult) {
    let inputURL = URL(fileURLWithPath: inputPath)
    let outputURL = URL(fileURLWithPath: outputPath)

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
      
      if let service = NSSharingService(named: .addToIPhoto) {
          let items: [URL] = [coverURL, videoURL]
          if service.canPerform(withItems: items) {
              service.perform(withItems: items)
              result(true)
              return
          }
      }
      // Fallback: reveal in Finder
      NSWorkspace.shared.activateFileViewerSelecting([coverURL, videoURL])
      result(true)
  }

  private func importFileToPhotoLibrary(filePath: String, result: @escaping FlutterResult) {
      let fileURL = URL(fileURLWithPath: filePath)
      
      if let service = NSSharingService(named: .addToIPhoto) {
          let items: [URL] = [fileURL]
          if service.canPerform(withItems: items) {
              service.perform(withItems: items)
              result(true)
              return
          }
      }
      // Fallback: open in Photos.app
      NSWorkspace.shared.open([fileURL], withApplicationAt: URL(fileURLWithPath: "/System/Applications/Photos.app"), configuration: NSWorkspace.OpenConfiguration()) { _, error in
          DispatchQueue.main.async {
              if let error = error {
                  result(FlutterError(code: "IMPORT_FAILED", message: error.localizedDescription, details: nil))
              } else {
                  result(true)
              }
          }
      }
  }

  private func importBatchToPhotoLibrary(filePaths: [String], result: @escaping FlutterResult) {
      let urls = filePaths.map { URL(fileURLWithPath: $0) }
      
      if let service = NSSharingService(named: .addToIPhoto) {
          if service.canPerform(withItems: urls) {
              service.perform(withItems: urls)
              result(true)
              return
          }
      }
      // Fallback: reveal in Finder
      NSWorkspace.shared.activateFileViewerSelecting(urls)
      result(true)
  }

  private func normalizeVideo(inputPath: String, outputPath: String, result: @escaping FlutterResult) {
      let inputURL = URL(fileURLWithPath: inputPath)
      let outputURL = URL(fileURLWithPath: outputPath)

      if FileManager.default.fileExists(atPath: outputPath) {
          try? FileManager.default.removeItem(at: outputURL)
      }

      let asset = AVAsset(url: inputURL)
      
      var videoComposition: AVMutableVideoComposition? = nil

      if let track = asset.tracks(withMediaType: .video).first {
          let width = abs(track.naturalSize.width)
          let height = abs(track.naturalSize.height)
          if width > 3840 || height > 2160 {
              let widthRatio = 3840.0 / width
              let heightRatio = 2160.0 / height
              let scale = min(widthRatio, heightRatio)
              
              let newWidth = CGFloat(round((width * scale) / 2.0) * 2.0)
              let newHeight = CGFloat(round((height * scale) / 2.0) * 2.0)
              
              let composition = AVMutableVideoComposition()
              composition.renderSize = CGSize(width: newWidth, height: newHeight)
              
              // Safe frameDuration fallback
              var frameDur = track.minFrameDuration
              if !frameDur.isValid || frameDur.seconds <= 0 || frameDur.timescale == 0 {
                  frameDur = CMTimeMake(value: 1, timescale: 30)
              }
              composition.frameDuration = frameDur
              
              let instruction = AVMutableVideoCompositionInstruction()
              // Use track's timeRange to ensure validity
              instruction.timeRange = track.timeRange
              
              let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
              var transform = track.preferredTransform
              transform = transform.scaledBy(x: scale, y: scale)
              layerInstruction.setTransform(transform, at: .zero)
              
              instruction.layerInstructions = [layerInstruction]
              composition.instructions = [instruction]
              
              videoComposition = composition
          }
      }

      guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {
          result(FlutterError(code: "EXPORT_SESSION_FAILED", message: "Cannot create AVAssetExportSession", details: nil))
          return
      }

      if let vc = videoComposition {
          exportSession.videoComposition = vc
      }

      exportSession.outputURL = outputURL
      exportSession.outputFileType = .mp4
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

