//
//  PLImageClient.m
//  PlutoLand
//
//  Created by xu xhan on 7/15/10.
//  Copyright 2010 xu han. All rights reserved.
//

//TODO: add cache function at fetch method and store method(succeeded on fetching img data)

#import "PLImageLoader.h"
#import "PLImageCacheC.h"
#import "PLHttpQueue.h"
#import "PLOG.h"

NSString* const PLINFO_HC_IMAGE = @"PLINFO_HC_IMAGE";

@implementation PLImageLoader

@synthesize info = _info;

- (id)init
{
	if (self = [super init]) {
		self.delegate = self;
		_imageView = nil;
		_isCacheEnable = YES;
		_isFreshOnSucceed = YES;
	}
	return self;
}

- (void)fetchForImageView:(UIImageView*)imageView URL:(NSString*)url cacheEnable:(BOOL)cacheEnable userInfo:(NSDictionary*)info;
{	
	[self fetchForImageView:imageView URL:url freshOnSucceed:YES cacheEnable:cacheEnable userInfo:info];
}


- (void)fetchForImageView:(UIImageView *)imageView URL:(NSString *)url  freshOnSucceed:(BOOL)isFresh cacheEnable:(BOOL)cacheEnable userInfo:(NSDictionary *)info
{
	_imageView = imageView;
	_isCacheEnable = cacheEnable;
	_isFreshOnSucceed = isFresh;
	
	self.info = [NSMutableDictionary dictionaryWithDictionary:info];
	[super requestGet:url];
	
}

- (void)fetchForObject:(id<PLImageFetcherProtocol>)fetcher URL:(NSString *)url  freshOnSucceed:(BOOL)isFresh cacheEnable:(BOOL)cacheEnable userInfo:(NSDictionary *)info
{
	_fetcherObject = fetcher;
	
	_isCacheEnable = cacheEnable;
	_isFreshOnSucceed = isFresh;	
	self.info = [NSMutableDictionary dictionaryWithDictionary:info];
	
	[super requestGet:url];
}

+ (void)fetchURL:(NSString*)url object:(id)object userInfo:(NSDictionary *)info
{
	//we don't use notification here
	UIImage* cachedImg = [[PLImageCacheC sharedCache] getImageByURL:url];
	if (cachedImg) {
		if ([object respondsToSelector:@selector(fetchedSuccessed:userInfo:)]) {
			[object fetchedSuccessed:cachedImg userInfo:info];
		}		
	}else {
		PLImageLoader* loader = [[PLImageLoader alloc] init];	
		[loader fetchForObject:object URL:url freshOnSucceed:NO cacheEnable:YES userInfo:info];
		[[PLHttpQueue sharedQueue] addQueueItem:loader];
		[loader release];	
	}

}

#pragma mark -
#pragma mark PLImageRequestDelegate
- (void)imageRequestFailed:(PLImageRequest*)request withError:(NSError*)error
{
	PLOGERROR(@"error on fetch image: %@, msg: %@",self.url,[error localizedDescription]);
	//we don't need clean stuffs bcz LoadInstance only works for one URL
}

- (void)imageRequestSucceeded:(PLImageRequest*)request
{
	//TODO: add request costs time
	UIImage* img = [UIImage imageWithData:request.imageData];
	if (!img) {
		return;
	}
	
	if (_isFreshOnSucceed && _imageView) {
        @try {
            _imageView.image = img;
        }
        @catch (NSException *exception) {
            
        }
		
	}
	
	if(_isCacheEnable)
		[[PLImageCacheC sharedCache] storeData:request.imageData forURL:[self.url absoluteString]];
	
	(self.info)[PLINFO_HC_IMAGE] = img;
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_IMAGE_LOADER_SUCCEEDED object:_imageView userInfo:self.info];
		
	if (_fetcherObject!= nil && [_fetcherObject respondsToSelector:@selector(fetchedSuccessed:userInfo:)]) {
		[_fetcherObject fetchedSuccessed:img userInfo:self.info];
	}
}


- (void)dealloc {
	[_info release], _info = nil;
	[super dealloc];
}
@end



