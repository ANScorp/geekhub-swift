//
//  OfficesTableViewController.swift
//  iOS_10_URLSession
//
//  Created by Alex on 1/26/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import UIKit

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
        requestOffices(city: "Черкассы") {data, _, _ in
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

    @objc private func dismissPickerPressed() {
        let selectedIndex = pickerView?.selectedRow(inComponent: 0)
        let city = citiesArr[selectedIndex!]
        self.title = "City: \(city)"

        requestOffices(city: city) {data, _, _ in
            if let _ = data {
//                self.perform(#selector(self.reloadTable), with: nil, afterDelay: 1)
                self.reloadTable()
            }
        }
        view.endEditing(true)
    }

    private func requestOffices(city: String, completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: NSError?) -> Void) {
        var link = URLComponents()
        link.scheme = "https"
        link.host = "api.privatbank.ua"
        link.path = "/p24api/pboffice"
        link.query = "json&city=\(city)"

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
            let offices = try JSONDecoder().decode([Offices].self, from: responseData)
            debugPrint(offices)
            officesArr = offices
        } catch {
            print(error)
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
