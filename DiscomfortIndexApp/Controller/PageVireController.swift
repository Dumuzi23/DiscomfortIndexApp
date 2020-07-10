//
//  PageVireController.swift
//  DiscomfortIndexApp
//
//  Created by Tatsuya Amida on 2020/05/01.
//  Copyright © 2020 T.A. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

    var controllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initPageViewController()
    }

    func initPageViewController() {
        let weatherVC = storyboard!.instantiateViewController(withIdentifier: "WeatherView")
        let forecastVC = storyboard!.instantiateViewController(withIdentifier: "ForecastView")

        self.controllers = [weatherVC, forecastVC]

        setViewControllers([self.controllers[0]], direction: .forward, animated: true, completion: nil)

        self.dataSource = self
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.controllers.count
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = self.controllers.firstIndex(of: viewController), index < self.controllers.count - 1 {
            return self.controllers[index + 1]
        } else {
            return nil
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = self.controllers.firstIndex(of: viewController),
            index > 0 {
            return self.controllers[index - 1]
        } else {
            return nil
        }
    }

}
