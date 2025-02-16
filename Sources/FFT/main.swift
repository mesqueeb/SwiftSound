import Foundation
import ArgumentParser
import SwiftSound

@main struct FFT: ParsableCommand {
  static let configuration = CommandConfiguration(
    abstract: "A Swift command-line tool for FFT analysis."
  )

  @Argument(help: "The path to the raw audio file.") var inputFile: String

  @Flag(name: .long, help: "Save the extracted raw amplitude as JSON.") var json: Bool = false

  @Flag(name: .long, help: "Save an SVG spectrogram to a file.") var svg: Bool = false

  @Flag(name: .long, help: "Open the SVG in Preview.") var open: Bool = false

  @Option(name: .shortAndLong, help: "Output SVG spectogram filename.") var output: String = ""

  @Option(name: .shortAndLong, help: "Sample rate of the audio file.") var sampleRate: Float =
    44100.0

  @Option(name: .shortAndLong, help: "Maximum frequency to show in spectrogram.") var maxFrequency:
    Float = 1000.0

  @Flag(name: .shortAndLong, help: "Enable verbose output.") var verbose: Bool = false

  func run() throws {
    let filePath = URL(fileURLWithPath: inputFile)

    // Step 1: Read audio samples
    let samples = try readRawAudio(filePath: filePath, saveAsJson: json)

    // Step 2: Perform Short-Time Fourier Transform (STFT)
    let spectrogram = stft(samples: samples, sampleRate: sampleRate, windowSize: 1024, hopSize: 512)

    // Handle SVG output
    if svg {
      let svgPath: String
      if !output.isEmpty {
        // Use provided filename if specified
        svgPath = output.hasSuffix(".svg") ? output : "\(output).svg"
      } else {
        // Use default filename based on input file
        let defaultName = filePath.deletingPathExtension().lastPathComponent + "_spectrogram.svg"
        svgPath = filePath.deletingLastPathComponent().appendingPathComponent(defaultName).path
      }

      // Save the SVG using the helper function
      try saveSpectrogramAsSVG(spectrogram: spectrogram, outputPath: svgPath)

      print("✅ Spectrogram saved to \(svgPath)")

      // Step 4: Automatically Open in Preview if `--open` is set
      if open, !svgPath.isEmpty { revealInFinder(filePath: svgPath) }
    }

    // Step 4: Print Top Frequencies (if verbose)
    if verbose {
      print("Top Frequencies (First Time Slice):")
      for (frequency, amplitude) in spectrogram.first?.prefix(20) ?? [] {
        print("\(frequency) Hz: \(amplitude)")
      }
    } else {
      for (frequency, _) in spectrogram.first?.prefix(10) ?? [] { print("\(frequency) Hz") }
    }
  }
}
