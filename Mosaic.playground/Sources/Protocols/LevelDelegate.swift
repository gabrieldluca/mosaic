import UIKit

protocol LevelDelegate: AnyObject {
    func didFit(piece: MovableView)
    func levelSetup()
    func levelTeardown()
}
