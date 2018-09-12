//
//  ConcentrationThemeViewController.swift
//  Concentration
//
//  Created by Ryan Brazones on 9/11/18.
//  Copyright © 2018 Michel Deiman. All rights reserved.
//

import UIKit

class ConcentrationThemeViewController: UIViewController, UISplitViewControllerDelegate {

    let themes = [
        "Sports" : "⚽️🏀🏈⚾️🎱🏉🏐🎾🏓🏸🥅🏒🥊🥌",
        "Animals" : "🐨🐯🦁🐮🐼🐻🦊🐰🐹🐭🐱🐶🐗🐺",
        "Faces" : "😍🙂😇😌😘😋🤪😎🤩😏🤓😭😢😩"
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
    
    @IBAction func changeTheme(_ sender: Any) {
        
        if let cvc  = splitViewDetailConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
        } else if let cvc = lastSeguedToConcentrationViewCntroller {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    // MARK: - Navigation

    private var lastSeguedToConcentrationViewCntroller: ConcentrationViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme
                    lastSeguedToConcentrationViewCntroller = cvc
                }
            }
        }
    }
    

}
