//
//  FFT.swift
//  shortcuts-maths
//
//  Created by leo on 2026.03.01.
//

import AppIntents
import Accelerate

struct VectorFFTMagnitudeIntent: AppIntent {
    static var title: LocalizedStringResource = "Vector: FFT Magnitude"
    static var description = IntentDescription(
        "Calculates the FFT of input vector.",
        resultValueName: "FFT Result"
    )
    @Parameter(title: "Vector") var vector: VectorEntity
    
    static var parameterSummary: some ParameterSummary {
        Summary("FFT of \(\.$vector)")
    }
    
    func perform() async throws -> some IntentResult & ReturnsValue<VectorEntity> {
        let n = vector.elements.count
        if n == 0 { throw VectorError.emptyVector }
        let log2n = vDSP_Length(log2(Double(n)).rounded(.up))
        let fftSize = Int(pow(2.0, Double(log2n)))
        // Setup FFT
        guard let fftSetup = vDSP_create_fftsetupD(log2n, Int32(kFFTRadix2)) else {
            throw VectorError.emptyVector
        }
        defer { vDSP_destroy_fftsetupD(fftSetup) }
        // Prepare complex buffers
        var realInput = vector.elements
        if realInput.count < fftSize {
            realInput.append(contentsOf: [Double](repeating: 0, count: fftSize - realInput.count))
        }
        var imagInput = [Double](repeating: 0, count: fftSize)
        var splitComplex: DSPDoubleSplitComplex = await withCheckedContinuation { c in
            realInput.withUnsafeMutableBufferPointer { real in
                imagInput.withUnsafeMutableBufferPointer { imag in
                    c.resume(returning: DSPDoubleSplitComplex(realp: real.baseAddress!, imagp: imag.baseAddress!))
                }
            }
        }
        //var splitComplex = DSPDoubleSplitComplex(realp: &realInput, imagp: &imagInput)
        // Perform Forward FFT
        vDSP_fft_zipD(fftSetup, &splitComplex, 1, log2n, Int32(FFT_FORWARD))
        // Calculate Magnitude: sqrt(re^2 + im^2)
        var magnitudes = [Double](repeating: 0, count: fftSize / 2)
        vDSP_zvmagsD(&splitComplex, 1, &magnitudes, 1, vDSP_Length(fftSize / 2))
        let finalMagnitudes = magnitudes.map { sqrt($0) }
        return .result(value: VectorEntity(finalMagnitudes))
    }
}
