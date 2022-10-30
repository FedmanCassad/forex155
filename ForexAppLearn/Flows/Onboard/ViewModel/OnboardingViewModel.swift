import UIKit

final class OnboardingViewModel {
    private var questionModels: [OnboardQuestionModel] = [
        .init(
            question: R.string.localizable.onboarding1Question(),
            firstOption: R.string.localizable.onboarding1Option1(),
            secondOption: R.string.localizable.onboarding1Option2()
        ),
        .init(
            question: R.string.localizable.onboarding2Question(),
            firstOption: R.string.localizable.onboarding2Option1(),
            secondOption: R.string.localizable.onboarding2Option2()
        ),
        .init(
            question: R.string.localizable.onboarding3Question(),
            firstOption: R.string.localizable.onboarding3Option1(),
            secondOption: R.string.localizable.onboarding3Option2()
        )
    ]
    

    func getModel(at index: Int) -> OnboardQuestionModel {
        questionModels[index]
    }
}

struct OnboardQuestionModel {
    let question: String
    let firstOption: String
    let secondOption: String
}
