//
//  privatBankModel.h
//  exchangerates
//
//  Created by Сергей Александрович on 19.12.2017.
//  Copyright © 2017 Sergey Podobnyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bankModel.h"

@interface privatBankModel : NSObject

@property(nonatomic, readonly) NSString *ccy;
@property(nonatomic, readonly) NSString *base_ccy;
@property(nonatomic, readonly) NSString *buy;
@property(nonatomic, readonly) NSString *sale;

+(NSArray <privatBankModel *>*)pbFromArray:(NSArray*)data;

-(instancetype)initWhitDictionary:(NSDictionary *)data;


@end
