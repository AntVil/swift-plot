protocol Renderer {
    var width: Float { get }
    var height: Float { get }
    var originX: Float { get }
    var originY: Float { get }
    var scaleX: Float { get }
    var scaleY: Float { get }

    associatedtype RenderType

    func close()

    func getOutput() -> RenderType

    func transform(translateX: Float, translateY: Float)

    func transform(scaleX: Float, scaleY: Float)

    func setTransform(translateX: Float, translateY: Float)

    func setTransform(scaleX: Float, scaleY: Float)

    func setTransform(width: Float, height: Float)

    func rectangle(
        x: Float,
        y: Float,
        width: Float,
        height: Float,
        fill: Color,
        stroke: Color,
        strokeWidth: Float,
        lineStyle: LineStyle
    )

    func line(
        x1: Float,
        y1: Float,
        x2: Float,
        y2: Float,
        stroke: Color,
        strokeWidth: Float,
        lineStyle: LineStyle
    )

    func horizontalLine(
        x: Float,
        y: Float,
        width: Float,
        stroke: Color,
        strokeWidth: Float,
        lineStyle: LineStyle
    )

    func verticalLine(
        x: Float,
        y: Float,
        height: Float,
        stroke: Color,
        strokeWidth: Float,
        lineStyle: LineStyle
    )

    func path(
        x: [Float],
        y: [Float],
        fill: Color,
        stroke: Color,
        strokeWidth: Float,
        lineStyle: LineStyle
    )

    func text(
        x: Float,
        y: Float,
        content: String,
        textAnchor: TextAnchor,
        textBaselineAnchor: TextBaselineAnchor,
        fontSize: Float,
        color: Color
    )

    func verticalText(
        x: Float,
        y: Float,
        content: String,
        textAnchor: TextAnchor,
        textBaselineAnchor: TextBaselineAnchor,
        fontSize: Float,
        color: Color
    )
}

extension Renderer {
    func rectangle(
        x: Float,
        y: Float,
        width: Float,
        height: Float,
        fill: Color,
        stroke: Color = .none,
        strokeWidth: Float = 0,
        lineStyle: LineStyle = .solid
    ) {
        rectangle(
            x: x,
            y: y,
            width: width,
            height: height,
            fill: fill,
            stroke: stroke,
            strokeWidth: strokeWidth,
            lineStyle: lineStyle
        )
    }

    func getWidth() -> Float {
        return width * scaleX
    }

    func getHeight() -> Float {
        return height * scaleY
    }
}
