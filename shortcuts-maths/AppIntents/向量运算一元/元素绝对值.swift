//
//  元素绝对值.swift
//  shortcuts-maths
//
//  Created by leo on 2026.03.01.
//

import AppIntents
import Accelerate

struct ElemAbsIntent: AppIntent {
    static var title: LocalizedStringResource = "Vector: Element-wise abs"
    static var description = IntentDescription(
        "Absolute value for each element of the vector.",
        resultValueName: "Abs Result"
    )
    
    @Parameter(title: "Vector") var vector: VectorEntity

    static var parameterSummary: some ParameterSummary {
        Summary("Element-wise abs for \(\.$vector)")
    }

    func perform() async throws -> some IntentResult & ReturnsValue<VectorEntity> {
        if vector.elements.isEmpty { throw VectorError.emptyVector }
        return .result(value: VectorEntity(vDSP.absolute(vector.elements)))
    }
}
