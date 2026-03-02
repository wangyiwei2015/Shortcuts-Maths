//
//  向量乘标量.swift
//  shortcuts-maths
//
//  Created by leo on 2026.03.01.
//

import AppIntents
import Accelerate

struct ScalarMultiplyIntent: AppIntent {
    static var title: LocalizedStringResource = "Vector: Scalar Multiply"
    static var description = IntentDescription(
        "Scalar multiply the vector.",
        resultValueName: "Scalar Result"
    )
    
    @Parameter(title: "Vector") var vector: VectorEntity
    @Parameter(title: "Scalar") var scalar: Double

    static var parameterSummary: some ParameterSummary {
        Summary("Multiply \(\.$vector) by \(\.$scalar)")
    }

    func perform() async throws -> some IntentResult & ReturnsValue<VectorEntity> {
        if vector.elements.isEmpty { throw VectorError.emptyVector }
        let result = vDSP.multiply(scalar, vector.elements)
        return .result(value: VectorEntity(result))
    }
}
