import XCTest
@testable import Swordinator

final class SwordinatorTests: XCTestCase {
    
    func testSimpleCoordinator() throws {
        let coordinator = TestCoordinator()
        
        coordinator.handle(step: TestStep.testDetail)
        guard let executedStep = coordinator.executedStep as? TestStep
        else {
            XCTFail("no matching step")
            return
        }
        XCTAssertEqual(executedStep, TestStep.testDetail)
        XCTAssertEqual(coordinator.childCoordinators.count, 1)
        
        coordinator.handle(step: TestStep.testDetail2)
        guard let executedStep2 = coordinator.executedStep as? TestStep
        else {
            XCTFail("no matching step")
            return
        }
        XCTAssertEqual(executedStep2, TestStep.testDetail2)
        XCTAssertEqual(coordinator.childCoordinators.count, 2)
    }
    
    func testCloseSimpleCoordinator() throws {
        let coordinator = TestCoordinator()

        XCTAssertEqual(coordinator.childCoordinators.count, 0)
        coordinator.handle(step: TestStep.testDetail)
        XCTAssertEqual(coordinator.childCoordinators.count, 1)
        coordinator.handle(step: TestStep.closeTestDetail)
        XCTAssertEqual(coordinator.childCoordinators.count, 0)
    }
    
}

extension SwordinatorTests {
    
    enum TestStep: Step {
        case testDetail
        case testDetail2
        
        case closeTestDetail
    }
    
    class TestCoordinator: Coordinator {
        
        var executedStep: Step?
        
        var childCoordinators: [Coordinator] = []
        
        required init() {
            start()
        }
        
        func start() {
            
        }
        
        func handle(step: Step) {
            executedStep = step
            guard let step = step as? TestStep else { return }
            switch step {
            case .testDetail:
                navigateToTestDetail()
            case .testDetail2:
                navigateToTestDetail()
            case .closeTestDetail:
                closeTestDetail()
            }
        }
        
        func navigateToTestDetail() {
            let coordinator = TestDetailCoordinator()
            coordinator.parent = self
            childCoordinators.append(coordinator)
        }
        
        func closeTestDetail() {
            childCoordinators.removeAll { $0 is TestDetailCoordinator }
        }
    }
    
    class TestDetailCoordinator: Coordinator, ParentCoordinated {
        
        var executedStep: Step?
        
        var childCoordinators: [Coordinator] = []
        var parent: Coordinator?
        
        required init() {
            start()
        }
        
        func start() {
            let controller = TestDetailController()
            controller.coordinator = self
        }
        
        func handle(step: Step) {
            executedStep = step
            guard let step = step as? TestStep else { return }
            switch step {
            case .closeTestDetail:
                parent?.handle(step: step)
                //navigateTo(target: TestDetailCoordinator.self)
            default:
                ()
            }
        }
        
    }
    
    class TestDetailController: Coordinated {
        weak var coordinator: Coordinator?
    }
    
}
