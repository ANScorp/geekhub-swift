//
//  CurrenciesTableViewController.swift
//  iOS_11_Moya
//
//  Created by Alex on 1/24/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import UIKit
import Moya
import Kingfisher

struct CurrencyExchangeRate: Decodable {
    let currency: String
    let baseCurrency: String
    let buy: Double
    let sell: Double

    enum CodingKeys: String, CodingKey {
        case currency = "ccy"
        case baseCurrency = "base_ccy"
        case buy
        case sell = "sale"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.currency = try container.decode(String.self, forKey: .currency)
        self.baseCurrency = try container.decode(String.self, forKey: .baseCurrency)
        self.buy = try Double(container.decode(String.self, forKey: .buy))!
        self.sell = try Double(container.decode(String.self, forKey: .sell))!
    }
}

class CurrenciesTableViewController: UITableViewController {

    // MARK: - Variables

    let provider = MoyaProvider<Privat24API>()
    var currencyExchangeRatesArr = [CurrencyExchangeRate]()
    var spinner: Spinner?

    // MARK: - IBActions

    @IBAction private func reloadCurrencyExchangeRates(_ sender: Any) {
        requestCurrencies(coursid: 11)
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Currencies"

        requestCurrencies(coursid: 11)
    }

    // MARK: - Methods

    private func requestCurrencies(
        coursid: Int,
        completionHandler: @escaping (_ response: Response?, _ error: MoyaError?) -> Void = { _, _ in }
    ) {
        spinner = Spinner()
        spinner?.showSpinner(onView: view)
        provider.request(.pubinfo(coursid: coursid)) { result in
            do {
                let response = try result
                    .get()
                    .filter(statusCode: 200)
                let currenciesExchangeRates = try response.map([CurrencyExchangeRate].self)
                debugPrint(currenciesExchangeRates)
                self.currencyExchangeRatesArr = currenciesExchangeRates
                self.reloadTable()
                completionHandler(response, nil)
            } catch {
                print(error)
                completionHandler(nil, error as? MoyaError)
            }
        }
    }

    @objc func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.spinner?.removeSpinner()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currencyExchangeRatesArr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyExchangeRateCell", for: indexPath)
        let url = URL(string: "https://privatbank.ua/sites/pb/img/apps/sms@2x.png")
        let title = """
            <span style="font-size: 18px; font-weight: bold;">
                <font color="green">
                    \(currencyExchangeRatesArr[indexPath.row].currency)
                </font>
                <font color="black">
                    \(currencyExchangeRatesArr[indexPath.row].baseCurrency)
                </font>
            </span>
        """
        let htmlDataTitle = NSString(string: title).data(using: String.Encoding.utf8.rawValue)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        let detail = """
            <span style="font-size: 20px; font-weight: bold;">
                Buy: \(currencyExchangeRatesArr[indexPath.row].buy)<br/>
                Sail: \(currencyExchangeRatesArr[indexPath.row].sell)
            </span>
        """
        let htmlDataDetail = NSString(string: detail).data(using: String.Encoding.utf8.rawValue)

        cell.imageView?.kf.setImage(with: url)
        cell.textLabel?.attributedText = try? NSAttributedString(
            data: htmlDataTitle!,
            options: options,
            documentAttributes: nil
        )
        cell.detailTextLabel?.attributedText = try? NSAttributedString(
            data: htmlDataDetail!,
            options: options,
            documentAttributes: nil
        )

        return cell
    }
}

// MARK: - Spinner

class Spinner: UIViewController {
    var vSpinner: UIView?

    init() {
        self.vSpinner = UIView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func showSpinner(onView: UIView) {
        let spinnerView = UIView(frame: onView.bounds)
        spinnerView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.startAnimating()
        activityIndicator.center = spinnerView.center

        DispatchQueue.main.async {
            spinnerView.addSubview(activityIndicator)
            onView.addSubview(spinnerView)
        }

        vSpinner = spinnerView
    }

    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
}
