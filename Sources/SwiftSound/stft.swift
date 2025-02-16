import Accelerate

/// | Window Size (FFT slice) | Hz Updates per Second | Used for…                    |
/// | ----------------------- | --------------------- | ---------------------------- |
/// | 1024 samples (~23ms)    | ~43 times/sec         | Speech, fast-changing sounds |
/// | 2048 samples (~46ms)    | ~21 times/sec         | Music, vocals                |
/// | 4096 samples (~93ms)    | ~10 times/sec         | Slow-changing tones          |
public func stft(
  samples: [Float],
  sampleRate: Float,
  windowSize: Int = 1024,
  hopSize: Int = 512
) -> [[(frequency: Float, amplitude: Float)]] {
  let totalSamples = samples.count
  var spectrogram: [[(frequency: Float, amplitude: Float)]] = []

  for start in stride(from: 0, to: totalSamples - windowSize, by: hopSize) {
    let end = start + windowSize
    let window = Array(samples[start ..< end])
    let fftResult = fft(samples: window, sampleRate: sampleRate)
    spectrogram.append(fftResult)
  }

  return spectrogram
}
