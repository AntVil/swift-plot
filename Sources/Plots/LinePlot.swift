public class LinePlot: Plot {
    private let stroke: Color
    private let strokeWidth: Length
    private let lineStyle: LineStyle
    private let x: [Float]
    private let y: [Float]

    private let minX: Float
    private let maxX: Float
    private let minY: Float
    private let maxY: Float

    init(
        stroke: Color = .hexadecimal("#000"),
        strokeWidth: Length = .millimeter(1),
        lineStyle: LineStyle = .solid,
        _ values: [Float]
    ) {
        guard values.count >= 2 else {
            fatalError("line plot with less than two values is not possible")
        }

        self.stroke = stroke
        self.strokeWidth = strokeWidth
        self.lineStyle = lineStyle

        self.x = Array(0...values.count).map { Float($0) }
        self.y = values

        minX = self.x.min()!
        maxX = self.x.max()!
        minY = self.y.min()!
        maxY = self.y.max()!
    }

    public func calculateXRange() -> (Float?, Float?) {
        return (minX, maxX)
    }

    public func calculateYRange() -> (Float?, Float?) {
        return (minY, maxY)
    }

    func renderInto<R: Renderer>(xAxis: XAxis, yAxis: YAxis, renderer: inout R) {
        let (AxisMinX, AxisMaxX) = xAxis.getXRange()
        let (AxisMinY, AxisMaxY) = yAxis.getYRange()

        let xSpan = AxisMaxX - AxisMinX - 1
        let ySpan = AxisMaxY - AxisMinY

        let x = self.x.map { renderer.getWidth() * ($0 - AxisMinX) / xSpan }
        let y = self.y.map { renderer.getHeight() * (1 - ($0 - AxisMinY) / ySpan) }

        renderer.path(x: x, y: y, fill: .none, stroke: stroke, strokeWidth: strokeWidth.getPixel(), lineStyle: lineStyle)
    }
}
