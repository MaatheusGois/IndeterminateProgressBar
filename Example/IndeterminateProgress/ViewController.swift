import UIKit
import IndeterminateProgress

//MARK: - ViewController
internal class ViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet private weak var storyboardProgressBar: IndeterminateProgressBar!
    @IBOutlet private weak var programmaticProgressBarContainer: UIView!
    @IBOutlet private weak var progressSlider: UISlider!
    @IBOutlet private weak var indeterminateSwitch: UISwitch!
    @IBOutlet private weak var indeterminateSwitchLabel: UILabel!

    //MARK: Properties
    private var programmaticProgressBar: IndeterminateProgressBar!
    private var state: IndeterminateProgressBarState = .indeterminate

    //MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()


        setupProgressSlider()
        setupProgrammaticProgressBar()
        
        transition(to: state)

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addAnotherVC))
    }
    
    //MARK: Setup
    private func setupProgressSlider() {
        progressSlider.isContinuous = false
    }

    private func setupProgrammaticProgressBar() {
        programmaticProgressBar = IndeterminateProgressBar()
        programmaticProgressBar.primaryColor = .blue
        programmaticProgressBar.secondaryColor = .lightGray
        
        programmaticProgressBarContainer.addSubview(programmaticProgressBar)
        
        NSLayoutConstraint(item: programmaticProgressBar, attribute: .top, relatedBy: .equal, toItem: programmaticProgressBarContainer, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: programmaticProgressBar, attribute: .bottom, relatedBy: .equal, toItem: programmaticProgressBarContainer, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: programmaticProgressBar, attribute: .leading, relatedBy: .equal, toItem: programmaticProgressBarContainer, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: programmaticProgressBar, attribute: .trailing, relatedBy: .equal, toItem: programmaticProgressBarContainer, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
    }
    
    //MARK: Actions
    @IBAction func progressSliderValueChanged(_ sender: Any) {
        switch state {
            case .determinate(_):
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
    
    //MARK: State
    internal func transition(to state: IndeterminateProgressBarState) {
        self.state = state
        
        switch state {
            case .determinate(_):
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

    @IBAction func buttonTouchUpInside(_ sender: Any) {
        let emptyVC = UIViewController()
        emptyVC.view.backgroundColor = .white
        navigationController?.pushViewController(emptyVC, animated: true)
    }

    @IBAction func addAnotherVC() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ViewController")
        navigationController?.pushViewController(vc, animated: true)
    }

    private func changeColor() {
        storyboardProgressBar.tintColor = .red
    }
}
