# YSLoctionManager

## 使用
```objecttive-c 
 [[YSLocationManager sharedManager] getLocationDidFinishBlock:^(YSLocationManagerModel *model) {
        NSLog(@"%f----%@",model.latitude,model.name);//回调获取YSLocationManagerModel模型
    } errorBolck:^(NSError *error) {
        
    }];
```
## 注意
### 使用前在info.plist文件中添加

Privacy - Location When In Use Usage Description    我们需要通过你的位置获取周边数据并提供xxx

Privacy - Location Always and When In Use Usage Description  我们需要通过你的位置获取周边数据并提供xxx

Required background modes : App registers for location updates

如果需要后台定位添加allowsBackgroundLocationUpdates YES
 
