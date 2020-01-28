//
//  bankCell.m
//  exchangerates
//
//  Created by Сергей Александрович on 15.12.2017.
//  Copyright © 2017 Sergey Podobnyy. All rights reserved.
//

#import "bankCell.h"

@implementation bankCell

-(void)setModel:(bankModel *)model{
    _model = model;

    _nameBank.text = model.nameBank;
    _baksBuy.text = [NSString stringWithFormat:@"%.3f", model.baksBuy];
    _baksSell.text = [NSString stringWithFormat:@"%.3f", model.baksSell];;
    _evroBuy.text = [NSString stringWithFormat:@"%.3f", model.evroBuy];
    _evroSell.text = [NSString stringWithFormat:@"%.3f", model.evroSell];
    _rublBuy.text = [NSString stringWithFormat:@"%.3f", model.rublBuy];
    _rublSell.text = [NSString stringWithFormat:@"%.3f", model.rublSell];
}

@end
