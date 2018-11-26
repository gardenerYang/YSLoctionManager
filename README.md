# YSLoctionManager
# 只需调用- (void)getLocationDidFinishBlock:(getLocationDidSuccessed)sucessblock errorBolck:(getLocationDidError)errorBlock;一行代码便可获取用户位置

# 回调获取YSLocationManagerModel模型

 ```objecttive-c 
 [[YSLocationManager sharedManager] getLocationDidFinishBlock:^(YSLocationManagerModel *model) {
        NSLog(@"%f----%@",model.latitude,model.name);
    } errorBolck:^(NSError *error) {
        
    }];
    ```
