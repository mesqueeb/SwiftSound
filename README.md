# SwiftSound 🔊

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmesqueeb%2FSwiftSound%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/mesqueeb/SwiftSound)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmesqueeb%2FSwiftSound%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/mesqueeb/SwiftSound)

```
.package(url: "https://github.com/mesqueeb/SwiftSound", from: "0.0.0")
```

An Experimental Swift CLI for FFT Analysis

## Overview

This repository was created as an **experiment to explore sound analysis** using Swift. Through this project, I aimed to understand **how sound works, how it is stored digitally, and how we can visualize it using techniques like Fast Fourier Transform (FFT).** The journey covered everything from **raw audio amplitude extraction to spectrogram generation**.

This tool reads audio files (including `.mp3`, `.wav`, `.flac`, and `.raw`) and processes them into **raw amplitude arrays** and **spectrograms**, while supporting **file format conversion** via SoX and generating **FFT visualizations**.

## 🛠️ How to Use

### **Installation**

1. **Ensure `sox` is installed**:
   ```bash
   brew install sox
   ```
2. **Clone the repository:**
   ```bash
   git clone https://github.com/mesqueeb/SwiftSound.git
   cd SwiftSound
   ```
3. **Run the tool:**
   ```bash
   swift run fft <input-file> [options]
   ```

### **Usage Overview:**

```
OVERVIEW: A Swift command-line tool for FFT analysis.

USAGE: fft <input-file> [--json] [--svg] [--open] [--output <output>] [--sample-rate <sample-rate>] [--max-frequency <max-frequency>] [--verbose]

ARGUMENTS:
  <input-file>            The path to the raw or audio file.

OPTIONS:
  --json                  Save the extracted raw amplitude as JSON.
  --svg                   Save an SVG spectrogram to a file.
  --open                  Open the SVG in Preview.
  -o, --output <output>   Output SVG spectrogram filename.
  -s, --sample-rate <sample-rate>  (default: 44100.0)
  -m, --max-frequency <max-frequency> (default: 1000.0)
  -v, --verbose           Enable verbose output.
  -h, --help              Show help information.
```

## Use Case Examples

1. **Convert and Analyze a `.mp3` File:**

   ```bash
   swift run fft elephant.mp3 --json --svg --open --verbose
   ```

2. **Analyze a `.wav` File and Save JSON Only:**

   ```bash
   swift run fft sound.wav --json
   ```

3. **Create an SVG Spectrogram with Custom Sample Rate:**
   ```bash
   swift run fft music.flac --svg --sample-rate 48000 --max-frequency 5000
   ```

## 📚 What I Learned About Sound

### 🧩 **The Building Blocks of Sound:**

- **Frequency (Pitch):** The speed of air vibrations, measured in Hertz (Hz). Higher frequency = higher pitch.
- **Amplitude (Gain):** The strength of the wave (how loud it is).
- **Timbre:** The unique fingerprint of a sound, which is a combination of:
  - **Harmonics:** Additional frequencies layered on top of the fundamental pitch.
  - **ADSR (Envelope):** The Attack, Decay, Sustain, and Release profile of a sound.
  - **Noise Characteristics:** Subtle imperfections or unique textures that distinguish sounds.

### 🎨 **How Sound Becomes Data:**

- **Sampling:** Measuring sound waves thousands of times per second (e.g., 44100 samples/sec).
- **Fourier Transform:** Breaking a complex wave into simple frequencies (FFT analysis).
- **Spectrograms:** Visualizing sound as time vs. frequency vs. amplitude.

### 🛠️ **Key Technical Lessons:**

- **File Formats:** `.raw` is uncompressed samples, while `.mp3`, `.wav`, and `.flac` compress audio differently.
- **SoX Integration:** Using `sox` can convert between audio formats and sample rates.
- **FFT Analysis:** FFT stands for Fast Fourier Transform, which converts sound waves into frequency components.
- **STFT Analysis:** STFT stands for Short-Time Fourier Transform, which breaks sound into time slices on which FFT is applied, resulting in a spectrogram of frequencies over time.
- **SVG Rendering:** Visualizing STFT results with `SwiftPlot`.

## ❤️ Why I Built This

This project started from a simple question: **“What is sound?”** and became a deep dive into **audio analysis, signal processing, and digital representations of sound.** It also became an exploration of how Swift can be used for scientific computation.

I hope this experiment inspires others to explore the **intersection of programming, science, and art**. 🎶💻✨

Feel free to fork this project, contribute, or reach out with suggestions!

**Author:** Luca Ban  
**GitHub:** [mesqueeb](https://github.com/mesqueeb)
