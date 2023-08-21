public class SvgRenderer: Renderer {
    let width: Float
    let height: Float
    var originX: Float
    var originY: Float
    var scaleX: Float
    var scaleY: Float

    typealias RenderType = String

    private var instructions: [RenderType]

    init(width: Length, height: Length) {
        self.width = width.getPixel()
        self.height = height.getPixel()
        self.originX = 0
        self.originY = 0
        self.scaleX = 1
        self.scaleY = 1

        self.instructions = [
            """
            <svg viewBox="0 0 \(self.width) \(self.height)" version="1.1" xmlns="http://www.w3.org/2000/svg" font-family="Helvetica">
            """
        ]
    }

    func close() {
        instructions.append("</svg>")
    }

    func getOutput() -> RenderType {
        return instructions.joined(separator: "\n")
    }

    func transform(translateX: Float, translateY: Float) {
        self.originX += translateX
        self.originY += translateY
    }

    func transform(scaleX: Float, scaleY: Float) {
        self.scaleX *= scaleX
        self.scaleY *= scaleY
    }

    func setTransform(translateX: Float, translateY: Float) {
        self.originX = translateX
        self.originY = translateY
    }

    func setTransform(scaleX: Float, scaleY: Float) {
        self.scaleX = scaleX
        self.scaleY = scaleY
    }

    func setTransform(width: Float, height: Float) {
        self.scaleX = width / self.width
        self.scaleY = height / self.height
    }

    private func getDashes(lineStyle: LineStyle) -> String {
        switch lineStyle {
        case .solid:
            return ""
        case .dashed(let dashes):
            return """
            stroke-dasharray="\(
                dashes.map { String($0.getPixel()) }.joined(separator: " ")
            )"
            """
        }
    }

    private func getFill(fill: Color) -> String {
        switch fill {
        case .none:
            return "fill=\"none\""
        default:
            return "fill=\"\(fill.getHexadecimal())\""
        }
    }

    private func getStroke(stroke: Color) -> String {
        switch stroke {
        case .none:
            return "stroke=\"none\""
        default:
            return "stroke=\"\(stroke.getHexadecimal())\""
        }
    }

    private func transform(x: Float) -> Float {
        return x + originX
    }

    private func transform(y: Float) -> Float {
        return y + originY
    }

    func rectangle(
        x: Float,
        y: Float,
        width: Float,
        height: Float,
        fill: Color,
        stroke: Color,
        strokeWidth: Float,
        lineStyle: LineStyle
    ) {
        let stroke = getStroke(stroke: stroke)
        let fill = getFill(fill: fill)
        let strokeDash = getDashes(lineStyle: lineStyle)

        let x = transform(x: x)
        let y = transform(y: y)

        instructions.append("""
        <path d="M\(x),\(y)h\(width)v\(height)h\(-width)z" \(fill) \(stroke) stroke-width="\(strokeWidth)" \(strokeDash)/>
        """)
    }

    func line(
        x1: Float,
        y1: Float,
        x2: Float,
        y2: Float,
        stroke: Color,
        strokeWidth: Float,
        lineStyle: LineStyle
    ) {
        let stroke = getStroke(stroke: stroke)
        let strokeDash = getDashes(lineStyle: lineStyle)

        let x1 = transform(x: x1)
        let y1 = transform(y: y1)
        let x2 = transform(x: x2)
        let y2 = transform(y: y2)

        instructions.append("""
        <path d="M\(x1),\(y1)L\(x2),\(y2)" \(stroke) stroke-width="\(strokeWidth)" \(strokeDash)/>
        """)
    }

    func horizontalLine(
        x: Float,
        y: Float,
        width: Float,
        stroke: Color,
        strokeWidth: Float,
        lineStyle: LineStyle
    ) {
        let stroke = getStroke(stroke: stroke)
        let strokeDash = getDashes(lineStyle: lineStyle)

        let x = transform(x: x)
        let y = transform(y: y)

        instructions.append("""
        <path d="M\(x),\(y)h\(width)" \(stroke) stroke-width="\(strokeWidth)" \(strokeDash)/>
        """)
    }

    func verticalLine(
        x: Float,
        y: Float,
        height: Float,
        stroke: Color,
        strokeWidth: Float,
        lineStyle: LineStyle
    ) {
        let stroke = getStroke(stroke: stroke)
        let strokeDash = getDashes(lineStyle: lineStyle)

        let x = transform(x: x)
        let y = transform(y: y)

        instructions.append("""
        <path d="M\(x),\(y)v\(height)" \(stroke) stroke-width="\(strokeWidth)" \(strokeDash)/>
        """)
    }

    func path(
        x: [Float],
        y: [Float],
        fill: Color,
        stroke: Color,
        strokeWidth: Float,
        lineStyle: LineStyle
    ) {
        let stroke = getStroke(stroke: stroke)
        let fill = getFill(fill: fill)
        let strokeDash = getDashes(lineStyle: lineStyle)

        let path = zip(x, y).map { "\(transform(x: $0)),\(transform(y: $1))" }.joined(separator: "L")

        instructions.append("""
        <path d="M\(path)" \(fill) \(stroke) stroke-width="\(strokeWidth)" \(strokeDash)/>
        """)
    }

    func text(
        x: Float,
        y: Float,
        content: String,
        textAnchor: TextAnchor,
        textBaselineAnchor: TextBaselineAnchor,
        fontSize: Float,
        color: Color
    ) {
        let anchor: String
        let baselineAnchor: String

        switch textAnchor {
        case .left:
            anchor = "start"
        case .center:
            anchor = "middle"
        case .right:
            anchor = "end"
        }

        switch textBaselineAnchor {
        case .top:
            baselineAnchor = "hanging"
        case .center:
            baselineAnchor = "central"
        case .bottom:
            baselineAnchor = "alphabetic"
        }

        let x = transform(x: x)
        let y = transform(y: y)
        let fill = getFill(fill: color)

        instructions.append("""
        <text x="\(x)" y="\(y)" font-size="\(fontSize)" text-anchor="\(anchor)" dominant-baseline="\(baselineAnchor)" \(fill)>\(content)</text>
        """)
    }

    func verticalText(
        x: Float,
        y: Float,
        content: String,
        textAnchor: TextAnchor,
        textBaselineAnchor: TextBaselineAnchor,
        fontSize: Float,
        color: Color
    ) {
        let anchor: String
        let baselineAnchor: String

        switch textAnchor {
        case .left:
            anchor = "start"
        case .center:
            anchor = "middle"
        case .right:
            anchor = "end"
        }

        switch textBaselineAnchor {
        case .top:
            baselineAnchor = "hanging"
        case .center:
            baselineAnchor = "central"
        case .bottom:
            baselineAnchor = "alphabetic"
        }

        let x = transform(x: x)
        let y = transform(y: y)
        let fill = getFill(fill: color)

        instructions.append("""
        <text x="\(x)" y="\(y)" font-size="\(fontSize)" text-anchor="\(anchor)" dominant-baseline="\(baselineAnchor)" transform-origin="\(x) \(y)" transform="rotate(-90)" \(fill)>\(content)</text>
        """)
    }
}
