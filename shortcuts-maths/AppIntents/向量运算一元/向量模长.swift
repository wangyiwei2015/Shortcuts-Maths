//
//  向量模长.swift
//  shortcuts-maths
//
//  Created by leo on 2026.03.01.
//

import AppIntents
import Accelerate

struct VectorDistanceIntent: AppIntent {
    static var title: LocalizedStringResource = "Vector: Magnitude (Euclidean Norm)"
    static var description = IntentDescription(
        "Calculates Euclidean Norm, also known as L2 norm, returning scalar.",
        resultValueName: "||Vector||"
    )
    @Parameter(title: "Vector") var vector: VectorEntity
    
    static var parameterSummary: some ParameterSummary {
        Summary("Magnitude of \(\.$vector)")
    }
    
    func perform() async throws -> some IntentResult & ReturnsValue<Double> {
        let v = vector.elements
        guard !v.isEmpty else { return .result(value: 0.0) }
        var sumOfSquares: Double = 0
        vDSP_svesqD(v, 1, &sumOfSquares, vDSP_Length(v.count))
        return .result(value: sqrt(sumOfSquares))
    }
}
