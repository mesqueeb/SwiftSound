import Foundation

/// Reveal file in Finder and open it in Quick Look using `qlmanage`
public func revealInFinder(filePath: String) {
  let fileURL = URL(fileURLWithPath: filePath)
  // 1. Reveal file in Finder
  let revealProcess = Process()
  revealProcess.executableURL = URL(fileURLWithPath: "/usr/bin/open")
  revealProcess.arguments = ["-R", fileURL.path]
  do {
    try revealProcess.run()
    revealProcess.waitUntilExit()
  } catch {
    print("❌ Failed to reveal \(filePath) in Finder: \(error)")
    return
  }
}
