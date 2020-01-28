//
//  banksModel.m
//  exchangerates
//
//  Created by Сергей Александрович on 10.01.2018.
//  Copyright © 2018 Sergey Podobnyy. All rights reserved.
//

#import "banksModel.h"

@implementation banksModel

-(instancetype)initWhitDictionary:(NSDictionary *)data{
    self = [super init];
    if (self) {
        
        _title = data[@"title"];
        
        NSDictionary *dict = data[@"currencies"];
        NSDictionary *eur = dict[@"EUR"];
        NSDictionary *usd = dict[@"USD"];
        NSDictionary *rub = dict[@"RUB"];
        
        _buyEUR = eur[@"bid"];
        _saleEUR = eur[@"ask"];
        _buyUSD = usd[@"bid"];
        _saleUSD = usd[@"ask"];
        _buyRUB = rub[@"bid"];
        _saleRUB = rub[@"ask"];
    }
    return self;
}

+(NSArray<banksModel *> *)banksModelFromArray:(NSDictionary *)data{
    NSArray *org = data[@"organizations"];
    NSMutableArray *result = [NSMutableArray new];
    
    for (NSDictionary *modelData in org) {
        banksModel *banksMod = [[banksModel alloc] initWhitDictionary:modelData];
        [result addObject:banksMod];
    }
    return result;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"title -%@, buyEUR -%@, saleEUR-%@, buyUSD-%@, saleUSD-%@, buyRUB-%@, saleRUB-%@", _title, _buyEUR, _saleEUR, _buyUSD, _saleUSD, _buyRUB, _saleRUB ];//@"ccy - %@, buy - %@ sale - %@ ", _ccy, _buy, _sale];
}



@end
