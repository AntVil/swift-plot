public class VerticalArea: Plot {
    private let fill: Color
    private let x1: Float
    private let x2: Float

    init(
        fill: Color = .hexadecimal("#000"),
        x1: Float,
        x2: Float
    ) {
        self.fill = fill

        if x1 < x2 {
            self.x1 = x1
            self.x2 = x2
        } else {
            self.x1 = x2
            self.x2 = x1
        }
    }

    public func calculateXRange() -> (Float?, Float?) {
        return (nil, nil)
    }

    public func calculateYRange() -> (Float?, Float?) {
        return (nil, nil)
    }

    func renderInto<R: Renderer>(xAxis: XAxis, yAxis: YAxis, renderer: inout R) {
        let (AxisMinX, AxisMaxX) = xAxis.getXRange()

        let xSpan = AxisMaxX - AxisMinX - 1

        let x1 = renderer.getWidth() * (min(max(self.x1, AxisMinX), AxisMaxX) - AxisMinX) / xSpan
        let x2 = renderer.getWidth() * (min(max(self.x2, AxisMinX), AxisMaxX) - AxisMinX) / xSpan
        let width = x2 - x1

        renderer.rectangle(
            x: x1,
            y: 0,
            width: width,
            height: renderer.getHeight(),
            fill: fill,
            stroke: .none,
            strokeWidth: 0,
            lineStyle: .solid
        )
    }
}
