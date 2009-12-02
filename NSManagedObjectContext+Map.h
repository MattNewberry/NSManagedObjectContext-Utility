//
//  NSManagedObjectContext+Map.h
//  Shopify_iPhone
//
//  Created by Matt Newberry on 12/2/09.
//  Copyright 2009 JadedPixel, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSManagedObjectContext (NSManagedObjectContext_Map)

- (NSManagedObjectID *) add:(NSDictionary *)row toEntity:(NSString *)toEntity;
- (NSManagedObjectID *) update:(NSDictionary *)row toEntity:(NSString *)toEntity forObjectID:(NSManagedObjectID *)forObjectID;
- (void) delete:(NSPredicate *)predicate inEntity:(NSString *)inEntity;

@end
