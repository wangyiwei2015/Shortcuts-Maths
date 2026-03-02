//
//  互相关.swift
//  shortcuts-maths
//
//  Created by leo on 2026.03.01.
//

import AppIntents
import Accelerate

struct CorrelationIntent: AppIntent {
    static var title: LocalizedStringResource = "Vector: Correlation"
    static var description = IntentDescription(
        "Calculates the correlation of two vectors.",
        resultValueName: "Correlation"
    )
    
    @Parameter(title: "Vector A") var vectorA: VectorEntity
    @Parameter(title: "Vector B") var vectorB: VectorEntity

    static var parameterSummary: some ParameterSummary {
        Summary("Correlation of \(\.$vectorA) and \(\.$vectorB)")
    }

    func perform() async throws -> some IntentResult & ReturnsValue<VectorEntity> {
        let a = vectorA.elements, b = vectorB.elements
        if a.isEmpty || b.isEmpty { throw VectorError.emptyVector }
        // Correlation (Cross and Auto)
        // Linear convolution/correlation via vDSP
        // Note: result length is N + M - 1
        return .result(value: VectorEntity(
            vDSP.convolve(a, withKernel: b.reversed())
        ))
    }
}
