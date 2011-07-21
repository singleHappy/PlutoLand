//
//  T.m
//  PlutoLand
//
//  Created by xu xhan on 7/16/10.
//  Copyright 2010 xu han. All rights reserved.
//

#import "T.h"


@implementation T

+ (UIButton*)createBtnfromPoint:(CGPoint)point imageStr:(NSString*)imgstr target:(id)target selector:(SEL)selector;
{
	UIImage* img = [T imageNamed:imgstr];
	return [self createBtnfromPoint:point image:img target:target selector:selector];
}


+ (UIButton*)createBtnfromPoint:(CGPoint)point imageStr:(NSString*)imgstr highlightImgStr:(NSString*)himgstr target:(id)target selector:(SEL)selector;
{
	UIImage* img = [T imageNamed:imgstr];
	UIImage* imgHighlight = [T imageNamed:himgstr];
	return [self createBtnfromPoint:point image:img highlightImg:imgHighlight target:target selector:selector];
}


+ (UIButton*)createBtnfromPoint:(CGPoint)point image:(UIImage*)img target:(id)target selector:(SEL)selector
{
	UIButton *abtn = [[ [UIButton alloc] initWithFrame:CGRectMake(point.x,point.y ,img.size.width,img.size.height)] autorelease];
	abtn.backgroundColor = [UIColor clearColor];
	[abtn setBackgroundImage:img forState:UIControlStateNormal];
	[abtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	return abtn;	
}


+ (UIButton*)createBtnfromPoint:(CGPoint)point image:(UIImage*)img highlightImg:(UIImage*)himg target:(id)target selector:(SEL)selector
{
	UIButton *abtn = [[ [UIButton alloc] initWithFrame:CGRectMake(point.x,point.y ,img.size.width,img.size.height)] autorelease];
	abtn.backgroundColor = [UIColor clearColor];
	[abtn setBackgroundImage:img forState:UIControlStateNormal];
	[abtn setBackgroundImage:himg forState:UIControlStateHighlighted];
	[abtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	return abtn;	
}

+ (UIButton*)createBtnfromFrame:(CGRect)frame imageStr:(NSString*)imgstr highlightImgStr:(NSString*)himgstr target:(id)target selector:(SEL)selector
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = frame;
    [btn setImage:[T imageNamed:imgstr]
         forState:UIControlStateNormal];
    if(himgstr)
        [btn setImage:[T imageNamed:himgstr]
         forState:UIControlStateHighlighted];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


+ (UIColor*)colorR:(float)r g:(float)g b:(float)b
{
	return [self colorR:r g:g b:b a:1];
}

//alpha from 0 to 1
+ (UIColor*)colorR:(float)r g:(float)g b:(float)b a:(float)a
{
	return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

+ (UIImage*)imageNamed:(NSString*)fileName
{
    BOOL isHighResolution = NO;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        if ([UIScreen mainScreen].scale > 1) {
            isHighResolution = YES;  
        }
    }
#ifdef ALWAYS_RETINA
    isHighResolution = YES;
#endif
    
    if (isHighResolution) {
        NSArray* array = [fileName componentsSeparatedByString:@"."];
        fileName = [array componentsJoinedByString:@"@2x."];
    }
	NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];   
    //	UIImage* i = [UIImage imageWithContentsOfFile:path];
	return [UIImage imageWithContentsOfFile:path];
}

+ (UIImageView*)imageViewNamed:(NSString*)fileName
{
	UIImageView* imageview = [[UIImageView alloc] initWithImage:[self imageNamed:fileName]];
	return [imageview autorelease];
}


+ (NSString*)randomName
{
	return	[NSString stringWithFormat:@"%.2lf",[[NSDate date] timeIntervalSince1970]];
}
@end
