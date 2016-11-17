//
//  MapSvgViewController.m
//  showSvgDemo
//
//  Created by GB on 2016/11/16.
//  Copyright © 2016年 gb. All rights reserved.
//

#import "MapSvgViewController.h"
#import "SVGKit.h"
#import "MapTools.h"
#import "SVProgressHUD.h"
#import "MapSvgHelper.h"
#import "MapXmlParser.h"
#import "MapPickPointView.h"

@interface MapSvgViewController ()<UIScrollViewDelegate>

//显示的View
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)SVGKFastImageView *contentView;

//点击和画图操作
@property(nonatomic,strong)UITapGestureRecognizer *tapGestureRecognizer;
@property(atomic,strong)NSMutableArray *pathViewArray;//以UIView的方式增加
@property(nonatomic,strong)Element *lastHitedElement;//map上点击的元素

//缩放比例
@property(nonatomic,assign,readonly)CGSize zoomedSize;//返回缩放后的对应的size
@property(nonatomic,assign,readonly)CGFloat zoomRate;//缩放比例0-1，level 0.25：1，0.4.5：2，0.6.5：3 1：8.5

@property(nonatomic,strong)MapPaths *mapPaths;
@property(nonatomic,strong)MapPoints *mapPoints;

@end

@implementation MapSvgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pathViewArray=[[NSMutableArray alloc] init];
    [self initView];
    [self initSvgMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)initView{
    [self initNavigate];
    [self initScrollView];
}

-(void)initNavigate{
    self.navigationItem.title=@"显示svg图";
}


-(void)initScrollView{
    //初始化scrollView
    CGRect cgrect=CGRectMake(0, 0, GBScreenWidth, GBScreenHeight);
    self.scrollView=[[UIScrollView alloc] initWithFrame:cgrect];
    [self.view addSubview:self.scrollView];
    self.scrollView.delegate=self;
}

//初始化地图
-(void)initSvgMap{
    [self initSvgImgView:self.svgMapName];
    [self initEvent];
    [self initMapParser];
}

//初始化svg地图

-(void)initSvgImgView:(NSString *)svgName{
    @try {
        //初始化contentView
        //SVGKImage *svgImg=[SVGKImage imageNamed:@"svgMap.svg"];
        //self.contentView=[[SVGKFastImageView alloc] initWithSVGKImage:svgImg];
        
        SVGKImage *svgImg=[SVGKImage imageWithContentsOfFile:svgName];
        self.contentView=[[SVGKFastImageView alloc] initWithSVGKImage:svgImg];
        self.contentView.disableAutoRedrawAtHighestResolution = TRUE;
        self.contentView.showBorder = FALSE;
        [self.scrollView addSubview:self.contentView];
        
        [self.scrollView setContentSize:self.contentView.frame.size];
        float screenToDocumentSizeRatio = self.scrollView.frame.size.width/self.contentView.frame.size.width;
        self.scrollView.minimumZoomScale = MIN( 1, screenToDocumentSizeRatio );
        self.scrollView.maximumZoomScale = MAX( 1, screenToDocumentSizeRatio );
        self.scrollView.delaysContentTouches=YES;
        self.scrollView.showsVerticalScrollIndicator=NO;
        self.scrollView.showsHorizontalScrollIndicator=NO;
        self.scrollView.bounces=YES;
        self.scrollView.bouncesZoom=NO;
        //self.scrollView.decelerationRate=UIScrollViewDecelerationRateNormal;
        self.scrollView.decelerationRate=UIScrollViewDecelerationRateFast;
        self.scrollView.scrollEnabled=YES;
        //[self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:true];
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:false];
    } @catch (NSException *exception) {
        [MapTools showMessage:[NSString stringWithFormat:@"%@",exception.reason]];
    } @finally {
        
    }
}

-(void)initEvent{
    //设置事件
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.contentView addGestureRecognizer:self.tapGestureRecognizer];
}

-(void)handleTapGesture:(UITapGestureRecognizer*) recognizer{
    CGPoint hitPoint = [recognizer locationInView:self.contentView];//获取到点击到的点:地图上的点而不是scrollView上的
    CALayer *svgLayer= ((SVGKFastImageView*)self.contentView).image.CALayerTree;//获取到svg图片的layer
    SVGKImage *svgImage=((SVGKFastImageView*)self.contentView).image;//获取到svg图片
    //显示的内容和实际的图片的比例：SVGKFastImageView不能够改变
    CGSize actualPercentage=self.zoomedSize;
    //获取实际在SVGKFastImageView上点击的点
    hitPoint=CGPointApplyAffineTransform( hitPoint, CGAffineTransformInvert( CGAffineTransformMakeScale(actualPercentage.width, actualPercentage.height)));
    
    //获取点击点层包含实际点击点的图层
    CALayer *hitLayer = [svgLayer hitTest:hitPoint];
    
    if([self.contentView isKindOfClass:[SVGKFastImageView class]] && hitLayer){
        //SVGKFastImageView的图层不能改变，即是说改变的图层不能再屏幕上显示出来，因此必须自定义一个图层（和点击选中的图层frame一样）
        CALayer *absoluteCloneHitLayer = [svgImage newCopyPositionedAbsoluteOfLayer:hitLayer];
        //获取点击的元素
        self.lastHitedElement=[MapSvgHelper getHitedElementOfLayer:absoluteCloneHitLayer inContent:self.contentView];
        if(self.lastHitedElement!=nil){
            NSString *title=[self.lastHitedElement getAttribute:@"name"];
            if(![MapTools isBlankString:title]){
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"你点击的是:%@",title]];
            }
        }
    }
}



