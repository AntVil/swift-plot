protocol Plot {
    func calculateXRange() -> (Float?, Float?)

    func calculateYRange() -> (Float?, Float?)

    func renderInto<R: Renderer>(xAxis: XAxis, yAxis: YAxis, renderer: inout R)
}
