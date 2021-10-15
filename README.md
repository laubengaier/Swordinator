
![Swordinator: Minimal Coordinator Pattern for Swift](https://user-images.githubusercontent.com/17570451/136767032-c2da8d49-b450-4cdc-8b1f-80e282e3c46e.png)

Swordinator is a minimal, lightweight and easy customizable navigation framework for iOS applications.

[![Tests](https://github.com/laubengaier/Swordinator/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/laubengaier/Swordinator/actions/workflows/ci.yml)

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
The simplest way is to go forward with implementing `Step` and using `handle(step: Step)` which simplifies the coordination but if you want even more control or don't like steps there is a delegate example in the demo (NoStepCoordinator). 

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

## Deeplinks

If you want to support deeplinks in your application you just need to let your Coordinator classes adapt to `Deeplinkable` as following:

``` Swift
class AppCoordinator: Coordinator, Deeplinkable {

    //...
    var rootCoordinator: (Coordinator & Deeplinkable)?
    
    //...
    
    func handle(deepLink: DeeplinkStep) {
        if let root = rootCoordinator {
            root.handle(deepLink: deepLink)
        }
    }
}
```

This comes in pretty handy when dealing with Universal Links or Push Notifications. The `rootCoordinator` should be seen as the current active Coordinator so if there is a event then it can be forwarded to the top most active coordinator or handled anywhere in between.

In the Demo application there is a `taskDetail` deeplink that will be forwarded to either the TaskList or Profile and handled there. 

Illustrated here [Demo Flow](#pattern)

## Important Notice

### Memory Leaks

To avoid memory leaks you should pay attention to releasing the Coordinators from `childCoordinators` when they are not used anymore.

For Example:
``` Swift
func handle(step: Step) {
    guard let step = step as? AppStep else { return }
    switch step {
    case .taskDetailCompleted:
        childCoordinators.removeAll { $0 is TaskDetailCoordinator }
    }
}
```

## Demo Application

A demo is provided to show the core mechanics and how to apply the coordinator pattern.

| Login         | Dashboard     | Profile       |
| ------------- | ------------- | ------------- |
| <img src="https://user-images.githubusercontent.com/17570451/136762041-b12a5a5f-895c-4662-a9ca-57867f7e89f3.png" width=200/> | <img src="https://user-images.githubusercontent.com/17570451/136762029-8d63e976-a7c1-41a1-bbf6-f433ffcb971d.png" width=200/> | <img src="https://user-images.githubusercontent.com/17570451/136762043-6b418009-7c27-462d-99b1-5235a165736b.png" width=200/> |

### Deeplinks

Run the following commands in your terminal to test deeplinks with the simulator

``` bash
# lazy load and show a task
xcrun simctl openurl booted swordinator://tasks/1
# taskList, switch tab
xcrun simctl openurl booted swordinator://tasks
# profile, switch tab
xcrun simctl openurl booted swordinator://profile
# profile settings, switch tab to profile and open settings
xcrun simctl openurl booted swordinator://settings
# logout
xcrun simctl openurl booted swordinator://logout
```

## Pattern

### Demo Flow

This is an illustration of how the pattern is used in the demo application

![SwordinatorExampleFlow](https://user-images.githubusercontent.com/17570451/136760980-5ba33998-ce5a-479a-90e4-b07d52b48309.png)

## Mentions

**RxFlow**
This project is inspired by [RxFlow](https://github.com/RxSwiftCommunity/RxFlow) which is a great way to use Coordinators in a reactive manner but imho it's not always clear what is happening behind the scenes so this project should provide a more simplified way to integrate and gain more control. 

## License
This code is distributed under the MIT license. See the `LICENSE` file for more info.
