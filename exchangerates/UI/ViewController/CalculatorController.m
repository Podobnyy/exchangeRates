//
//  CalculatorController.m
//  exchangerates
//
//  Created by Сергей Александрович on 19.12.2017.
//  Copyright © 2017 Sergey Podobnyy. All rights reserved.
//

#import "CalculatorController.h"

@interface CalculatorController ()

// радиус
@property(nonatomic, weak) IBOutlet UIView *viewEnter;
@property(nonatomic, weak) IBOutlet UIView *viewResult;
@property(nonatomic, weak) IBOutlet UIButton *btn0;
@property(nonatomic, weak) IBOutlet UIButton *btn1;
@property(nonatomic, weak) IBOutlet UIButton *btn2;
@property(nonatomic, weak) IBOutlet UIButton *btn3;
@property(nonatomic, weak) IBOutlet UIButton *btn4;
@property(nonatomic, weak) IBOutlet UIButton *btn5;
@property(nonatomic, weak) IBOutlet UIButton *btn6;
@property(nonatomic, weak) IBOutlet UIButton *btn7;
@property(nonatomic, weak) IBOutlet UIButton *btn8;
@property(nonatomic, weak) IBOutlet UIButton *btn9;
@property(nonatomic, weak) IBOutlet UIButton *btnAC;
@property(nonatomic, weak) IBOutlet UIButton *btnMinus;

//
@property(nonatomic, weak) IBOutlet UIButton *btnBuy;
@property(nonatomic, weak) IBOutlet UIButton *btnSell;

//
@property(nonatomic, assign) CGFloat userEnterFloat;
@property(nonatomic, weak) IBOutlet UILabel *labelEnter;
@property(nonatomic, weak) IBOutlet UILabel *labelResult;
@property(nonatomic, weak) IBOutlet UIImageView *imageEnter;
@property(nonatomic, weak) IBOutlet UIImageView *imageResult;
@property(nonatomic, strong) NSString *enter;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonItemRight; // правая кнопка в навигейшнБар (для знака)

//
@property(nonatomic, strong) NSString *valutaIcon;

@end

@implementation CalculatorController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view layoutIfNeeded]; //////////
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self whatValue];
    [self whatBTN];
    [self clickBtnSell:nil];
    _enter = @"";
    [self labelOfString];
    [self radius];
    _imageResult.image = [UIImage imageNamed:@"imageOrangeGRN"]; // Знак гривны в полосе результат
}

-(void)viewWillLayoutSubviews{
    
}

#pragma mark - IBActions BUY/SELL

-(IBAction)clickBtnBuy:(id)sender{
    _btnBuy.backgroundColor = [UIColor colorWithRed:250/255.f green:137/255.f blue:17/255.f alpha:1];
    _btnBuy.selected = YES;
    _btnSell.selected = NO;
    _btnSell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self calculation];
}

-(IBAction)clickBtnSell:(id)sender{
    _btnSell.backgroundColor = [UIColor colorWithRed:250/255.f green:137/255.f blue:17/255.f alpha:1]; // FA8911
    _btnSell.selected = YES;
    _btnBuy.selected = NO;
    _btnBuy.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self calculation];
}

#pragma mark - IBActions
// цифры 0-9
- (IBAction)clickButtonNumber:(UIButton*)sender{
    NSInteger i = _enter.length;
    
    if (_enter.length < 8) {
        if ( (i!=0) || (![sender.titleLabel.text isEqualToString:@"0"])) {
            _enter = [_enter stringByAppendingString:[NSString stringWithFormat:@"%@",sender.titleLabel.text]];
            _userEnterFloat = (_userEnterFloat * 10) + [sender.titleLabel.text integerValue]; // добавляем цифру к ЧислуПользователя
            [self labelOfString];
        }
}
    [self calculation];
}

// Очистить Поле Ввода
- (IBAction)clickNumberAC:(id)sender {
    _enter = @"";
    [self labelOfString];
    _userEnterFloat = 0; // ЧислоПользователя равно 0
    [self calculation];
}

// Отнять Последнию Цифру
- (IBAction)clickBtnMinus:(id)sender {
    if (_enter.length >0) {
        _enter = [_enter substringToIndex:_enter.length -1];
        
        NSInteger i = _userEnterFloat/10;
        _userEnterFloat = i;
        
        [self labelOfString];
    }
    
    [self calculation];
}

