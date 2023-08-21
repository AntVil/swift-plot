public class HorizontalLine: Plot {
    private let stroke: Color
    private let strokeWidth: Length
    private let lineStyle: LineStyle
    private let y: Float

    init(
        stroke: Color = .hexadecimal("#000"),
        strokeWidth: Length = .millimeter(1),
        lineStyle: LineStyle = .solid,
        y: Float
    ) {
        guard values.count >= 2 else {
            fatalError("line plot with less than two values is not possible")
        }

        self.stroke = stroke
        self.strokeWidth = strokeWidth
        self.lineStyle = lineStyle

        self.y = y
    }

    public func calculateXRange() -> (Float?, Float?) {
        return (nil, nil)
    }

    public func calculateYRange() -> (Float?, Float?) {
        return (y, y)
    }

    func renderInto<R: Renderer>(xAxis: XAxis, yAxis: YAxis, renderer: inout R) {
        let (AxisMinY, AxisMaxY) = yAxis.getYRange()
        let ySpan = AxisMaxY - AxisMinY
        let y = renderer.getHeight() * (self.y - AxisMinY) / ySpan

        renderer.horizontalLine(
            x: 0,
            y: y,
            width: renderer.getWidth(),
            stroke: stroke,
            strokeWidth: strokeWidth.getPixel(),
            lineStyle: lineStyle
        )
    }
}
