import Accelerate

public func fft(samples: [Float], sampleRate: Float) -> [(frequency: Float, amplitude: Float)] {
  // Number of samples must be a power of 2 for FFT
  let n = samples.count

  // Create FFT setup
  let log2n = vDSP_Length(log2(Float(n)))
  guard let fftSetup = vDSP_create_fftsetup(log2n, FFTRadix(kFFTRadix2)) else {
    fatalError("Failed to create FFT setup")
  }

  var results: [(frequency: Float, amplitude: Float)] = []

  // Use UnsafeMutableBufferPointer to properly handle pointers
  var real = [Float](samples)
  var imaginary = [Float](repeating: 0.0, count: n)

  real.withUnsafeMutableBufferPointer { realBuffer in
    imaginary.withUnsafeMutableBufferPointer { imaginaryBuffer in
      var splitComplex = DSPSplitComplex(
        realp: realBuffer.baseAddress!,
        imagp: imaginaryBuffer.baseAddress!
      )

      // Perform FFT
      vDSP_fft_zip(fftSetup, &splitComplex, 1, log2n, FFTDirection(FFT_FORWARD))

      // Calculate magnitudes (half of spectrum due to symmetry)
      var magnitudes = [Float](repeating: 0.0, count: n / 2)
      for i in 0 ..< n / 2 {
        let realPart = realBuffer[i]
        let imaginaryPart = imaginaryBuffer[i]
        magnitudes[i] = sqrt(realPart * realPart + imaginaryPart * imaginaryPart)
      }

      // Frequency resolution (bin size)
      let frequencyResolution = sampleRate / Float(n)

      // Collect results
      for i in 0 ..< n / 2 {
        let frequency = Float(i) * frequencyResolution
        results.append((frequency, magnitudes[i]))
      }
    }
  }

  // Clean up
  vDSP_destroy_fftsetup(fftSetup)

  // Return top frequencies, ignoring very low amplitudes
  return results.filter { $0.amplitude > 0.01 }.sorted { $0.amplitude > $1.amplitude }
}
