public class GridLines: Plot {
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

    }
}
