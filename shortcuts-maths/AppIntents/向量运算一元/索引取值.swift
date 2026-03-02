//
//  索引取值.swift
//  shortcuts-maths
//
//  Created by leo on 2026.03.02.
//

import AppIntents
import Accelerate

struct ElementAtIndexIntent: AppIntent {
    static var title: LocalizedStringResource = "Vector: Element at index"
    static var description = IntentDescription(
        "Get element at some index. Index starts at 1. -N is the last Nth.",
        resultValueName: "Value"
    )
    
    @Parameter(title: "Vector") var vector: VectorEntity
    @Parameter(title: "Index") var index: Int

    static var parameterSummary: some ParameterSummary {
        Summary("From \(\.$vector) get value at \(\.$index).")
    }

    func perform() async throws -> some IntentResult & ReturnsValue<Double> {
        let v = vector.elements
        if v.isEmpty { throw VectorError.emptyVector }
        if abs(index) > v.count { throw VectorError.outOfBound(vec: vector, index: index) }
        if index < 0 { return .result(value: v[v.endIndex + index + 1]) }
        if index > 0 { return .result(value: v[index - 1]) }
        throw VectorError.outOfBound(vec: vector, index: 0)
    }
}
