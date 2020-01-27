//
//  CurrenciesTableViewController.swift
//  iOS_10_URLSession
//
//  Created by Alex on 1/24/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import UIKit

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

    var currencyExchangeRatesArr = [CurrencyExchangeRate]()
    var spinner: Spinner?

    // MARK: - IBActions

    @IBAction private func reloadCurrencyExchangeRates(_ sender: Any) {
        requestCurrencies { data, _, _ in
            if let _ = data {
                self.reloadTable()
            }
        }
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Currencies"
        requestCurrencies { data, _, _ in
            if let _ = data {
                self.reloadTable()
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Methods

    private func requestCurrencies(
        completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: NSError?) -> Void
    ) {
        var link = URLComponents()
        link.scheme = "https"
        link.host = "api.privatbank.ua"
        link.path = "/p24api/pubinfo"
        link.query = "exchange&json&coursid=11"
//        link.queryItems = [URLQueryItem(name: "exchange", value: nil), URLQueryItem(name: "json", value: nil), URLQueryItem(name: "coursid", value: "11")]

        guard let url = link.url else { return }
        spinner = Spinner()
        spinner?.showSpinner(onView: view)
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let response = response as? HTTPURLResponse else { return }
            if let data = data, (200...299).contains(response.statusCode) {
                self.handleData(responseData: data)
                completionHandler(data, response, error as NSError?)
            }
        }.resume()
    }

    private func handleData(responseData: Data) {
        do {
            let currenciesExchangeRates = try JSONDecoder().decode([CurrencyExchangeRate].self, from: responseData)
            debugPrint(currenciesExchangeRates)
            currencyExchangeRatesArr = currenciesExchangeRates
        } catch {
            print(error)
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
