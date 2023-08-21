import Foundation

public class XAxis {
    private var minX: Float = 0
    private var maxX: Float = 0
    private var xTicks = [Float]()
    private var xTickTexts = [String]()
    private var xTickStep: Float = 0

    private let tickMargin: Margin
    private let tickColor: Color
    private let tickSize: Length
    private let label: String
    private let labelMargin: Margin
    private let labelColor: Color
    private let backgroundColor: Color
    private let borderStroke: Color
    private let borderWidth: Length
    private let firstAxis: Orientation
    private let leftYAxis: YAxis?
    private let rightYAxis: YAxis?
    private let gizmos: [Gizmo]

    init(
        backgroundColor: Color = .hexadecimal("#FFF"),
        borderStroke: Color = .hexadecimal("#000"),
        borderWidth: Length = .millimeter(1),
        scale: AxisScale = .inferMargin(),
        tick: AxisTicks = .computed,
        tickSize: Length = .point(14),
        tickMargin: Margin = Margin(top: .millimeter(2)),
        tickColor: Color = .hexadecimal("#000"),
        label: String = "",
        labelMargin: Margin = Margin(.centimeter(2)),
        labelColor: Color = .hexadecimal("#000"),
        gizmos: [Gizmo] = [],
        leftYAxis: YAxis
    ) {
        self.tickMargin = tickMargin
        self.tickColor = tickColor
        self.tickSize = tickSize
        self.label = label
        self.labelColor = labelColor
        self.labelMargin = labelMargin
        self.backgroundColor = backgroundColor
        self.borderStroke = borderStroke
        self.borderWidth = borderWidth
        self.firstAxis = .left
        self.leftYAxis = leftYAxis
        self.rightYAxis = nil
        self.gizmos = gizmos

        (minX, maxX) = calculateScale(scale: scale)

        switch tick {
        case .none:
            self.xTicks = []
        case .computed:
            self.xTicks = calculateXTicks()
            if xTickStep < 0 {
                xTickTexts = xTicks.map { "\($0)" }
            } else {
                xTickTexts = xTicks.map { "\(Int($0))" }
            }
        case .renamed(let names):
            self.xTicks = calculateXTicks()
            xTickTexts = names
        case .custom(let ticks):
            for (tick, text) in ticks.sorted(by: { $0.0 < $1.0 }) {
                xTicks.append(tick)
                xTickTexts.append(text)
            }
        }
    }

    init(
        backgroundColor: Color = .hexadecimal("#FFF"),
        borderWidth: Length = .millimeter(1),
        borderStroke: Color = .hexadecimal("#000"),
        scale: AxisScale = .inferMargin(),
        tick: AxisTicks = .computed,
        tickSize: Length = .point(12),
        tickMargin: Margin = Margin(top: .millimeter(2)),
        tickColor: Color = .hexadecimal("#000"),
        label: String = "",
        labelMargin: Margin = Margin(.millimeter(2)),
        labelColor: Color = .hexadecimal("#000"),
        gizmos: [Gizmo] = [],
        rightYAxis: YAxis
    ) {
        self.tickMargin = tickMargin
        self.tickColor = tickColor
        self.tickSize = tickSize
        self.label = label
        self.labelColor = labelColor
        self.labelMargin = labelMargin
        self.backgroundColor = backgroundColor
        self.borderStroke = borderStroke
        self.borderWidth = borderWidth
        self.firstAxis = .right
        self.leftYAxis = nil
        self.rightYAxis = rightYAxis
        self.gizmos = gizmos

        (minX, maxX) = calculateScale(scale: scale)

        switch tick {
        case .none:
            self.xTicks = []
        case .computed:
            self.xTicks = calculateXTicks()
            if xTickStep < 0 {
                xTickTexts = xTicks.map { "\($0)" }
            } else {
                xTickTexts = xTicks.map { "\(Int($0))" }
            }
        case .renamed(let names):
            self.xTicks = calculateXTicks()
            xTickTexts = names
        case .custom(let ticks):
            for (tick, text) in ticks.sorted(by: { $0.0 < $1.0 }) {
                xTicks.append(tick)
                xTickTexts.append(text)
            }
        }
    }

