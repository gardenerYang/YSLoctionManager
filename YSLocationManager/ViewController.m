//
//  ViewController.m
//  YSLocationManager
//
//  Created by yangshuai on 2018/11/7.
//  Copyright © 2018年 daniel. All rights reserved.
//

#import "ViewController.h"
#import "YSLocationManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[YSLocationManager sharedManager] getLocationDidFinishBlock:^(YSLocationManagerModel *model) {
        NSLog(@"%f----%@",model.latitude,model.name);
    } errorBolck:^(NSError *error) {
        
    }];
}


@end

