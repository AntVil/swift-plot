public class VerticalLines: Plot {
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
        let (AxisMinX, AxisMaxX) = xAxis.getXRange()
        let xSpan = AxisMaxX - AxisMinX - 1

        for x in xAxis.getXTicks() {
            renderer.verticalLine(
                x: width * (x - AxisMinX) / xSpan,
                y: 0,
                height: height,
                stroke: stroke,
                strokeWidth: strokeWidth.getPixel(),
                lineStyle: lineStyle
            )
        }
    }
}
