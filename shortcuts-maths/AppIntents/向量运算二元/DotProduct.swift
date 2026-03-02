//
//  MathsDotProduct.swift
//  shortcuts-maths
//
//  Created by leo on 2026.03.01.
//

import AppIntents
import Accelerate

struct VecDotProduct: AppIntent {
    static var title: LocalizedStringResource = "Vector: Dot Product"
    static var description = IntentDescription(
        "Calculates the dot product of two vectors.",
        resultValueName: "Dot Result"
    )
    
    @Parameter(title: "Vector A") var vectorA: VectorEntity
    @Parameter(title: "Vector B") var vectorB: VectorEntity

    static var parameterSummary: some ParameterSummary {
        Summary("Calculate \(\.$vectorA) · \(\.$vectorB)")
    }

    func perform() async throws -> some IntentResult & ReturnsValue<Double> {
        guard vectorA.elements.count == vectorB.elements.count else {
            throw VectorError.dimensionMismatch(vecA: vectorA, vecB: vectorB)
        }
        guard !vectorA.elements.isEmpty else { return .result(value: 0.0) }
        let result = vDSP.dot(vectorA.elements, vectorB.elements)
        return .result(value: result)
    }
}
