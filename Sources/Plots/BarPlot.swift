public class BarPlot: Plot {
    private let fill: Color
    private let barWidth: Length
    private let x: [Float]
    private let y: [Float]

    private let minX: Float
    private let maxX: Float
    private let minY: Float
    private let maxY: Float

    init(fill: Color = .hexadecimal("#000"), barWidth: Length = .millimeter(2), _ values: [Float]) {
        guard values.count >= 2 else {
            fatalError("line plot with less than two values is not possible")
        }

        self.fill = fill
        self.barWidth = barWidth

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
        let width = renderer.getWidth()
        let height = renderer.getHeight()

        let (AxisMinX, AxisMaxX) = xAxis.getXRange()
        let (AxisMinY, AxisMaxY) = yAxis.getYRange()

        let xSpan = AxisMaxX - AxisMinX - 1
        let ySpan = AxisMaxY - AxisMinY

        let xValues = self.x.map { width * ($0 - AxisMinX) / xSpan }
        let yValues = self.y.map { -height * ($0 - AxisMinY) / ySpan }

        let barWidth = barWidth.getPixel()
        let halfBarWidth = barWidth / 2

        for (x, y) in zip(xValues, yValues) {
            let left = max(x - halfBarWidth, 0)
            let right = min(x + halfBarWidth, width)
            let width = right - left

            renderer.rectangle(
                x: left,
                y: height + y,
                width: width,
                height: -y,
                fill: fill,
                stroke: .none,
                strokeWidth: 0,
                lineStyle: .solid
            )
        }
    }
}
