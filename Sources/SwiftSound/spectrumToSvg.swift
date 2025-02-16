import SwiftPlot
import SVGRenderer

/// Save spectrogram as a scatter plot SVG with thick blue line overlay.
/// Enhanced: Limited frequency range, intensity gradient, and clearer scatter display.
public func saveSpectrogramAsSVG(
  spectrogram: [[(frequency: Float, amplitude: Float)]],
  outputPath: String
) throws {
  var timePoints: [Float] = []
  var strongestFreq: [Float] = []
  var scatterPoints: [Pair<Float, Float>] = []
  var scatterColors: [Color] = []

  var hasValidData = false

  for (i, fftResult) in spectrogram.enumerated() {
    guard !fftResult.isEmpty else { continue }
    timePoints.append(Float(i))

    strongestFreq.append(fftResult.max(by: { $0.amplitude < $1.amplitude })?.frequency ?? Float.nan)

    // Limit frequency range and apply intensity-based coloring
    for freqPoint in fftResult where freqPoint.frequency <= 5000 && freqPoint.amplitude > 10 {
      scatterPoints.append(Pair(Float(i), freqPoint.frequency))
      scatterColors.append(colorForAmplitude(freqPoint.amplitude))
      hasValidData = true
    }
  }

  if !hasValidData {
    print("⚠️ No significant data available. Displaying fallback plot.")
    timePoints = [0, 1]
    strongestFreq = [0, 0]
    scatterPoints = [Pair(0, 0), Pair(1, 0)]
  }

  // --- Create Scatter Plot ---
  var scatterPlot = ScatterPlot<Float, Float>(enableGrid: true)
  scatterPlot.addSeries(
    points: scatterPoints,
    label: "Frequencies (0-5000 Hz)",
    color: Color(0.7, 0.7, 0.7, 0.15),  // Lower opacity for clarity
    scatterPattern: .circle
  )

  scatterPlot.addSeries(
    timePoints,
    strongestFreq,
    label: "Strongest Frequency",
    color: .blue,
    scatterPattern: .circle
  )

  scatterPlot.plotTitle = PlotTitle("Spectrogram (0-5000 Hz) with Strongest Frequency")
  scatterPlot.plotLabel = PlotLabel(xLabel: "Time (interval)", yLabel: "Frequency (Hz)")

  // Render to SVG
  let renderer = SVGRenderer()
  try scatterPlot.drawGraphAndOutput(
    fileName: outputPath.replacing(/\.svg/, with: ""),
    renderer: renderer
  )

  print("✅ Enhanced spectrogram saved to \(outputPath)")
}

/// Helper: Map amplitude to color gradient (grey to red)
func colorForAmplitude(_ amplitude: Float) -> Color {
  let intensity = min(amplitude / 5000.0, 1.0)
  return Color(1.0, 0.3 * (1.0 - intensity), 0.3 * (1.0 - intensity), 0.2 + 0.8 * intensity)
}
