import Foundation

enum RewriteTone: String, CaseIterable, Identifiable, Hashable {
    case professional
    case casual
    case shorter
    case clearer

    var id: String { rawValue }

    var title: String {
        switch self {
        case .professional:
            return "Professional"
        case .casual:
            return "Casual"
        case .shorter:
            return "Shorter"
        case .clearer:
            return "Clearer"
        }
    }
}
