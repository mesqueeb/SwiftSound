import Foundation

/// Helper Function to Read Floats from .raw File or Convert via SoX
public func readRawAudio(filePath: URL, saveAsJson: Bool) throws -> [Float] {
  let fileExtension = filePath.pathExtension.lowercased()
  var rawFilePath = filePath

  // 1. Convert to .raw using SoX only if necessary
  if fileExtension != "raw" {
    // Check if SoX is installed
    let whichProcess = Process()
    whichProcess.executableURL = URL(fileURLWithPath: "/usr/bin/which")
    whichProcess.arguments = ["sox"]

    let pipe = Pipe()
    whichProcess.standardOutput = pipe
    try whichProcess.run()
    whichProcess.waitUntilExit()

    guard
      let soxPath = String(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)?
        .trimmingCharacters(in: .whitespacesAndNewlines), !soxPath.isEmpty
    else {
      print("⚠️ Please install sox first with \"brew install sox\".")
      return []
    }

    // Convert audio to .raw using SoX, naming based on original extension
    let outputURL = filePath.deletingLastPathComponent()
      .appendingPathComponent(
        filePath.deletingPathExtension().lastPathComponent + "_" + fileExtension + ".raw"
      )
    let convertProcess = Process()
    convertProcess.executableURL = URL(fileURLWithPath: soxPath)
    convertProcess.arguments = [
      filePath.path, "-t", "raw", "-e", "float", "-b", "32", "-r", "44100", outputURL.path,
    ]

    try convertProcess.run()
    convertProcess.waitUntilExit()
    print("✅ Converted \(fileExtension) to raw: \(outputURL.path)")
    rawFilePath = outputURL
  }

  // 2. Read .raw file into floats
  let data = try Data(contentsOf: rawFilePath)
  var floats = [Float](repeating: 0, count: data.count / MemoryLayout<Float>.stride)
  _ = floats.withUnsafeMutableBytes { data.copyBytes(to: $0) }

  // 3. Save as JSON if requested
  if saveAsJson {
    let jsonURL = filePath.deletingLastPathComponent()
      .appendingPathComponent(
        filePath.deletingPathExtension().lastPathComponent + "_raw_amplitudes.json"
      )
    let jsonData = try JSONEncoder().encode(floats)
    try jsonData.write(to: jsonURL)
    print("✅ Raw audio samples saved as JSON to \(jsonURL.path)")
  }

  return floats
}
