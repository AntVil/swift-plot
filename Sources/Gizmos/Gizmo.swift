protocol Gizmo {
    func renderInto<R: Renderer>(renderer: inout R)
}
