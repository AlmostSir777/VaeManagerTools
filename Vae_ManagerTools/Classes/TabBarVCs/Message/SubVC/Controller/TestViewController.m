//
//  TestViewController.m
//  Vae_ManagerTools
//
//  Created by mac on 2018/12/25.
//  Copyright © 2018年 闵玉辉. All rights reserved.
//

#import "TestViewController.h"
#import "Person.h"
@interface TestViewController ()
@property (nonatomic,strong) Person * p;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"链式编程";
    Person * p = [[Person alloc] init];
    p.eat(@"腰子").sleep(5).play(@"武功",^(NSString * gameName){
    SSLog(@"%@",gameName);
    });
    self.p = p;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_p toPlay];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
