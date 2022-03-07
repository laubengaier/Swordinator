import UIKit

public protocol Coordinator: AnyObject
{
    var id: UUID { get }
    var childCoordinators: [Coordinator] { get set }
    func start(step: Step)
    func handle(step: Step)
    func releaseChild<T: Coordinator>(type: T.Type)
}

public extension Coordinator {
    var id: UUID { return UUID() }
    func start(step: Step) {
        handle(step: step)
    }
    func handle(step: Step) {
        print("⚠️ step handler is not implemented for \(String(describing: Self.self))")
    }
    func releaseChild<T: Coordinator>(type: T.Type) {
        childCoordinators.removeAll { $0 is T }
    }
}

public protocol AnyParentCoordinated: AnyObject
{
    associatedtype Parent
    var parent: Parent? { get set }
}

public protocol ParentCoordinated: AnyParentCoordinated
{
    var parent: Coordinator? { get set }
    func releaseFromParent()
}

public extension ParentCoordinated {
    func releaseFromParent() {
        parent?.childCoordinators.removeAll { $0 is Self }
    }
}

public protocol Coordinated: AnyObject
{
    associatedtype Coordinator
    var coordinator: Coordinator? { get set }
}

// MARK: - Ease of use
public protocol TabBarControllerCoordinator: Coordinator
{
    var tabBarController: UITabBarController { get }
}

public protocol NavigationControllerCoordinator: Coordinator
{
    var navigationController: UINavigationController { get }
}

public protocol SplitControllerCoordinator: Coordinator
{
    var splitController: UISplitViewController { get }
}

// MARK: Deeplinks
public protocol Deeplinkable
{
    var rootCoordinator: (Coordinator & Deeplinkable)? { get }
    func handle(deepLink: DeeplinkStep)
}

public extension Deeplinkable {
    func handle(deepLink: DeeplinkStep) {
        if let root = rootCoordinator {
            root.handle(deepLink: deepLink)
        }
    }
}

public protocol Step {}
public protocol DeeplinkStep {}
