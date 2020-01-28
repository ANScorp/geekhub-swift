//
//  OfficesTableViewController.swift
//  iOS_11_Moya
//
//  Created by Alex on 1/26/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import UIKit
import Moya
import Kingfisher

struct Offices: Decodable {
    let id: Int
    let country: String
    let state: String
    let city: String
    let index: String
    let address: String
    let phone: String
    let email: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case country
        case state
        case city
        case index
        case address
        case phone
        case email
        case name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try Int(container.decode(String.self, forKey: .id))!
        self.country = try container.decode(String.self, forKey: .country)
        self.state = try container.decode(String.self, forKey: .state)
        self.city = try container.decode(String.self, forKey: .city)
        self.index = try container.decode(String.self, forKey: .index)
        self.address = try container.decode(String.self, forKey: .address)
        self.phone = try container.decode(String.self, forKey: .phone)
        self.email = try container.decode(String.self, forKey: .email)
        self.name = try container.decode(String.self, forKey: .name)
    }
}

class OfficesTableViewController: UITableViewController {

    // MARK: - Variables

    let provider = MoyaProvider<Privat24API>()

    let citiesArr = [
        "Винница",
        "Днепр",
        "Донецк",
        "Житомир",
        "Запорожье",
        "Ивано-Франковск",
        "Киев",
        "Кропивницкий",
        "Луганск",
        "Луцк",
        "Львов",
        "Николаев",
        "Одесса",
        "Полтава",
        "Ровно",
        "Сумы",
        "Тернополь",
        "Ужгород",
        "Харьков",
        "Херсон",
        "Хмельницкий",
        "Черкассы",
        "Чернигов",
        "Черновцы"
    ]
    var officesArr = [Offices]()
    var pickerView: UIPickerView?
    var spinner: Spinner?

    // MARK: - IBActions

    @IBAction private func selectCity(_ sender: Any) {
        pickerView = UIPickerView()
        pickerView?.dataSource = self
        pickerView?.delegate = self

        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true

        let doneButton = UIBarButtonItem(
            title: "Done",
            style: UIBarButtonItem.Style.done,
            target: self,
            action: #selector(self.dismissPickerPressed)
        )
        let spaceButton = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace,
            target: nil,
            action: nil
        )
        toolBar.setItems([doneButton, spaceButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()

        let tempTextField = UITextField()
        tempTextField.inputAccessoryView = toolBar
        tempTextField.inputView = pickerView
        self.view.addSubview(tempTextField)
        tempTextField.becomeFirstResponder()
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "City: Черкассы"

        requestOffices(city: "Черкассы")
    }

    // MARK: - Methods

    @objc private func dismissPickerPressed() {
        let selectedIndex = pickerView?.selectedRow(inComponent: 0)
        let city = citiesArr[selectedIndex!]
        self.title = "City: \(city)"

        requestOffices(city: city)
        view.endEditing(true)
    }

    private func requestOffices(
        city: String,
        completionHandler: @escaping (_ response: Response?, _ error: MoyaError?) -> Void = { _, _ in }
    ) {
        spinner = Spinner()
        spinner?.showSpinner(onView: view)
        provider.request(.pboffice(city: city)) { result in
            do {
                let response = try result
                    .get()
                    .filter(statusCode: 200)
                let offices = try response.map([Offices].self)
                debugPrint(offices)
                self.officesArr = offices
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
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            self.spinner?.removeSpinner()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        officesArr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OfficeCell", for: indexPath)
        let url = URL(string: "https://privatbank.ua/sites/pb/img/apps/sms@2x.png")
        let title = """
            <span style="color:green; font-size: 22px; font-weight: bold;">
                Name: \(officesArr[indexPath.row].name)
                </br>
                City: <font color="black">\(officesArr[indexPath.row].city)</font>
                <br/>
                State: <font color="black">\(officesArr[indexPath.row].state)</font>
            </span>
            </br>
        """
        let htmlDataTitle = NSString(string: title).data(using: String.Encoding.utf16.rawValue)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        let detail = """
            <span style="font-size: 20px;">
                <!---<span style="font-weight:bold">Name:</span> \(officesArr[indexPath.row].name)</br>-->
                <span style="font-weight:bold">POST:</span> \(officesArr[indexPath.row].index)<br/>
                <span style="font-weight:bold">Address:</span> \(officesArr[indexPath.row].address)<br/>
                <span style="font-weight:bold">Phone:</span> \(officesArr[indexPath.row].phone)<br/>
                <span style="font-weight:bold">E-mail:</span> \(officesArr[indexPath.row].email)
            </span>
        """
        let htmlDataDetail = NSString(string: detail).data(using: String.Encoding.utf16.rawValue)

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

// MARK: - UIPickerViewDataSource

extension OfficesTableViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        citiesArr.count
    }
}

// MARK: - UIPickerViewDelegate

extension OfficesTableViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        citiesArr[row]
    }
}
