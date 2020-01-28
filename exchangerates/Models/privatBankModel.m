//
//  privatBankModel.m
//  exchangerates
//
//  Created by Сергей Александрович on 19.12.2017.
//  Copyright © 2017 Sergey Podobnyy. All rights reserved.
//

#import "privatBankModel.h"
#import "bankModel.h"

@implementation privatBankModel

-(instancetype)initWhitDictionary:(NSDictionary *)data{
    self = [super init];
    if (self) {
        _ccy = data[@"ccy"];
        _base_ccy = data[@"base_ccy"];
        _buy = data[@"buy"];
        _sale = data[@"sale"];
    }
    return self;
}

+(NSArray<privatBankModel *> *)pbFromArray:(NSArray *)data{
    NSMutableArray *result = [NSMutableArray new];
    
    for (NSDictionary *modelData in data) {
        privatBankModel *pbBank = [[privatBankModel alloc] initWhitDictionary:modelData];
        [result addObject:pbBank];
        }
    return result;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"ccy - %@, buy - %@ sale - %@ ", _ccy, _buy, _sale];
}


@end
