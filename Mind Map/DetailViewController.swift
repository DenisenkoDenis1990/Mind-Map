//
//  DetailViewController.swift
//  Mind Map
//
//  Created by Denys Denysenko on 07.11.2021.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var mainIdea: UILabel!
    var mainIdeaLabelText = ""
    var subIdeas = [UILabel]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainIdea.text = mainIdeaLabelText
        mainIdea.translatesAutoresizingMaskIntoConstraints = false
        let tapGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(mainIdeaTapped))
        
        mainIdea.addGestureRecognizer(tapGestureRecognizer)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction))
        view.addGestureRecognizer((doubleTap))
        
        let longPressTap = UILongPressGestureRecognizer (target: self, action: #selector(longPressAction))
        view.addGestureRecognizer(longPressTap)
        
        
        
    }
    

    
   
    @objc func mainIdeaTapped (gestureRecognizer: UIPanGestureRecognizer) {
        gestureRecognizer.maximumNumberOfTouches = 1
        let location = gestureRecognizer.location(in: view)
        
        if gestureRecognizer.state == .ended {
            
            let subIdea = UILabel()
        subIdea.translatesAutoresizingMaskIntoConstraints = false
            subIdea.textAlignment = .center
            subIdea.font = UIFont.systemFont(ofSize: 22)
            subIdea.text = ""
            view.addSubview(subIdea)
            
            
            let ac = UIAlertController(title: "Add new idea", message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Add", style: .default, handler: {
                [weak self, weak ac] action in
                subIdea.text = ac!.textFields![0].text!
                self!.drawLine(from: self!.mainIdea.center, to: location)
            }))
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(ac, animated: true)
     
            
            
            NSLayoutConstraint.activate([
                subIdea.centerXAnchor.constraint(equalTo: mainIdea.centerXAnchor, constant: location.x - mainIdea.center.x),
                subIdea.centerYAnchor.constraint(equalTo: mainIdea.centerYAnchor, constant: location.y - mainIdea.center.y)
            ])
            
            subIdeas.append(subIdea)
        }
        
      
    }
        
        
    
    @objc func doubleTapAction (gestureRecognizer: UITapGestureRecognizer) {
        gestureRecognizer.numberOfTapsRequired = 2
        let location = gestureRecognizer.location(in: view)
        if gestureRecognizer.state == .ended {
            for item in subIdeas {
                if item.frame.contains(location) {
                    editIdeaText(item)
                }
            }
            if mainIdea.frame.contains(location) {
                editIdeaText(mainIdea)
            }
        }
    }
    
    @objc func longPressAction (gestureRecognizer: UILongPressGestureRecognizer) {
        let location = gestureRecognizer.location(in: view)
        if gestureRecognizer.state == .ended {
            for item in subIdeas {
                if item.frame.contains(location) {
                    
                    createMenu(item)
                }
            }
            if mainIdea.frame.contains(location) {
                createMenu(mainIdea)
            }
        }
    }
    
    
    func drawLine (from start: CGPoint, to end: CGPoint ) {
        let path = UIBezierPath()
       path.lineWidth = 3
       path.move(to: start)
       path.addLine(to: end)
       path.stroke()
       path.fill()
       let shapeLayer = CAShapeLayer()
           shapeLayer.path = path.cgPath
       shapeLayer.strokeColor = UIColor.black.cgColor
           shapeLayer.lineWidth = 1.0
       shapeLayer.zPosition = -10
           view.layer.addSublayer(shapeLayer)
    }
    
    func editIdeaText (_ label: UILabel) {
        
        let ac = UIAlertController(title: "Edit idea", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Edit", style: .default, handler: {
            [weak self, weak ac] action in
            ac?.textFields?[0].placeholder = label.text
            label.text = ac?.textFields?[0].text
            
        }))
        present(ac, animated: true)
    }
    
    func createMenu (_ label: UILabel){
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Edit", style: .default, handler: {
            action in self.editIdeaText(label)
        }))
        ac.addAction(UIAlertAction(title: "Delete", style: .default, handler: {
            action in
            
            for item in self.view.layer.sublayers! {
                
                    if let i =  item as? CAShapeLayer {
                        if i.contains(label.center){
                            i.removeAllAnimations()
                    i.removeFromSuperlayer()
                        }
                    }
                
                
            }
            label.removeFromSuperview()
            
            
        }))
        ac.popoverPresentationController?.sourceView = view
        ac.popoverPresentationController?.sourceRect = label.frame
        present(ac, animated: true)
       
        
        
    }
    
    
    
    
}



