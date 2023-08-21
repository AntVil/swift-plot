public class SubFigure {
    private let heightFraction: Fraction
    public let margin: Margin
    private let xAxis: XAxis
    private let gizmos: [Gizmo]

    init(
        heightFraction: Fraction = Fraction(),
        margin: Margin = Margin(bottom: .centimeter(1)),
        gizmos: [Gizmo] = [],
        _ xAxis: XAxis
    ) {
        self.margin = margin
        self.heightFraction = heightFraction
        self.xAxis = xAxis
        self.gizmos = gizmos
    }

    public func getTotalVerticalFraction() -> Fraction {
        return heightFraction
    }

    public func getTotalVerticalUsedHeight() -> Length {
        return margin.totalVertical()
    }

    func renderInto<R: Renderer>(renderer: inout R) {
        let width = renderer.getWidth() - margin.totalHorizontal().getPixel()
        let height = renderer.getHeight() - margin.totalVertical().getPixel()
        renderer.transform(translateX: margin.left.getPixel(), translateY: margin.top.getPixel())
        renderer.setTransform(width: width, height: height)

        for gizmo in gizmos {
            gizmo.renderInto(renderer: &renderer)
        }

        xAxis.renderInto(renderer: &renderer)
    }
}
