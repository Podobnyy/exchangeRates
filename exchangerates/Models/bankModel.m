//
//  bankModel.m
//  exchangerates
//
//  Created by Сергей Александрович on 15.12.2017.
//  Copyright © 2017 Sergey Podobnyy. All rights reserved.
//

#import "bankModel.h"
#import "privatBankModel.h"
#import "RootController.h"

@implementation bankModel

+(NSArray *)bankArray{
    
    NSMutableArray *result = [NSMutableArray new];
    /*
    bankModel *model = [bankModel new];
    
    model.nameBank = @"bank";
    model.baksBuy = 21;
    model.baksSell = 31.123131;
    model.evroBuy = 11;
    model.evroSell = 12.455;
    model.rublBuy = 23;
    model.rublSell = 11.235;
    
    [result addObject:model];

    
    bankModel *model2 = [bankModel new];
    
    model2.nameBank = @"bank2";
    model2.baksBuy = 21;
    model2.baksSell = 31.123131;
    model2.evroBuy = 11;
    model2.evroSell = 12.455;
    model2.rublBuy = 23;
    model2.rublSell = 11.235;
    
    [result addObject:model2];
    */
    return result;
}

@end
