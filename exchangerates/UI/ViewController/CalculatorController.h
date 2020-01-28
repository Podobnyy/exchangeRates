//
//  CalculatorController.h
//  exchangerates
//
//  Created by Сергей Александрович on 19.12.2017.
//  Copyright © 2017 Sergey Podobnyy. All rights reserved.
//

#import "bankModel.h"
#import "BaseController.h"

@interface CalculatorController : BaseController

@property(nonatomic, strong) NSString * valuta;
@property(nonatomic, assign) CGFloat buy;
@property(nonatomic, assign) CGFloat sell;

@property(nonatomic, strong) bankModel *model;

@end
