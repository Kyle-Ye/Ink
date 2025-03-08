/**
*  Ink
*  Copyright (c) John Sundell 2019
*  MIT license, see LICENSE file for details
*/

struct InlineCode: ReadableFragment {
    var modifierTarget: Modifier.Target { .inlineCode }

    private var code: String

    static func read(using reader: inout Reader,
                     references: inout NamedReferenceCollection) throws -> InlineCode {
        try reader.read("`")
        var code = ""

        while !reader.didReachEnd {
            switch reader.currentCharacter {
            case \.isNewline:
                throw Reader.Error()
            case "`":
                reader.advanceIndex()
                return InlineCode(code: code)
            default:
                if let escaped = reader.currentCharacter.escaped {
                    code.append(escaped)
                } else {
                    code.append(reader.currentCharacter)
                }

                reader.advanceIndex()
            }
        }

        throw Reader.Error()
    }

    func html(usingReferences references: NamedReferenceCollection,
              modifiers: ModifierCollection) -> String {
        return "<code>\(code)</code>"
    }

    func plainText() -> String {
        code
    }
}
