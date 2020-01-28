//
//  RootController.m
//  exchangerates
//
//  Created by Сергей Александрович on 15.12.2017.
//  Copyright © 2017 Sergey Podobnyy. All rights reserved.
//

#import "RootController.h"
#import "bankCell.h"
#import "CalculatorController.h"
#import "privatBankModel.h"
#import "bankModel.h"
#import "banksModel.h"
#import <StoreKit/StoreKit.h> // Алерт Поставить рейтинг

@interface RootController () <UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *dataSource;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *CellID;

@property(nonatomic, weak) IBOutlet UIView *headerView;

@end

@implementation RootController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchDataNBU];
    [self fetchData];
    
    self.segmentedControl.selectedSegmentIndex = 1;
    [self segmentedControlValueChaged:self.segmentedControl];
    
    dataSource = (NSMutableArray *)[bankModel bankArray];
    
    // Через 2:00 показать Алерт: Оцените риложения
    [self performSelector:@selector(requestReview) withObject:self afterDelay:120.0];
    // Включить режим Экраная реклама
    [self reklamaEkran];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    bankCell * cell = [tableView dequeueReusableCellWithIdentifier:_CellID];
    bankModel *model = dataSource[indexPath.row];
    
    cell.model = model;
    
    if (indexPath.row == 0) { //  indexPath.row == 0 - ячейки заменяются
        cell.backgroundColor = [UIColor colorWithRed:40/255.f green:40/255.f blue:40/255.f alpha:1]; //darkGrayColor = 85
    } else {
        cell.backgroundColor = [UIColor blackColor];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //убираем selected (что б ячейка тухла после нажатия)
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 50;
//}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return _headerView;
//}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//    return _headerView;
//}


#pragma mark - Actions

- (IBAction)segmentedControlValueChaged:(UISegmentedControl*)sender{
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            _CellID = @"CellIdRoot";
            [_tableView reloadData];
            break;
            
        case 1:
            _CellID = @"CellIdBaks";
            [self.tableView reloadData];
            break;
            
        case 2:
            _CellID = @"CellIdEvro";
            [self.tableView reloadData];
            break;
            
        case 3:
            _CellID = @"CellIdRubl";
            [self.tableView reloadData];
            break;
            
        default:
            break;
    }
    // отдаем
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([sender isKindOfClass:[bankCell class]] && [segue.destinationViewController isKindOfClass:[CalculatorController class]]) {
        ((CalculatorController *)segue.destinationViewController).model = ((bankCell *)sender).model;
        
        if ([_CellID isEqualToString:@"CellIdBaks"]) {
            ((CalculatorController *)segue.destinationViewController).valuta = @"Доллар";
        } else if ([_CellID isEqualToString:@"CellIdEvro"]) {
            ((CalculatorController *)segue.destinationViewController).valuta = @"Евро";
        } else if ([_CellID isEqualToString:@"CellIdRubl"]) {
            ((CalculatorController *)segue.destinationViewController).valuta = @"Рубль";
        } else {
            ((CalculatorController *)segue.destinationViewController).valuta = @"---";
        }
        
}
}

-(void)fetchData{
    NSString *banks = @"https://resources.finance.ua/ru/public/currency-cash.json";
    NSURL *url = [NSURL URLWithString:banks];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        
        if (error) {
            NSLog(@"error = %@", error);
            //
        } else{
            if ([data isKindOfClass:[NSData class]]) {
                
                NSError *jsonError =nil;
                id jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                if (jsonError) {
                    NSLog(@"json error %@",jsonError);
                    //
                } else{
                    NSArray *models = [banksModel banksModelFromArray:jsonData];
                    
                    for (banksModel *model in models) {
                        bankModel *bank = [bankModel new];
                        bank.nameBank = model.title;
                        
                        bank.baksBuy = [model.buyUSD doubleValue];
                        bank.baksSell = [model.saleUSD doubleValue];
                        
                        bank.evroBuy = [model.buyEUR doubleValue];
                        bank.evroSell = [model.saleEUR doubleValue];
                        
                        bank.rublBuy = [model.buyRUB doubleValue];
                        bank.rublSell = [model.saleRUB doubleValue];
                        [dataSource addObject:bank];
                    }
                    [self topNBU];
                    [self fetchDataSuccess:models]; // Вызов метода и ОБНОВИТЬ ТАБЛИЦУ
                }
            } else{
                NSLog(@"wrong data"); // incorrect
                //
            }
        }
    }];
    [task resume];
}

