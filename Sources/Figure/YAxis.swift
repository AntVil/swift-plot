import Foundation

public class YAxis {
    private var minY: Float = 0
    private var maxY: Float = 0
    private var yTicks = [Float]()
    private var yTickTexts = [String]()
    private var yTickStep: Float = 0

    private let tickMargin: Margin
    private let tickColor: Color
    private let tickSize: Length
    private let label: String
    private let labelColor: Color
    private let labelMargin: Margin
    private let labelSize: Length
    private let plots: [Plot]
    private let gizmos: [Gizmo]

    init(
        size: Fraction = Fraction(1),
        tickSize: Length = .point(12),
        tickMargin: Margin = Margin(.millimeter(2)),
        tickColor: Color = .hexadecimal("#000"),
        label: String = "",
        labelSize: Length = .point(12),
        labelMargin: Margin = Margin(.centimeter(2)),
        labelColor: Color = .hexadecimal("#000"),
        gizmos: [Gizmo] = []
    ) {
        self.tickMargin = tickMargin
        self.tickColor = tickColor
        self.tickSize = tickSize
        self.label = label
        self.labelColor = labelColor
        self.labelMargin = labelMargin
        self.labelSize = labelSize
        self.yTickTexts = []
        self.plots = []
        self.gizmos = gizmos
    }

    init(
        size: Fraction = Fraction(1),
        scale: AxisScale = .inferMargin(5),
        tick: AxisTicks = .computed,
        tickSize: Length = .point(12),
        tickMargin: Margin = Margin(.millimeter(2)),
        tickColor: Color = .hexadecimal("#000"),
        label: String = "",
        labelSize: Length = .point(12),
        labelMargin: Margin = Margin(.centimeter(2)),
        labelColor: Color = .hexadecimal("#000"),
        gizmos: [Gizmo] = [],
        _ plots: [Plot]
    ) {
        guard !plots.isEmpty else {
            fatalError("y axis request at least one plot")
        }

        self.tickMargin = tickMargin
        self.tickColor = tickColor
        self.tickSize = tickSize
        self.label = label
        self.labelColor = labelColor
        self.labelMargin = labelMargin
        self.labelSize = labelSize
        self.plots = plots
        self.gizmos = gizmos

        (minY, maxY) = calculateScale(scale: scale)

        switch tick {
        case .none:
            self.yTicks = []
        case .computed:
            self.yTicks = calculateYTicks()
            if yTickStep < 0 {
                yTickTexts = yTicks.map { "\($0)" }
            } else {
                yTickTexts = yTicks.map { "\(Int($0))" }
            }
        case .renamed(let names):
            self.yTicks = calculateYTicks()
            yTickTexts = names
        case .custom(let ticks):
            for (tick, text) in ticks.sorted(by: { $0.0 < $1.0 }) {
                yTicks.append(tick)
                yTickTexts.append(text)
            }
        }
    }

    init(
        size: Fraction = Fraction(1),
        scale: AxisScale = .inferMargin(5),
        tick: AxisTicks = .computed,
        tickSize: Length = .point(12),
        tickMargin: Margin = Margin(.millimeter(2)),
        tickColor: Color = .hexadecimal("#000"),
        label: String = "",
        labelSize: Length = .point(12),
        labelMargin: Margin = Margin(.millimeter(2)),
        labelColor: Color = .hexadecimal("#000"),
        gizmos: [Gizmo] = [],
        _ plots: Plot...
    ) {
        guard !plots.isEmpty else {
            fatalError("y axis request at least one plot")
        }

        self.tickMargin = tickMargin
        self.tickColor = tickColor
        self.tickSize = tickSize
        self.label = label
        self.labelColor = labelColor
        self.labelMargin = labelMargin
        self.labelSize = labelSize
        self.plots = plots
        self.gizmos = gizmos

        (minY, maxY) = calculateScale(scale: scale)

        switch tick {
        case .none:
            self.yTicks = []
        case .computed:
            self.yTicks = calculateYTicks()
            if yTickStep < 0 {
                yTickTexts = yTicks.map { "\($0)" }
            } else {
                yTickTexts = yTicks.map { "\(Int($0))" }
            }
        case .renamed(let names):
            self.yTicks = calculateYTicks()
            yTickTexts = names
        case .custom(let ticks):
            for (tick, text) in ticks.sorted(by: { $0.0 < $1.0 }) {
                yTicks.append(tick)
                yTickTexts.append(text)
            }
        }
    }

    public func calculateScale(scale: AxisScale) -> (Float, Float) {
        switch scale {
        case .inferMargin(let margin):
            let (min, max) = calculateYRange()
            return (min - margin, max + margin)
        case .min(let min):
            let (_, inferredMax) = calculateYRange()
            return (min, inferredMax)
        case .max(let max):
            let (inferredMin, _) = calculateYRange()
            return (inferredMin, max)
        case .range(let min, let max):
            return (min, max)
        }
    }

    public func calculateXRange() -> (Float, Float) {
        let ranges = self.plots.map { $0.calculateXRange() }
        return (ranges.compactMap { $0.0 }.min()!, ranges.compactMap { $0.1 }.max()!)
    }

    public func calculateYRange() -> (Float, Float) {
        let ranges = self.plots.map { $0.calculateYRange() }
        return (ranges.compactMap { $0.0 }.min()!, ranges.compactMap { $0.1 }.max()!)
    }

    public func getYRange() -> (Float, Float) {
        return (minY, maxY)
    }

    public func calculateYTicks() -> [Float] {
        let difference = maxY - minY
        let factor = pow(10, floor(log10(difference)))
        let lookupValue = difference / factor

        let normalizedStep: Float
        switch lookupValue {
        case 0.8..<1.6:
            normalizedStep = 0.2
        case 1.6..<2.0:
            normalizedStep = 0.25
        case 2.0..<4.0:
            normalizedStep = 0.5
        case 4.0..<8.0:
            normalizedStep = 1.0
        default:
            fatalError("ups")
        }

        yTickStep = normalizedStep * factor

        return Array(stride(from: ceil(minY / yTickStep) * yTickStep, through: maxY, by: yTickStep))
    }

    public func getYTicks() -> [Float] {
        return yTicks
    }

    func renderInto<R: Renderer>(xAxis: XAxis, orientation: Orientation, renderer: inout R) {
        plots.forEach {
            $0.renderInto(xAxis: xAxis, yAxis: self, renderer: &renderer)
        }

        let ySpan = maxY - minY

        let width = renderer.getWidth()
        let height = renderer.getHeight()

        let x: Float
        let textAnchor: TextAnchor
        let labelX: Float
        switch orientation {
        case .left:
            x = -tickMargin.right.getPixel()
            textAnchor = .right
            labelX = -Length.add(tickMargin.left, labelMargin.left).getPixel()
        case .right:
            x = width + tickMargin.left.getPixel()
            textAnchor = .left
            labelX = width + Length.add(tickMargin.right, labelMargin.right).getPixel()
        }

        for (y, text) in zip(yTicks, yTickTexts) {
            renderer.text(
                x: x,
                y: height * (1 - (y - minY) / ySpan),
                content: text,
                textAnchor: textAnchor,
                textBaselineAnchor: .center,
                fontSize: tickSize.getPixel(),
                color: tickColor
            )
        }

        renderer.verticalText(
            x: labelX,
            y: height / 2,
            content: label,
            textAnchor: .center,
            textBaselineAnchor: .center,
            fontSize: labelSize.getPixel(),
            color: labelColor
        )

        for gizmo in gizmos {
            gizmo.renderInto(renderer: &renderer)
        }
    }
}