#pragma mark - void
//Какая Валюта?
-(void)whatValue{
    if ([_valuta isEqualToString:@"Доллар"]) {
        _buy = _model.baksBuy;
        _sell = _model.baksSell;
        
        self.title = _model.nameBank; // можно в одно
        //_barButtonItemRight.title = @"$";
        // Title
//        UIImage *image = [UIImage imageNamed:@"imageTitleDollar"];
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//        imageView.frame = CGRectMake(0, 0, 40, 40);
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        self.navigationItem.titleView = imageView;
        
        _imageEnter.image = [UIImage imageNamed:@"imageOrangeDollar"]; // Какая валюта вводе
        
        _valutaIcon = @"$";
        
    } else if ([_valuta isEqualToString:@"Евро"]) {
        _buy = _model.evroBuy;
        _sell = _model.evroSell;
        
        self.title = _model.nameBank; // можно в одно
        
        _imageEnter.image = [UIImage imageNamed:@"imageOrangeEvro"]; // Какая валюта вводе
        
        _valutaIcon = @"€";
        
    } else if ([_valuta isEqualToString:@"Рубль"]) {
        _buy = _model.rublBuy;
        _sell = _model.rublSell;
        
        self.title = _model.nameBank; // можно в одно
        
        _imageEnter.image = [UIImage imageNamed:@"imageOrangeRUS"]; // Какая валюта вводе
        
        _valutaIcon = @"₽";
    }
}
//Радиус кнопкам и надпись на кнопках
-(void)whatBTN{
    [_btnBuy setTitle:[NSString stringWithFormat:@"Продать %@  %.3f", _valutaIcon, _buy] forState:UIControlStateNormal];
    
    [_btnSell setTitle:[NSString stringWithFormat:@"Купить %@  %.3f", _valutaIcon , _sell] forState:UIControlStateNormal];
}

// Как писать Строку Ввода
-(void)labelOfString{
    NSString *str = _enter;
    CGFloat myFloat = [str doubleValue];
    
    if (![_enter isEqualToString:@""]) {
        _labelEnter.text = [self stringNumber:myFloat];
    } else {
        _labelEnter.text = @"0";
    }
}

// Всем обектам задать Радиус
-(void)radius{
    CGFloat rad = _btn0.frame.size.height / 2;
    _btn0.layer.cornerRadius = rad;
    _btn1.layer.cornerRadius = rad;
    _btn2.layer.cornerRadius = rad;
    _btn3.layer.cornerRadius = rad;
    _btn4.layer.cornerRadius = rad;
    _btn5.layer.cornerRadius = rad;
    _btn6.layer.cornerRadius = rad;
    _btn7.layer.cornerRadius = rad;
    _btn8.layer.cornerRadius = rad;
    _btn9.layer.cornerRadius = rad;
    _btnAC.layer.cornerRadius = rad;
    _btnMinus.layer.cornerRadius = rad;
    
    _viewEnter.layer.cornerRadius = _viewEnter.frame.size.height / 2;//rad/2;
    _viewResult.layer.cornerRadius = _viewResult.frame.size.height / 2;//rad/2;
    
    _btnBuy.layer.cornerRadius= _btnBuy.frame.size.height / 2; //rad/2;
    _btnSell.layer.cornerRadius = _btnSell.frame.size.height / 2; //rad/2;
}

#pragma mark - Calculations

-(void)calculation{
    [self whatResult];
}

-(void)whatResult{
    CGFloat result;
    
    if (_btnBuy.selected) {
        result = _userEnterFloat * _buy; // YES = Продаем Валюту ($€₽)
    } else {
        result = _userEnterFloat * _sell; // NO = Покупаем Валюту ($€₽)
    }
    
    _labelResult.text = [self stringNumber:result];
}

#pragma marl - Methot
// Сделать пробел между тысяч
-(NSString*)stringNumber:(CGFloat)data{
    NSNumber *number = [NSNumber numberWithDouble:data];
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    // для всех локаций
    NSString * rec = [formatter stringFromNumber:number];
    if (rec.length > 4) {
        NSRange range1 = NSMakeRange(0, rec.length - 3);
        NSRange range2 = NSMakeRange(rec.length - 3, 3);
        NSString *str1 = [rec substringWithRange:range1];
        str1 = [str1 stringByReplacingOccurrencesOfString:@"," withString:@" "];
        NSString *str2 = [rec substringWithRange:range2];
        str2 = [str2 stringByReplacingOccurrencesOfString:@"." withString:@","];
        rec = [str1 stringByAppendingString:str2];
    } else{
        rec = [rec stringByReplacingOccurrencesOfString:@"." withString:@","];
    }
    
    return rec;
}

@end