/**
 *  因为SVGKFastImageView缩放时候不能改变图层，因此需要获取到缩放后的对应的size
 *
 *  @return 返回缩放后的对应的size
 */
-(CGSize)zoomedSize{
    SVGKImage *svgImage=((SVGKFastImageView*)self.contentView).image;
    CGSize zoomedSize = CGSizeMake(self.contentView.bounds.size.width/svgImage.size.width, self.contentView.bounds.size.height/svgImage.size.height); // this is a copy/paste of the internal "SCALING" logic used in SVGKFastImageView
    return zoomedSize;
}

/**
 *  获取缩放比例：0——1
 *
 *  @return 返回缩放的比例
 */
-(CGFloat)zoomRate{
    SVGKImage *svgImage=((SVGKFastImageView*)self.contentView).image;
    CGFloat zoomRate=MAX(self.contentView.bounds.size.width/svgImage.size.width,  self.contentView.bounds.size.height/svgImage.size.height);
    return zoomRate;
}

/**
 *  初始化map转换的数据
 */
-(void)initMapParser{
    @try {
        _mapPaths=nil;
        _mapPoints=nil;
        // __weak MapNewViewController *weakSelf = self;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group, queue, ^{
            MapXmlParser *xmlPathParser=[[MapXmlParser alloc] initWithType:MapResourceTypePaths path:self.svgMapPath];
            xmlPathParser.parsedBlock=^(id data){
                MapPaths *mapPaths=data;
                if(mapPaths && mapPaths.paths.count>0){
                    //_mapPaths=[mapPaths copy];
                    _mapPaths=mapPaths;
                }
            };
            [xmlPathParser parseXml];
        });
        
        dispatch_group_async(group, queue, ^{
            MapXmlParser *xmlPointParser=[[MapXmlParser alloc] initWithType:MapResourceTypePoints path:self.svgMapPoint];
            xmlPointParser.parsedBlock=^(id data){
                MapPoints *mapPoints=data;
                if(mapPoints && mapPoints.points.count>0){
                    //_mapPoints=[mapPoints copy];
                    _mapPoints=mapPoints;
                }
            };
            [xmlPointParser parseXml];
        });
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
           //to-do
        });
    } @catch (NSException *exception) {
        [MapTools showMessage:[NSString stringWithFormat:@"%@",exception.reason]];
    } @finally {
        
    }
}


#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    //_scrollViewZoomScale=scale;
    //UIScrollView缩放后改变内部UIView的frame
    view.transform = CGAffineTransformIdentity; // this alters view.frame! But *not* view.bounds
    view.bounds = CGRectApplyAffineTransform(view.bounds, CGAffineTransformMakeScale(scale, scale));
    [view setNeedsDisplay];
    //设置缩放的scale并重画
    self.scrollView.minimumZoomScale /= scale;
    self.scrollView.maximumZoomScale /= scale;
    [self.contentView.layer setNeedsDisplay];
    
    //根据缩放结果显示相应的layer
    [self getAllPathLayer];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.contentView;
}


-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width)*0.5:0.0;
    CGFloat offsetY=(scrollView.bounds.size.height>scrollView.contentSize.height)?
    (scrollView.bounds.size.height-scrollView.contentSize.height)*0.3 : 0.0;
    self.contentView.center=CGPointMake(scrollView.contentSize.width*0.5+offsetX,
                                        scrollView.contentSize.height*0.5+offsetY);
}

-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    //[self getAllPathLayer];
}

//根据缩放结果显示相应的layer
-(void)getAllPathLayer{
    if(self.pathViewArray.count>0){
        [_pathViewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MapPickPointView *pointView=obj;
            CGPointObj *pointObj=pointView.cgpointObj;
            CGRect obsoluteCGRect=[MapSvgHelper p_getObsolutePointCGRect:CGPointMake(pointObj.pointX.floatValue, pointObj.pointY.floatValue) scale:self.zoomedSize];
            CGRect frameCGRect=CGRectMake(obsoluteCGRect.origin.x-16, obsoluteCGRect.origin.y-31, 32, 32);
            pointView.frame=frameCGRect;
        }];
    }
}

@end
