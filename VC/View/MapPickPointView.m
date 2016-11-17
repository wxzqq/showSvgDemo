//
//  MapPickPointView.m
//  svgDemo
//
//  Created by GB on 16/9/27.
//  Copyright © 2016年 hhys. All rights reserved.
//

#import "MapPickPointView.h"

@interface MapPickPointView()

@property(nonatomic,strong)UIImageView *mapImgView;
@property(nonatomic,strong)UILabel *indexLabel;

@end

@implementation MapPickPointView

-(instancetype)init{
    NSAssert( FALSE, @"This class has no init method - it MUST NOT be init'd via init - you MUST use one of the multi-argument constructors instead" );
    
    return nil;
}

-(instancetype)initWithFrame:(CGRect)frame isSaved:(BOOL)isSaved title:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
        _isSaved=isSaved;
        _indexTitle=title;
        
        _mapImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        //_mapImgView.image=[UIImage imageNamed:@"pick_selected_flag"];
        _mapImgView.image=[UIImage imageNamed:@"pick_selected_flag"];
        [self addSubview:_mapImgView];
        
        if(isSaved){
            [self addIndexLabel];
        }
    }
    return self;
}



//-(void)setFrame:(CGRect)frame{
//    if(_mapImgView && _indexLabel){
//        _mapImgView.frame=CGRectMake(frame.size.width/2-9.5, frame.size.height-19, 19, 19);
//    }
//    [super setFrame:frame];
//}


//添加indexLabel
-(void)addIndexLabel{
    _indexLabel=[[UILabel alloc] init];
    _indexLabel.frame=CGRectMake(0, 5, 32, 15);
    _indexLabel.font=[UIFont systemFontOfSize:10.0];
    _indexLabel.textColor=[UIColor blackColor];
    _indexLabel.textAlignment=NSTextAlignmentCenter;
    _indexLabel.numberOfLines=1;
    _indexLabel.text=self.indexTitle;
    [self addSubview:_indexLabel];
}


@end
