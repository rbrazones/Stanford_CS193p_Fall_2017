//
//  ConcentrationThemeSelectorViewController.swift
//  setGame
//
//  Created by Ryan Brazones on 9/30/18.
//  Copyright © 2018 greenred. All rights reserved.
//

import UIKit

class ConcentrationThemeSelectorViewController: UIViewController, UISplitViewControllerDelegate {

    let themeChoices = [
        "Faces"    : "😍🤓🤬😱🤯🤢👿🤗😷😭🤩🙃", // Faces Theme
        "Sports"   : " ⚽️🏀🏈⚾️🎱🏉🏐🎾🏓🏑⛳️🏏", // Sports Theme
        "Flags"    : "🇧🇴🇧🇿🇧🇩🇦🇹🇦🇷🏁🏴🏳️🏳️‍🌈🇨🇿🇨🇾🇨🇬", // Flags Theme
        "Food"     : "🍕🥪🥙🌮🍟🍔🌭🍖🥞🥓🥩🍗", // Food Theme
        "Animals"  : "🦈🐊🐅🐆🦏🐘🦍🦓🐪🐫🦒🐃", // Animals Theme
        "Hands"    : "🤲🤝✊🙏✍️💪🖐🤙👌👎👆🤟"  // Hands Theme
    ]
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil {
                return true // I did the collapse (but I didn't! so it wont get done)
            }
        }
        return false // No I didn't collapse it, so you should do it
    }
    
    @IBAction func theseChooseButtonPress(_ sender: Any) {
        if let cvc  = splitViewDetailConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themeChoices[themeName] {
                cvc.theme = theme
            }
        } else if let cvc = lastSeguedToConcentrationViewCntroller {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themeChoices[themeName] {
                cvc.theme = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            performSegue(withIdentifier: "ChooseTheme", sender: sender)
        }
    }
    
    // MARK: - Navigation

    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    private var lastSeguedToConcentrationViewCntroller: ConcentrationViewController?
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "ChooseTheme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themeChoices[themeName] {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme
                    lastSeguedToConcentrationViewCntroller = cvc
                }
            }
        }
    }


}
