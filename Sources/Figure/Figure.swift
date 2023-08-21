public class Figure {
    private let margin: Margin
    private let backgroundColor: Color
    private let subFigures: [SubFigure]
    private let gizmos: [Gizmo]

    init(
        margin: Margin = Margin(top: .centimeter(1), right: .centimeter(1), bottom: .zero, left: .centimeter(1)),
        backgroundColor: Color = .hexadecimal("#FFF"),
        gizmos: [Gizmo] = [],
        _ subFigures: SubFigure...
    ) {
        self.margin = margin
        self.backgroundColor = backgroundColor
        self.gizmos = gizmos
        self.subFigures = subFigures
    }

    func computeSubFigureHeights(contentHeight: Float) -> [Float] {
        let fractions = self.subFigures.map { $0.getTotalVerticalFraction() }
        let totalFraction = Fraction(fractions)

        let usedHeights = self.subFigures.map { $0.getTotalVerticalUsedHeight().getCentimeter() }
        let freeHeight = contentHeight - usedHeights.reduce(0, +)

        let plotHeights = fractions.map { $0.of(totalFraction) * freeHeight }

        return zip(plotHeights, usedHeights).map { $0 + $1 }
    }

    func renderInto<R: Renderer>(renderer: inout R) {
        renderer.rectangle(
            x: 0,
            y: 0,
            width: renderer.getWidth(),
            height: renderer.getHeight(),
            fill: backgroundColor
        )

        let contentX = margin.left.getPixel()
        let contentY = margin.top.getPixel()
        let contentWidth = renderer.getWidth() - margin.totalHorizontal().getPixel()
        let contentHeight = renderer.getHeight() - margin.totalVertical().getPixel()

        let subFigureHeights = computeSubFigureHeights(contentHeight: contentHeight)

        for gizmo in gizmos {
            gizmo.renderInto(renderer: &renderer)
        }

        var subPlotY = contentY
        for (index, subFigure) in subFigures.enumerated() {
            renderer.setTransform(translateX: contentX, translateY: subPlotY)
            renderer.setTransform(width: contentWidth, height: subFigureHeights[index])

            subFigure.renderInto(renderer: &renderer)
            subPlotY += subFigureHeights[index]
        }

        renderer.close()
    }
}
