//
//  CrossProduct.swift
//  shortcuts-maths
//
//  Created by leo on 2026.03.01.
//

import AppIntents
import Accelerate

struct CrossProductIntent: AppIntent {
    static var title: LocalizedStringResource = "Vector: Cross Product"
    static var description = IntentDescription(
        "Calculates the cross product of two vectors. Only length 3 is allowed",
        resultValueName: " × Result"
    )
    
    @Parameter(title: "Vector A") var vectorA: VectorEntity
    @Parameter(title: "Vector B") var vectorB: VectorEntity

    static var parameterSummary: some ParameterSummary {
        Summary("Calculate \(\.$vectorA) × \(\.$vectorB)")
    }

    func perform() async throws -> some IntentResult & ReturnsValue<VectorEntity> {
        let a = vectorA.elements, b = vectorB.elements
        guard a.count == 3 && b.count == 3 else { throw VectorError.not3D }
        return .result(value: VectorEntity([
            a[1] * b[2] - a[2] * b[1],
            a[2] * b[0] - a[0] * b[2],
            a[0] * b[1] - a[1] * b[0]
        ]))
    }
}
