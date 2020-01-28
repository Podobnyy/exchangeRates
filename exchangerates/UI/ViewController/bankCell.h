//
//  bankCell.h
//  exchangerates
//
//  Created by Сергей Александрович on 15.12.2017.
//  Copyright © 2017 Sergey Podobnyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bankModel.h"

@interface bankCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel * nameBank;
@property(nonatomic, weak) IBOutlet UILabel * baksBuy;
@property(nonatomic, weak) IBOutlet UILabel * baksSell;
@property(nonatomic, weak) IBOutlet UILabel * evroBuy;
@property(nonatomic, weak) IBOutlet UILabel * evroSell;
@property(nonatomic, weak) IBOutlet UILabel * rublBuy;
@property(nonatomic, weak) IBOutlet UILabel * rublSell;

@property(nonatomic, strong) bankModel *model;

@end
