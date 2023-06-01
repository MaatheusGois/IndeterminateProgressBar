import UIKit
import IndeterminateProgress

// MARK: - ViewController

final class ViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet private weak var storyboardProgressBar: IndeterminateProgressBar!
    @IBOutlet private weak var programmaticProgressBarContainer: UIView!
    @IBOutlet private weak var progressSlider: UISlider!
    @IBOutlet private weak var indeterminateSwitch: UISwitch!
    @IBOutlet private weak var indeterminateSwitchLabel: UILabel!

    // MARK: - Properties

    private var programmaticProgressBar: IndeterminateProgressBar!
    private var state: IndeterminateProgressBarState = .indeterminate

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        setupProgressSlider()
        setupProgrammaticProgressBar()

        transition(to: state)
    }

    // MARK: - Setup

    private func setupProgressSlider() {
        progressSlider.isContinuous = false
    }

    private func setupProgrammaticProgressBar() {
        programmaticProgressBar = IndeterminateProgressBar()
        programmaticProgressBar.primaryColor = .red
        programmaticProgressBar.secondaryColor = .green

        programmaticProgressBarContainer.addSubview(programmaticProgressBar)

        addConstraint(.top, .bottom, .leading, .trailing)
    }

    private func addConstraint(_ atts: NSLayoutConstraint.Attribute...) {
        guard let programmaticProgressBar = programmaticProgressBar else { return }
        atts.forEach { att in
            NSLayoutConstraint(
                item: programmaticProgressBar,
                attribute: att,
                relatedBy: .equal,
                toItem: programmaticProgressBarContainer,
                attribute: att,
                multiplier: 1.0,
                constant: .zero
            ).isActive = true
        }
    }

    // MARK: - Actions

    @IBAction func progressSliderValueChanged(_ sender: Any) {
        switch state {
            case .determinate:
                transition(to: .determinate(percentage: CGFloat(progressSlider.value)))
            case .indeterminate:
                break
        }
    }

    @IBAction func indeterminateSwitchValueChanged(_ sender: Any) {
        switch indeterminateSwitch.isOn {
            case true:
                transition(to: .indeterminate)
            case false:
                transition(to: .determinate(percentage: CGFloat(progressSlider.value)))
        }
    }

    // MARK: - State

    internal func transition(to state: IndeterminateProgressBarState) {
        self.state = state

        switch state {
            case .determinate:
                progressSlider.isHidden = false
                storyboardProgressBar.transition(to: state)
                programmaticProgressBar.transition(to: state)
                indeterminateSwitchLabel.text = NSLocalizedString("Determinate", comment: "")
            case .indeterminate:
                progressSlider.isHidden = true
                storyboardProgressBar.transition(to: state)
                programmaticProgressBar.transition(to: state)
                indeterminateSwitchLabel.text = NSLocalizedString("Indeterminate", comment: "")
        }
    }
}
