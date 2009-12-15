//
//  NSManagedObjectContext+Utility.h
//  Shopify
//
//  Created by Matt Newberry on 12/4/09.
//  Copyright 2009 Jaded Pixel Technologies Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSManagedObjectContext (NSManagedObjectContext_Utility)

+ (NSManagedObjectContext *) shared;
- (NSArray *) find:(NSPredicate *)predicate inEntity:(NSString *)inEntity sortBy:(NSArray *)sortBy;
- (NSManagedObject *) add:(NSDictionary *)row inEntity:(NSString *)inEntity;
- (NSManagedObject *) update:(NSDictionary *)row inEntity:(NSString *)inEntity forObjectID:(NSManagedObjectID *)forObjectID;
- (void) delete:(NSPredicate *)predicate inEntity:(NSString *)inEntity;

@end
