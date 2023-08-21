public class HorizontalArea: Plot {
    private let fill: Color
    private let y1: Float
    private let y2: Float

    init(
        fill: Color = .hexadecimal("#000"),
        strokeWidth: Length = .millimeter(1),
        lineStyle: LineStyle = .solid,
        y1: Float,
        y2: Float
    ) {
        self.fill = fill

        if y1 < y2 {
            self.y1 = y1
            self.y2 = y2
        } else {
            self.y1 = y2
            self.y2 = y1
        }
    }

    public func calculateXRange() -> (Float?, Float?) {
        return (nil, nil)
    }

    public func calculateYRange() -> (Float?, Float?) {
        return (nil, nil)
    }

    func renderInto<R: Renderer>(xAxis: XAxis, yAxis: YAxis, renderer: inout R) {
        let (AxisMinY, AxisMaxY) = yAxis.getYRange()

        let ySpan = AxisMaxY - AxisMinY

        let y1 = renderer.getHeight() * (1 - (min(max(self.y1, AxisMinY), AxisMaxY) - AxisMinY) / ySpan)
        let y2 = renderer.getHeight() * (1 - (min(max(self.y2, AxisMinY), AxisMaxY) - AxisMinY) / ySpan)
        let height = y2 - y1

        renderer.rectangle(
            x: 0,
            y: y1,
            width: renderer.getWidth(),
            height: height,
            fill: fill,
            stroke: .none,
            strokeWidth: 0,
            lineStyle: .solid
        )
    }
}
