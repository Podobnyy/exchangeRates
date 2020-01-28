//
//  bankModel.h
//  exchangerates
//
//  Created by Сергей Александрович on 15.12.2017.
//  Copyright © 2017 Sergey Podobnyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface bankModel : NSObject

@property(nonatomic, strong) NSString *nameBank;
@property(nonatomic, assign) CGFloat baksBuy;
@property(nonatomic, assign) CGFloat baksSell;
@property(nonatomic, assign) CGFloat evroBuy;
@property(nonatomic, assign) CGFloat evroSell;
@property(nonatomic, assign) CGFloat rublBuy;
@property(nonatomic, assign) CGFloat rublSell;

+(NSArray *)bankArray;

@end
