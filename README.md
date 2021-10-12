
<img src ="https://user-images.githubusercontent.com/17570451/136767032-c2da8d49-b450-4cdc-8b1f-80e282e3c46e.png" style="max-width: 100%;"/>

Swordinator is a minimal, lightweight and easy customizable navigation framework for iOS applications.

## Requirements
iOS 14.0+, Swift 5.0+

## Installation

### Swift Package Manager

```
dependencies: [
    .package(url: "https://github.com/laubengaier/Swordinator.git", .upToNextMajor(from: "1.0.0"))
]
```

## Use Swordinator

These steps should provide a simple way of getting started. If something is not clear please take a look at the demo provided or create an issue.

##### Quicknote:
The simplest way is to go forward with implementing `Step` and `handle(step: Step)` which simplifies the coordination but if you want even more control or don't like steps there is a delegate example in the demo (ProfileCoordinator). 

#### 1. Define Steps

Create a new class called `AppStep` or anything you like that will define the steps your application can do.

``` Swift
enum AppStep: Step 
{
    // task list
    case taskList
    
    // task detail
    case taskDetail
    case taskDetailCompleted
    
    // auth
    case auth
    case authCompleted
    case logout
}
```

#### 2. Setup AppCoordinator

Create a new class called `AppCoordinator` or similar that defines the entry point to your app.

``` Swift
class AppCoordinator: Coordinator 
{
    let window: UIWindow
    var rootCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    let services: AppServices
    
    init(window: UIWindow, services: AppServices) {
        self.window = window
        self.services = services
        start()
    }
    
    func start() {
        if services.isAuthenticated {
            self.showTaskList()
        } else {
            self.showLogin()
        }
    }
    
    func handle(step: Step) {
        guard let step = step as? AppStep else { return }
        switch step {
        case .auth:
            showLogin()
        case .taskList:
            showTaskList()
        default:
            return
        }
    }
}

extension AppCoordinator 
{
    private func showLogin() {
        // show login
    }
    
    private func showTaskList() {
        let nvc = UINavigationController()
        let coordinator = TaskListCoordinator(navigationController: nvc, services: services)
        coordinator.parent = self
        rootCoordinator = coordinator
        window.rootViewController = nvc
    }
}
```

#### 3. AppDelegate / Scene
``` Swift
class SceneDelegate: UIResponder, UIWindowSceneDelegate 
{

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    let appServices = AppServices()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            appCoordinator = AppCoordinator(window: window, services: appServices)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    // ...
}
```



## Demo Application

A demo is provided to show the core mechanics and how to apply the coordinator pattern.

| Login         | Dashboard     | Profile       |
| ------------- | ------------- | ------------- |
| <img src="https://user-images.githubusercontent.com/17570451/136762041-b12a5a5f-895c-4662-a9ca-57867f7e89f3.png" width=200/> | <img src="https://user-images.githubusercontent.com/17570451/136762029-8d63e976-a7c1-41a1-bbf6-f433ffcb971d.png" width=200/> | <img src="https://user-images.githubusercontent.com/17570451/136762043-6b418009-7c27-462d-99b1-5235a165736b.png" width=200/> |

## Pattern

### Demo Flow

This is an illustration of how the pattern is used in the demo application

![SwordinatorExampleFlow](https://user-images.githubusercontent.com/17570451/136760980-5ba33998-ce5a-479a-90e4-b07d52b48309.png)
