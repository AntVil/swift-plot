public class HorizontalLines: Plot {
    private let stroke: Color
    private let strokeWidth: Length
    private let lineStyle: LineStyle

    init(
        stroke: Color = .hexadecimal("#000"),
        strokeWidth: Length = .millimeter(1),
        lineStyle: LineStyle = .solid
    ) {
        self.stroke = stroke
        self.strokeWidth = strokeWidth
        self.lineStyle = lineStyle
    }

    public func calculateXRange() -> (Float?, Float?) {
        return (nil, nil)
    }

    public func calculateYRange() -> (Float?, Float?) {
        return (nil, nil)
    }

    func renderInto<R: Renderer>(xAxis: XAxis, yAxis: YAxis, renderer: inout R) {
        let width = renderer.getWidth()
        let height = renderer.getHeight()
        let (AxisMinY, AxisMaxY) = yAxis.getYRange()
        let ySpan = AxisMaxY - AxisMinY

        for y in yAxis.getYTicks() {
            renderer.horizontalLine(
                x: 0,
                y: height * (1 - (y - AxisMinY) / ySpan),
                width: width,
                stroke: stroke,
                strokeWidth: strokeWidth.getPixel(),
                lineStyle: lineStyle
            )
        }
    }
}
