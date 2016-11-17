

#import "MapTools.h"

@implementation MapTools

/******NSData与对象相互转化 start********/
//对象转NSData:对象必须实现NSCoding
+(NSData *)objectToData:(NSObject *)object{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:object forKey:@"cheng-hui-guang-key"];
    [archiver finishEncoding];
    return data;
}
//NSData转对象:对象必须实现NSCoding
+(NSObject *)dataToObject:(NSData *)data{
    NSKeyedUnarchiver *unArchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSObject *object = [unArchiver decodeObjectForKey:@"cheng-hui-guang-key"];
    [unArchiver finishDecoding];
    return object;
}
/*******NSData与对象相互转化 end*******/



+(BOOL)isBlankString:(NSString*)str{
    str=[NSString stringWithFormat:@"%@",str];
    if(str==nil || str==NULL){
        return YES;
    }
    if([str isKindOfClass:[NSNull class]]){
        return YES;
    }
    if([str isEqual:[NSNull null]]) {
        return YES;
    }
    if([str isEqualToString:[NSString stringWithFormat:@"%@",nil]]){
        return YES;
    }
    if([str isEqualToString:[NSString stringWithFormat:@"%@",[NSNull null]]]){
        return YES;
    }
    
    if([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0){
        return  YES;
    }
    return  NO;
}
+(BOOL)isBlankArray:(NSArray *)array{
    if (array!=nil && ![array isKindOfClass:[NSNull class]] && [array count]!=0) {
        return NO;
    } else {
        return YES;
    }
}
+(BOOL)isBlankDictionary:(NSDictionary*)dict{
    if (dict!=nil && ![dict isKindOfClass:[NSNull class]] && [dict count]!=0) {
        return NO;
    } else {
        return YES;
    }
}

+ (BOOL) isObjEmpty:(id) obj{
    if(!obj || [obj isKindOfClass:[NSNull class]] || obj == NULL || obj == nil)
        return YES;
    return NO;
}
/*********************常用校验start*********************/
+(NSString *)GetSysDataTime{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}

+(BOOL)checkBankNum:(NSString *)bankNum{
    if (bankNum.length == 0){
        return NO;
    }
    NSString *lastNum = [bankNum substringWithRange:NSMakeRange(bankNum.length-1, 1)];//取出最后一位（与luhm进行比较）
    NSString *firstNum = [bankNum substringWithRange:NSMakeRange(0, bankNum.length-1)];//前15或18位
    NSMutableArray *bankNums = [[NSMutableArray alloc] init];//前15或18位倒序存进数组
    for (NSInteger numIndex = firstNum.length-1; numIndex > -1; --numIndex){
        [bankNums addObject:[firstNum substringWithRange:NSMakeRange(numIndex, 1)]];
    }
    NSMutableArray *arrJiShu = [[NSMutableArray alloc] init]; //奇数位*2的积 <9
    NSMutableArray *arrJiShu2 = [[NSMutableArray alloc] init]; //奇数位*2的积 >9
    NSMutableArray *arrOuShu = [[NSMutableArray alloc] init]; //偶数位数组
    for (int numIndex = 0; numIndex < bankNums.count; ++numIndex){
        if ((numIndex+1)%2 == 1){ //奇数位
            NSString *str = [NSString stringWithFormat:@"%d", [bankNums[numIndex] intValue]*2];
            if ([bankNums[numIndex] intValue]*2 < 9){
                [arrJiShu addObject:str];
            }else{
                [arrJiShu2 addObject:str];
            }
        }else{ //偶数位
            [arrOuShu addObject:bankNums[numIndex]];
        }
    }
    NSMutableArray *jiShuChild1 = [[NSMutableArray alloc] init]; //奇数位*2 >9 的分割之后的数组个位数
    NSMutableArray *jiShuChild2 = [[NSMutableArray alloc] init]; //奇数位*2 >9 的分割之后的数组十位数
    for (int numIndex = 0; numIndex < arrJiShu2.count; ++numIndex){
        NSString *str1 = [NSString stringWithFormat:@"%d", [arrJiShu2[numIndex] intValue]%10];
        NSString *str2 = [NSString stringWithFormat:@"%d", [arrJiShu2[numIndex] intValue]/10];
        [jiShuChild1 addObject:str1];
        [jiShuChild2 addObject:str2];
    }
    int sumJiShu=0; //奇数位*2 < 9 的数组之和
    int sumOuShu=0; //偶数位数组之和
    int sumJiShuChild1=0; //奇数位*2 >9 的分割之后的数组个位数之和
    int sumJiShuChild2=0; //奇数位*2 >9 的分割之后的数组十位数之和
    int sumTotal=0;
    for (int m = 0; m < arrJiShu.count; ++m){
        sumJiShu += [arrJiShu[m] intValue];
    }
    for (int n = 0; n < arrOuShu.count; ++n){
        sumOuShu += [arrOuShu[n] intValue];
    }
    for (int p = 0; p < jiShuChild1.count; ++p){
        sumJiShuChild1 += [jiShuChild1[p] intValue];
        sumJiShuChild2 += [jiShuChild2[p] intValue];
    }
    //计算总和
    sumTotal = sumJiShu+sumOuShu+sumJiShuChild1+sumJiShuChild2;
    //计算Luhm值
    int k = sumTotal%10==0 ? 10 : sumTotal%10;
    int luhm = 10 - k;
    if ([lastNum intValue] == luhm){
        // 提示：恭喜！您输入的银行卡通过验证，可以添加
        return YES;
    }else{
        // 提示：银行卡卡号错误，添加失败
        return NO;
    }
}

+(BOOL)isChinese:(NSString *)str{
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}

+(void)showMessage:(NSString *)message{
    CGFloat SCREEN_WIDTH=[[UIScreen mainScreen] bounds].size.width;
    CGFloat SCREEN_HEIGHT=[[UIScreen mainScreen] bounds].size.height;
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    CGSize LabelSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(290, 9000)];
    label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [showview addSubview:label];
    showview.frame = CGRectMake((SCREEN_WIDTH - LabelSize.width - 20)/2, SCREEN_HEIGHT/2, LabelSize.width+20, LabelSize.height+10);
    [UIView animateWithDuration:2 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

@end
