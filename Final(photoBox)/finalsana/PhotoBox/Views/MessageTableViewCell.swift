//Created by Sana Alshahrani on 19/04/1443 AH.

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var advNumber: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var creatAt: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var goTOPost: UIButton!

    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