-(void)fetchDataNBU{
    NSString *privatBankOtdelenie = @"https://api.privatbank.ua/p24api/pubinfo?json&exchange&coursid=3";
    NSURL *url = [NSURL URLWithString:privatBankOtdelenie];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        
        if (error) {
            NSLog(@"error = %@", error);
            //
        } else{
            if ([data isKindOfClass:[NSData class]]) {
                
                NSError *jsonError =nil;
                id jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                if (jsonError) {
                    NSLog(@"json error %@",jsonError);
                    //
                } else{
                    NSArray *models = [privatBankModel pbFromArray:jsonData];
                  
                    bankModel *privatBank = [bankModel new];
                    privatBank.nameBank = @"НБУ";
                    //privatBank.nameBank = @"ПриватБанк";
                    
                    for (privatBankModel *model in models) {
                        if ([model.ccy isEqual:@"USD"]) {
                            privatBank.baksBuy = [model.buy doubleValue];
                            privatBank.baksSell = [model.buy doubleValue];
                        //privatBank.baksSell = [model.sale doubleValue];
                        } else if ([model.ccy isEqual:@"EUR"]) {
                            privatBank.evroBuy = [model.buy doubleValue];
                            privatBank.evroSell = [model.buy doubleValue];
                        //privatBank.evroSell = [model.sale doubleValue];
                        } else if ([model.ccy isEqual:@"RUR"]) {
                            privatBank.rublBuy = [model.buy doubleValue];
                            privatBank.rublSell = [model.buy doubleValue];
                        //privatBank.rublSell = [model.sale doubleValue];
                    }
                    }
                    [dataSource addObject:privatBank];
                    [self topNBU];
                    [self fetchDataSuccess:models]; // Вызов метода и ОБНОВИТЬ ТАБЛИЦУ
                }
            } else{
                NSLog(@"wrong data"); // incorrect
                //
            }
        }
    }];
    [task resume];
}


-(void)fetchDataSuccess:(NSArray*) data{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"model \n%@", [data componentsJoinedByString:@"\n"]);
        [self.tableView reloadData];
    });
}

- (void)fetchDataWithError:(NSString *)errorMessage{
    // show alert with error message in main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        // show alert;
        NSLog(@"error %@", errorMessage);
    });
}


#pragma mark - Actions table

-(void)topNBU{
    NSInteger mesto =0;
  
    for (NSInteger i=0; i<dataSource.count; i++) {
        if ([[dataSource[i] nameBank] isEqualToString:@"НБУ"]) {
            mesto = i;
            }
         }
    if (mesto != 0) {
        id obj = dataSource[mesto];
        [dataSource removeObjectAtIndex:mesto];
        [dataSource insertObject:obj atIndex:0];
    }
}

#pragma mark - IBActions Up/Down

-(IBAction)clickUp:(id)sender{
    NSString *str;
    if (![_CellID isEqualToString:@"CellIdRoot"]) {
        if ([_CellID isEqualToString:@"CellIdBaks"]) {
            str = @"baksBuy";
        } else if ([_CellID isEqualToString:@"CellIdEvro"]) {
            str = @"evroBuy";
        } else if ([_CellID isEqualToString:@"CellIdRubl"]){
            str = @"rublBuy";
        }
        [self top:str down:NO];
        [self topNBU];
    }
          // если рут, то ничего не делаем
}

-(IBAction)clickDown:(id)sender{
    NSString *str;
    if (![_CellID isEqualToString:@"CellIdRoot"]) {
        if ([_CellID isEqualToString:@"CellIdBaks"]) {
            str = @"baksSell";
        } else if ([_CellID isEqualToString:@"CellIdEvro"]) {
            str = @"evroSell";
        } else if ([_CellID isEqualToString:@"CellIdRubl"]){
            str = @"rublSell";
        }
        [self top:str down:YES];
        [self topNBU];
    }
    // если рут, то ничего не делаем
}

-(void)top: (NSString *)string down:(BOOL)down{
    NSSortDescriptor *sortDes = [NSSortDescriptor sortDescriptorWithKey:string ascending:down];
    [dataSource sortUsingDescriptors:@[sortDes]];
    [_tableView reloadData];
}

 #pragma mark - RateApp
 - (void)requestReview {
     if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.3) {
         [SKStoreReviewController requestReview];
     }
 }

#pragma mark - Reklama Ekran
-(void)reklamaEkran{
    [self reklamaInterstitialCreateAndDownload]; // загрузить
    [self performSelector:@selector(reklamaInterstitialShowing) withObject:self afterDelay:30.0]; // показать 30сек
    
    [self performSelector:@selector(reklamaInterstitialCreateAndDownload) withObject:self afterDelay:180.0]; // загрузить
    [self performSelector:@selector(reklamaInterstitialShowing) withObject:self afterDelay:210.0]; // показать +3мин=3:30
    
    [self performSelector:@selector(reklamaInterstitialCreateAndDownload) withObject:self afterDelay:480.0]; // загрузить
    [self performSelector:@selector(reklamaInterstitialShowing) withObject:self afterDelay:510.0]; // показать +5мин=8:30
    
    [self performSelector:@selector(reklamaInterstitialCreateAndDownload) withObject:self afterDelay:780.0]; // загрузить
    [self performSelector:@selector(reklamaInterstitialShowing) withObject:self afterDelay:810.0]; // показать +5мин=13:30
    
    [self performSelector:@selector(reklamaInterstitialCreateAndDownload) withObject:self afterDelay:1170.0]; // загрузить
    [self performSelector:@selector(reklamaInterstitialShowing) withObject:self afterDelay:1200.0]; // показать +6,5мин=20:00
}

@end
