//
//  FeedbackController.swift
//  appsonair
//
//  Created by vishal-zaveri-us on 22/04/24.
//

import Foundation

import UIKit
import iOSDropDown

class FeedbackController: UIViewController {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var btnNavClose: UIButton!
    
    @IBOutlet weak var lblTicketType: UILabel!
    @IBOutlet weak var dropDownTitle: UILabel!
    @IBOutlet weak var dropDown: DropDown!
    
    @IBOutlet weak var lblDescirption: UILabel!
    @IBOutlet weak var txtDescirption: UITextView!
    @IBOutlet weak var lblDescirptionChars: UILabel!
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var lblAppsOnAir: UILabel!
    
    @IBOutlet weak var clView: UICollectionView!
    
    @IBOutlet weak var clViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnSubmit: UIButton!

    
    //MARK: - Declarations
    var navBarColor: String?
    var navBarTitleTextColor: String?
    var navBarTitle: String?

    var backgroundColor: String?
    
    var lblTicketText: String?

    var dropDownArrowColor: UIColor?
    var arrowSize: CGFloat?
    var arrowColor: UIColor?
    
    var txtDescriptionHintText: String?
    var txtDescriptionCharLimit: Int = 255
    let descriptionHintText = "Add description here.."
    
    var raduis: CGFloat?
    var labelTextColor: String?
    var inputTextColor: String?
    var inputHintTextColor: String?
    
    var txtEmailHintText: String?
    
    var btnSubmitText: String?
    var btnSubmitTextColor: String?
    var btnSubmitBackgroundColor: String?
    
    let ticketType = ["Improvement suggestion", "Bug report"]
    var selectedImage: [UIImage]? = []

    
    //MARK: - View Methods
    override func viewDidLoad() {
       super.viewDidLoad()
            print("selected image: \(selectedImage?.count ?? -1)")
            
            self.view.backgroundColor = UIColor.init(hex: backgroundColor) ?? sColorPrimaryThemeLight
        
            self.navView.addShadow()
            self.navView.backgroundColor = UIColor.init(hex: navBarColor) ?? sColorPrimaryThemeLight
            
            self.navTitle.textColor = UIColor.init(hex: navBarTitleTextColor) ?? sColorTextBlack
            self.navTitle.text = navBarTitle ?? "New Ticket"
        
            self.btnNavClose.setTitle("", for: .normal)
            self.btnNavClose.addTarget(self, action: #selector(self.btnClose(_:)), for: .touchUpInside)
            
        
            self.lblTicketType.textColor = UIColor.init(hex: labelTextColor) ?? sColorTextLightGray
        
            self.dropDown.text = self.ticketType[0]
            self.dropDown.optionArray = ticketType
            self.dropDown?.selectedIndex = 0
            self.dropDown.isSearchEnable = false
            self.dropDown.arrowSize = arrowSize ?? CGFloat(12)
            self.dropDown.arrowColor = arrowColor ?? .black
            self.dropDown.selectedRowColor = UIColor.white
            self.dropDown.textColor = UIColor.init(hex: inputTextColor) ?? sColorTextBlack
            self.dropDown.cornerRadius = 0
            self.dropDown.addCorrnerRaduis(raduis: raduis)
            self.dropDown.handleKeyboard = false
            self.dropDown.checkMarkEnabled = false
            self.dropDown.didSelect{(selectedText , index ,id) in
                self.dropDown.text = self.ticketType[index]
            }
            
            self.lblDescirptionChars.text = "0/\(txtDescriptionCharLimit)"
        
            self.lblDescirption.textColor =  UIColor.init(hex: labelTextColor) ?? sColorTextLightGray
            
            self.txtDescirption.addCorrnerRaduis(raduis: raduis)
            self.txtDescirption.delegate = self
            self.txtDescirption.text = txtDescriptionHintText ?? descriptionHintText
            self.txtDescirption.attributedText = NSAttributedString(string: inputHintTextColor ?? descriptionHintText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: inputHintTextColor) ?? sColorTextLightGray])
            
