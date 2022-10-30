import Amplitude
import UIKit

final class ForexAppCoordinator {
    let window: UIWindow?
    let rootNavigationController: UINavigationController =  {
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        return navigationController
    }()
    
    let onboardingController = OnboardController()
    let preFinalController = PreFinalOnboardingController()
    let registrationController = RegistrationViewController()
    let mainContainer = MainTabBar()
    
    init(window: UIWindow?) {
        self.window = window
        onboardingController.nextStepHandler = { [weak self] in
            guard let self = self else { return }
            self.rootNavigationController.pushViewController(self.preFinalController, animated: true)
        }

        preFinalController.nextStepHandler = { [weak self] in
            guard let self = self else { return }
            self.rootNavigationController.pushViewController(self.registrationController, animated: true)
        }

        registrationController.finishHandler = { [weak self] in
            guard
                let self = self,
                let window = self.window
            else { return }
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
            window.rootViewController = self.mainContainer
        }
    }
    
    func start() {
        let rootController = LoadingScreen()
        rootController.finishHandler = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.rootNavigationController.viewControllers = [UserLocalSettings.didShowOnboarding ? self.mainContainer : self.onboardingController]
                self.window?.rootViewController = self.rootNavigationController
            }
        }
        rootNavigationController.viewControllers = [rootController]
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
    }
}
