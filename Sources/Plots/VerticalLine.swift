public class VerticalLine: Plot {
    private let stroke: Color
    private let strokeWidth: Length
    private let lineStyle: LineStyle
    private let x: Float

    init(
        stroke: Color = .hexadecimal("#000"),
        strokeWidth: Length = .millimeter(1),
        lineStyle: LineStyle = .solid,
        x: Float
    ) {
        guard values.count >= 2 else {
            fatalError("line plot with less than two values is not possible")
        }

        self.stroke = stroke
        self.strokeWidth = strokeWidth
        self.lineStyle = lineStyle

        self.x = x
    }

    public func calculateXRange() -> (Float?, Float?) {
        return (x, x)
    }

    public func calculateYRange() -> (Float?, Float?) {
        return (nil, nil)
    }

    func renderInto<R: Renderer>(xAxis: XAxis, yAxis: YAxis, renderer: inout R) {
        let (AxisMinX, AxisMaxX) = xAxis.getXRange()
        let xSpan = AxisMaxX - AxisMinX - 1
        let x = renderer.getWidth() * (self.x - AxisMinX) / xSpan

        renderer.verticalLine(
            x: x,
            y: 0,
            height: renderer.getHeight(),
            stroke: stroke,
            strokeWidth: strokeWidth.getPixel(),
            lineStyle: lineStyle
        )
    }
}
