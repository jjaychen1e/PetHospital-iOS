//
//  DiseaseListCell.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/30.
//

import UIKit

class DiseaseListCell: UITableViewCell {

    @IBOutlet weak var diseaseNameLabel: UILabel!
    
    @IBOutlet weak var subdiseasesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
