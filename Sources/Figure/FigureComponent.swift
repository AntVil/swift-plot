public enum Length {
    case zero
    case centimeter(_ length: Float)
    case millimeter(_ length: Float)
    case pixel(_ length: Float)
    case point(_ length: Float)

    public func getCentimeter() -> Float {
        switch self {
        case .zero:
            return 0
        case .centimeter(let centimeter):
            return centimeter
        case .millimeter(let millimeter):
            return millimeter / 10
        case .pixel(let pixel):
            return pixel / 35.43307
        case .point(let point):
            return point * 0.037620223141827676
        }
    }

    public func getPixel() -> Float {
        switch self {
        case .zero:
            return 0
        case .centimeter(let centimeter):
            return centimeter * 35.43307
        case .millimeter(let millimeter):
            return millimeter * 3.543307
        case .pixel(let pixel):
            return pixel
        case .point(let point):
            return point * 1.333
        }
    }

    public static func add(_ length1: Length, _ length2: Length) -> Length {
        return .centimeter(length1.getCentimeter() + length2.getCentimeter())
    }

    public static func subtract(_ length1: Length, _ length2: Length) -> Length {
        return .centimeter(length1.getCentimeter() - length2.getCentimeter())
    }
}

public enum AxisTicks {
    case none
    case computed
    case renamed(names: [String])
    case custom(ticks: [(Float, String)])
}

public enum Orientation {
    case left
    case right
}

public enum LineStyle {
    case solid
    case dashed([Length])
}

public enum AxisScale {
    case inferMargin(Float = 0)
    case min(Float)
    case max(Float)
    case range(Float, Float)
}

public enum TextAnchor {
    case left
    case center
    case right
}

public enum TextBaselineAnchor {
    case top
    case center
    case bottom
}

public class Margin {
    let top: Length
    let right: Length
    let bottom: Length
    let left: Length

    init(_ margin: Length) {
        top = margin
        right = margin
        bottom = margin
        left = margin
    }

    init(_ horizontalMargin: Length, _ verticalMargin: Length) {
        top = verticalMargin
        right = horizontalMargin
        bottom = verticalMargin
        left = horizontalMargin
    }

    init(
        top: Length = .zero,
        right: Length = .zero,
        bottom: Length = .zero,
        left: Length = .zero
    ) {
        self.top = top
        self.right = right
        self.bottom = bottom
        self.left = left
    }

    func totalHorizontal() -> Length {
        return .add(left, right)
    }

    func totalVertical() -> Length {
        return .add(top, bottom)
    }
}

public class Fraction {
    private let fraction: UInt

    init(_ fraction: UInt = 1) {
        self.fraction = fraction
    }

    init(_ fractions: [Fraction]) {
        var sum: UInt = 0
        for fraction in fractions {
            sum += fraction.fraction
        }
        self.fraction = sum
    }

    func of(_ fraction: Fraction) -> Float {
        guard fraction.fraction >= self.fraction else {
            fatalError("fraction \(self.fraction) of fraction \(fraction.fraction) does not work")
        }

        return Float(self.fraction) / Float(fraction.fraction)
    }
}

public enum Color {
    case none
    case hexadecimal(String)
    case rgb(UInt8, UInt8, UInt8)

    func getHexadecimal() -> String {
        switch self {
        case .none:
            return ""
        case .hexadecimal(let hexadecimal):
            return hexadecimal
        case .rgb(let r, let g, let b):
            return String(format: "#%02X%02X%02X", r, g, b)
        }
    }
}

public enum Transform {
    case topLeft(Float, Float)
    case topRight(Float, Float)
    case bottomLeft(Float, Float)
    case bottomRight(Float, Float)

    func getPosition(width: Float, height: Float) -> (Float, Float) {
        switch self {
        case .topLeft(let top, let left):
            return (left, top)
        case .topRight(let top, let right):
            return (width - right, top)
        case .bottomLeft(let bottom, let left):
            return (left, height - bottom)
        case .bottomRight(let bottom, let right):
            return (width - right, height - bottom)
        }
    }
}