    init(
        backgroundColor: Color = .hexadecimal("#FFF"),
        borderWidth: Length = .millimeter(1),
        borderStroke: Color = .hexadecimal("#000"),
        scale: AxisScale = .inferMargin(),
        tick: AxisTicks = .computed,
        tickSize: Length = .point(12),
        tickMargin: Margin = Margin(top: .millimeter(2)),
        tickColor: Color = .hexadecimal("#000"),
        label: String = "",
        labelMargin: Margin = Margin(.millimeter(2)),
        labelColor: Color = .hexadecimal("#000"),
        gizmos: [Gizmo] = [],
        firstAxis: Orientation = .left,
        leftYAxis: YAxis,
        rightYAxis: YAxis
    ) {
        self.tickMargin = tickMargin
        self.tickColor = tickColor
        self.tickSize = tickSize
        self.label = label
        self.labelColor = labelColor
        self.labelMargin = labelMargin
        self.backgroundColor = backgroundColor
        self.borderStroke = borderStroke
        self.borderWidth = borderWidth
        self.firstAxis = firstAxis
        self.leftYAxis = leftYAxis
        self.rightYAxis = rightYAxis
        self.gizmos = gizmos

        (minX, maxX) = calculateScale(scale: scale)

        switch tick {
        case .none:
            self.xTicks = []
        case .computed:
            self.xTicks = calculateXTicks()
            if xTickStep < 0 {
                xTickTexts = xTicks.map { "\($0)" }
            } else {
                xTickTexts = xTicks.map { "\(Int($0))" }
            }
        case .renamed(let names):
            self.xTicks = calculateXTicks()
            xTickTexts = names
        case .custom(let ticks):
            for (tick, text) in ticks.sorted(by: { $0.0 < $1.0 }) {
                xTicks.append(tick)
                xTickTexts.append(text)
            }
        }
    }

    public func calculateScale(scale: AxisScale) -> (Float, Float) {
        switch scale {
        case .inferMargin(let margin):
            let (min, max) = calculateXRange()
            return (min - margin, max + margin)
        case .min(let min):
            let (_, inferredMax) = calculateXRange()
            return (min, inferredMax)
        case .max(let max):
            let (inferredMin, _) = calculateXRange()
            return (inferredMin, max)
        case .range(let min, let max):
            return (min, max)
        }
    }

    public func calculateXRange() -> (Float, Float) {
        return (self.leftYAxis?.calculateXRange() ?? self.rightYAxis?.calculateXRange())!
    }

    public func getXRange() -> (Float, Float) {
        return (minX, maxX)
    }

    public func calculateXTicks() -> [Float] {
        let difference = maxX - minX
        let factor = pow(10, floor(log10(difference)) )
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

        xTickStep = normalizedStep * factor

        return Array(stride(from: ceil(minX / xTickStep) * xTickStep, through: maxX - 1, by: xTickStep))
    }

    public func getXTicks() -> [Float] {
        return xTicks
    }

    func renderInto<R: Renderer>(renderer: inout R) {
        switch self.firstAxis {
        case .left:
            leftYAxis?.renderInto(xAxis: self, orientation: .left, renderer: &renderer)
            rightYAxis?.renderInto(xAxis: self, orientation: .right, renderer: &renderer)
        case .right:
            rightYAxis?.renderInto(xAxis: self, orientation: .right, renderer: &renderer)
            leftYAxis?.renderInto(xAxis: self, orientation: .left, renderer: &renderer)
        }

        let xSpan = maxX - minX
        let width = renderer.getWidth()
        let height = renderer.getHeight()
        let y = height + tickMargin.top.getPixel()
        for (x, text) in zip(xTicks, xTickTexts) {
            renderer.text(
                x: width * (x - minX) / xSpan,
                y: y,
                content: text,
                textAnchor: .center,
                textBaselineAnchor: .top,
                fontSize: tickSize.getPixel(),
                color: tickColor
            )
        }

        renderer.rectangle(
            x: 0,
            y: 0,
            width: renderer.getWidth(),
            height: renderer.getHeight(),
            fill: .none,
            stroke: borderStroke,
            strokeWidth: borderWidth.getPixel()
        )

        for gizmo in gizmos {
            gizmo.renderInto(renderer: &renderer)
        }
    }
}