            // self.txtDescirption.textColor = UIColor.init(hex: txtDescriptionPlaceholderTextColor) ?? sColorTextLightGray
            
            
            self.lblEmail.textColor = UIColor.init(hex: labelTextColor) ?? sColorTextLightGray
            self.txtEmail.keyboardType = .emailAddress
            self.txtEmail.addCorrnerRaduis(raduis: raduis)
            self.txtEmail.textColor = UIColor.init(hex: inputTextColor) ?? sColorTextBlack
            self.txtEmail.attributedPlaceholder = NSAttributedString(string: txtEmailHintText ?? "Enter email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: inputHintTextColor) ?? sColorTextLightGray])
            // self.txtEmail.text = "user@gmail.com"
            // self.txtEmail.isEnabled = false
            // self.txtEmail.isUserInteractionEnabled = false
            
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            
            lblAppsOnAir.text = "We run on AppsOnAir"
            lblAppsOnAir.textColor = sColorTextPrimary
            
            clViewHeight.constant = screenHeight * 0.024
            clView?.collectionViewLayout = layout
        
           // let bundle = Bundle(for: type(of: self))
            let bundle = Bundle(identifier: "org.cocoapods.AppsOnAir")
            clView?.register(UINib(nibName: "imageViewCell", bundle: bundle), forCellWithReuseIdentifier: "imageViewCell")
            
            clView.delegate = self
            clView.dataSource = self
            clView.layoutIfNeeded()
            clView.reloadData()
            
            btnSubmit.backgroundColor = UIColor.init(hex: btnSubmitBackgroundColor) ?? sColorPrimaryThemeDark
            btnSubmit.setTitleColor(UIColor.init(hex: btnSubmitTextColor) ?? sColorTextWhite, for: .normal)
            btnSubmit.setTitle(btnSubmitText ?? "Submit", for: .normal)
            btnSubmit.addShadow()
            btnSubmit.addCorrnerRaduis(color: sColorClear, raduis: raduis)
            btnSubmit.addTarget(self, action: #selector(btnSubmit(_:)), for: .touchUpInside)
            
        
   }
    
    //MARK: - Action Methods
    @objc func btnClose(_ sender: UIButton) {
        
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc func removeSanpshot(_ sender: UIButton) {
        selectedImage?.remove(at: sender.tag)
        clView.reloadData()
    }
    
    @objc func btnSubmit(_ sender: UIButton){
        view.endEditing(true)
        
        self.showToast(message: "submited") {success in
            if success {
                self.dismiss(animated: true, completion: nil)
                let deviceInfo = MyDevice().getInfo()
                print("deviceInfo: \(deviceInfo)")
            }
        }
    
        
    }
}

//MARK: - UICollectionDelegate
extension FeedbackController:  UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedImage?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let inx = indexPath.row
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageViewCell", for: indexPath) as? imageViewCell
        
        cell?.imageView.image = selectedImage?[inx]
        cell?.imageView.layer.masksToBounds = true
        cell?.imageView.contentMode = .scaleAspectFit
        cell?.imageView.clipsToBounds = true

        cell?.bgImageView.layer.masksToBounds = true
        cell?.bgImageView.clipsToBounds = true
        cell?.bgImageView.backgroundColor = sColorWhite
        cell?.bgImageView.addShadows(shadowColor: sColorGray.cgColor, shadowOffset: CGSize(width: 4, height: 2), shadowOpacity: 0.9, shadowRadius: 6, cornerRadiusIs: 6)
        
        
        cell?.btnRemove.tag = inx
        cell?.btnRemove.addTarget(self, action: #selector(removeSanpshot(_:)), for: .touchUpInside)
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((screenWidth) - 16) / 4, height: ((screenWidth) - 16) / 4)
    }
    
    
    
}
//MARK: - UITextViewDelegate
extension FeedbackController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {

        if txtDescirption.textColor == UIColor.lightGray {
            txtDescirption.text = ""
            txtDescirption.textColor = UIColor.init(hex: inputTextColor) ?? sColorTextBlack
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        if txtDescirption.text == "" {

            txtDescirption.text = txtDescriptionHintText ?? descriptionHintText
            txtDescirption.textColor = UIColor.init(hex: inputHintTextColor) ?? sColorTextLightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        lblDescirptionChars.text = "\(numberOfChars)/\(txtDescriptionCharLimit)"
        return numberOfChars < txtDescriptionCharLimit;
    }
}
