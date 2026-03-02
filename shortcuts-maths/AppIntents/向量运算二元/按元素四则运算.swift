//
//  MathsAdd.swift
//  shortcuts-maths
//
//  Created by leo on 2026.03.01.
//

import AppIntents
import Accelerate

enum ComputeOperation: String, AppEnum {
    case add, subtract, multiply, divide
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Operation"
    static var caseDisplayRepresentations: [ComputeOperation: DisplayRepresentation] = [
        .add: " + ", .subtract: " - ", .multiply: " × ", .divide: " ÷ "
    ]
}

enum MismatchStrategy: String, AppEnum {
    case throwError, truncate, fill
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Mismatch Strategy"
    static var caseDisplayRepresentations: [MismatchStrategy: DisplayRepresentation] = [
        .throwError: "Throw Error",
        .truncate: "Truncate to Shorter",
        .fill: "Fill with Constant"
    ]
}

struct ElementWiseComputeIntent: AppIntent {
    static var title: LocalizedStringResource = "Vector: Element-wise Compute"
    
    @Parameter(title: "Vector A") var vectorA: VectorEntity
    @Parameter(title: "Operation") var operation: ComputeOperation
    @Parameter(title: "Vector B") var vectorB: VectorEntity
    
    @Parameter(title: "If Dimensions Mismatch", default: .throwError)
    var strategy: MismatchStrategy
    
    @Parameter(title: "Filling", default: 0.0)
    var fillValue: Double

    // Dynamic Summary: Only show "Fill Value" if the strategy is set to .fill
    static var parameterSummary: some ParameterSummary {
        Switch(\.$strategy) {
            Case(.fill) {
                Summary("\(\.$operation) \(\.$vectorA) and \(\.$vectorB)") {
                    \.$strategy
                    \.$fillValue
                }
            }
            DefaultCase {
                Summary("\(\.$operation) \(\.$vectorA) and \(\.$vectorB)") {
                    \.$strategy
                }
            }
        }
    }

    func perform() async throws -> some IntentResult & ReturnsValue<VectorEntity> {
        var a = vectorA.elements
        var b = vectorB.elements
        if a.isEmpty || b.isEmpty { throw VectorError.emptyVector }
        
        // 1. Handle Mismatch
        if a.count != b.count {
            switch strategy {
            case .throwError:
                throw VectorError.dimensionMismatch(vecA: vectorA, vecB: vectorB)
            case .truncate:
                let minCount = min(a.count, b.count)
                a = Array(a.prefix(minCount))
                b = Array(b.prefix(minCount))
            case .fill:
                let maxCount = max(a.count, b.count)
                if a.count < maxCount {
                    a.append(contentsOf: Array(repeating: fillValue, count: maxCount - a.count))
                }
                if b.count < maxCount {
                    b.append(contentsOf: Array(repeating: fillValue, count: maxCount - b.count))
                }
            }
        }

        // 2. Hardware Accelerated Math
        let result: [Double]
        switch operation {
        case .add:
            result = vDSP.add(a, b)
        case .subtract:
            result = vDSP.subtract(a, b)
        case .multiply:
            result = vDSP.multiply(a, b)
        case .divide:
            // Using vForce for high-performance element-wise division
            var divResult = [Double](repeating: 0, count: a.count)
            var n = Int32(a.count)
            vvdiv(&divResult, a, b, &n)
            result = divResult
        }

        return .result(value: VectorEntity(result))
    }
}
