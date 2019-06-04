//
//  ViewController.swift
//  WeatherApp
//
//  Created by Felix Changoo on 6/3/19.
//  Copyright © 2019 Felix Changoo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

struct Identifiers {
    static let mainCellIdentifier = "cell"
    static let detailVC = "detail"
    static let mainStoryBoard = "Main"
}

final class MainVC: UIViewController, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    private var bag = DisposeBag()
    private var mainPresenter: MainPresenter?
    private var disposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<WeatherSection>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        initDataSource()
        initTableView()
        initCellTaps()
    }
    
    func goToDetailPage(for weatherResult: WeatherResult) {
        guard let vc = UIStoryboard.init(name: Identifiers.mainStoryBoard, bundle: Bundle.main).instantiateViewController(withIdentifier: Identifiers.detailVC) as? DetailVC else {
            return
        }
        vc.setWeatherResult(weatherResult: weatherResult)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//Reactive table view
extension MainVC {
    func initDataSource() {
        dataSource = RxTableViewSectionedReloadDataSource<WeatherSection>(
            configureCell: { dataSource, tableView, indexPath, weatherResult in
                guard let cell = tableView.dequeueReusableCell(withIdentifier:
                    Identifiers.mainCellIdentifier, for: indexPath) as? WeatherCell
                    else { return UITableViewCell() }
                cell.configure(with: weatherResult)
                return cell
        })
    }
    
    func initTableView() {
        guard let dataSource = dataSource else { return }
        
        let service = MainService()
        let cities = ["New York", "Tokyo", "London"]
        
        mainPresenter = MainPresenter(cities: cities, service: service)
        
        mainPresenter?.loadCities()?
                        .asObservable()
                        .bind(to: tableView.rx.items(dataSource: dataSource))
                        .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
                    .disposed(by: bag)
    }
    
    func initCellTaps() {
        guard let dataSource = dataSource else { return }
        
        tableView.rx.itemSelected.map { indexPath in
            return (indexPath, dataSource[indexPath])
            }.subscribe(onNext: { [weak self] indexPath, result in
                guard let strongSelf = self else { return }
                
                strongSelf.goToDetailPage(for: result)
            }).disposed(by: bag)
    }
}

extension MainVC {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

