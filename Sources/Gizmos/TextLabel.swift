class TextLabel: Gizmo {
    private let transform: Transform
    private let text: String
    private let textAnchor: TextAnchor
    private let textBaselineAnchor: TextBaselineAnchor
    private let fontSize: Length
    private let color: Color
    
    init(
        x: Float,
        y: Float,
        text: String,
        textAnchor: TextAnchor = .center,
        textBaselineAnchor: TextBaselineAnchor = .center,
        fontSize: Length,
        color: Color = .hexadecimal("#000")
    ) {
        self.transform = .topLeft(y, x)
        self.text = text
        self.textAnchor = textAnchor
        self.textBaselineAnchor = textBaselineAnchor
        self.fontSize = fontSize
        self.color = color
    }

    init(
        x: Length,
        y: Length,
        text: String,
        textAnchor: TextAnchor = .center,
        textBaselineAnchor: TextBaselineAnchor = .center,
        fontSize: Length,
        color: Color = .hexadecimal("#000")
    ) {
        self.transform = .topLeft(y.getPixel(), x.getPixel())
        self.text = text
        self.textAnchor = textAnchor
        self.textBaselineAnchor = textBaselineAnchor
        self.fontSize = fontSize
        self.color = color
    }
    
    init(
        transform: Transform,
        text: String,
        textAnchor: TextAnchor = .center,
        textBaselineAnchor: TextBaselineAnchor = .center,
        fontSize: Length,
        color: Color = .hexadecimal("#000")
    ) {
        self.transform = transform
        self.text = text
        self.textAnchor = textAnchor
        self.textBaselineAnchor = textBaselineAnchor
        self.fontSize = fontSize
        self.color = color
    }

    func renderInto<R: Renderer>(renderer: inout R) {
        let (x, y) = transform.getPosition(
            width: renderer.getWidth(),
            height: renderer.getHeight()
        )

        renderer.text(
            x: x,
            y: y,
            content: text,
            textAnchor: textAnchor,
            textBaselineAnchor: textBaselineAnchor,
            fontSize: fontSize.getPixel(),
            color: color
        )
    }
}
