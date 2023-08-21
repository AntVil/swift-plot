let values: [Float] = [2, 3, 2, 1, 1, 1, 2, 3, 4, 5, 4, 4, 2, 3, 2, 1, 1, 1, 2, 3, 4, 5, 4, 4]

let xTicks: [(Float, String)] = [
    (5, "06"),
    (11, "12"),
    (17, "18"),
    (23, "Wed"),
    (29, "06"),
    (35, "12"),
    (41, "18"),
    (47, "Thu"),
    (53, "06"),
    (59, "12"),
    (65, "18"),
    (71, "Fri"),
    (77, "06"),
    (83, "12"),
    (89, "18"),
    (95, "Sat"),
    (101, "06"),
    (107, "12"),
    (113, "18")
]

var general = [Plot]()

for i in 0..<5 {
    general.append(
        VerticalArea(
            fill: .hexadecimal("#EEF"),
            x1: Float(24 * i),
            x2: Float(24 * i + 8)
        )
    )
}

general.append(
    VerticalLine(
        lineStyle: .dashed([.millimeter(3), .millimeter(1)]),
        x: 16
    )
)

let figure = Figure(
    margin: Margin(top: .centimeter(3), bottom: .centimeter(3)),
    gizmos: [
        TextLabel(
            transform: .topLeft(50, 50),
            text: "A Custom Figure Title",
            textAnchor: .left,
            fontSize: .point(30)
        ),
        TextLabel(
            transform: .topLeft(100, 50),
            text: "with subtitle",
            textAnchor: .left,
            fontSize: .point(26),
            color: .hexadecimal("#999")
        ),
        TextLabel(
            transform: .bottomLeft(50, 50),
            text: "bottom text",
            textAnchor: .left,
            fontSize: .point(26),
            color: .hexadecimal("#999")
        )
    ],
    SubFigure(
        margin: Margin(.centimeter(4), .centimeter(1)),
        XAxis(
            tick: .custom(ticks: xTicks),
            tickSize: .point(26),
            leftYAxis: YAxis(
                tickSize: .point(26),
                label: "Temperature (°C)",
                labelSize: .point(26),
                general + [
                    HorizontalLines(
                        strokeWidth: .millimeter(0.5),
                        lineStyle: .dashed([.millimeter(1), .millimeter(1)])
                    ),
                    LinePlot(
                        stroke: .hexadecimal("#F00"),
                        strokeWidth: .millimeter(2),
                        // (-4...4).map { x in Float(x * x) }
                        (0..<120).map { _ in .random(in: 10...25) }
                    )
                ]
            )
        )
    ),
    SubFigure(
        margin: Margin(.centimeter(4), .centimeter(1)),
        XAxis(
            tick: .custom(ticks: xTicks),
            tickSize: .point(26),
            firstAxis: .right,
            leftYAxis: YAxis(
                scale: .range(0, 5),
                tickSize: .point(26),
                label: "Precipitation (mm/h)",
                labelSize: .point(26),
                [
                    HorizontalLines(
                        lineStyle: .dashed([.millimeter(1), .millimeter(1)])
                    ),
                    BarPlot(
                        fill: .hexadecimal("#9DD"),
                        (0..<120).map { _ in .random(in: 0...4) * .random(in: 0...1) }
                    ),
                    BarPlot(
                        fill: .hexadecimal("#33F"),
                        (0..<120).map { _ in .random(in: 0...3) * .random(in: 0...1) }
                    )
                ]
            ),
            rightYAxis: YAxis(
                scale: .min(0),
                tickSize: .point(26),
                label: "Altitude (km)",
                labelSize: .point(26),
                general + [
                    LinePlot(
                        stroke: .hexadecimal("#F00"),
                        strokeWidth: .millimeter(2),
                        [0, 14]
                        // (-4...4).map { x in Float(x * x) }
                    ),
                    HorizontalArea(
                        fill: .hexadecimal("#DAA"),
                        y1: 0,
                        y2: 1.5
                    )
                ]
            )
        )
    ),
    SubFigure(
        margin: Margin(.centimeter(4), .centimeter(1)),
        XAxis(
            tick: .custom(ticks: xTicks),
            tickSize: .point(26),
            leftYAxis: YAxis(
                tickSize: .point(26),
                label: "Wind speed (ms-1)",
                labelSize: .point(26),
                labelColor: .hexadecimal("#09F"),
                general + [
                    HorizontalLines(
                        lineStyle: .dashed([.millimeter(1), .millimeter(1)])
                    ),
                    LinePlot(
                        stroke: .hexadecimal("#09F"),
                        (0..<120).map { _ in .random(in: 1...20) }
                    ),
                    LinePlot(
                        stroke: .hexadecimal("#0D9"),
                        (0..<120).map { _ in .random(in: 1...20) }
                    )
                ]
            ),
            rightYAxis: YAxis(
                tickSize: .point(26),
                label: "Wind gust (ms-1)",
                labelSize: .point(26),
                labelColor: .hexadecimal("#0D9")
            )
        )
    )
)

// print(figure.svg(width: .pixel(1600), height: .pixel(1332), cellsPerCentimeter: 30))

var renderer = SvgRenderer(width: .pixel(1600), height: .pixel(1332))

figure.renderInto(renderer: &renderer)

print(renderer.getOutput())
