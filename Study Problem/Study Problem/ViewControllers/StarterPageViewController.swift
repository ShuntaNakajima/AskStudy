//
//  StarterPageViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/09/25.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    let idList = ["Farst", "Second", "Third"]
    override func viewDidLoad() {
        super.viewDidLoad()
         let controller = storyboard!.instantiateViewController(withIdentifier: idList.first!)
        self.setViewControllers([controller], direction: .forward, animated: true, completion: nil)
        self.dataSource = self
        }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PageViewController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = idList.index(of: viewController.restorationIdentifier!)!
        if (index > 0){
            return storyboard!.instantiateViewController(withIdentifier: idList[index-1])
        }else{
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = idList.index(of: viewController.restorationIdentifier!)!
        if (index < idList.count-1) {
            return storyboard!.instantiateViewController(withIdentifier: idList[index+1])
        }else{
            return nil
        }
    }
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return idList.count
//    }
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        return 0
//    }
}
