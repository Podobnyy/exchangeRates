//
//  banksModel.h
//  exchangerates
//
//  Created by Сергей Александрович on 10.01.2018.
//  Copyright © 2018 Sergey Podobnyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface banksModel : NSObject


@property(nonatomic, readonly) NSString *title;

@property(nonatomic, readonly) NSString *buyEUR;
@property(nonatomic, readonly) NSString *saleEUR;
@property(nonatomic, readonly) NSString *buyUSD;
@property(nonatomic, readonly) NSString *saleUSD;
@property(nonatomic, readonly) NSString *buyRUB;
@property(nonatomic, readonly) NSString *saleRUB;

+(NSArray <banksModel *>*)banksModelFromArray:(NSArray*)data;

-(instancetype)initWhitDictionary:(NSDictionary *)data;



@end
