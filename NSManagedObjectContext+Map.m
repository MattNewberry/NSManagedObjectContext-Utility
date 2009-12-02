//
//  NSManagedObjectContext+Map.m
//  Shopify_iPhone
//
//  Created by Matt Newberry on 12/2/09.
//  Copyright 2009 JadedPixel, LLC. All rights reserved.
//

#import "NSManagedObjectContext+Map.h"


@implementation NSManagedObjectContext (NSManagedObjectContext_Map)

- (NSManagedObjectID *) add:(NSDictionary *)row toEntity:(NSString *)toEntity{
	
	return [self update:row toEntity:toEntity forObjectID:nil];
}

- (NSManagedObjectID *) update:(NSDictionary *)row toEntity:(NSString *)toEntity forObjectID:(NSManagedObjectID *)forObjectID{
	
	NSManagedObject *newObject;
	
	if(forObjectID == nil)
		newObject = (NSManagedObject *) [NSEntityDescription insertNewObjectForEntityForName:toEntity inManagedObjectContext:self];
	else
		newObject = (NSManagedObject *) [self objectWithID:forObjectID];
	
	NSDictionary *description	= [[NSEntityDescription entityForName:[[newObject entity] name] inManagedObjectContext:self] propertiesByName];
	
	for(NSString *field in row){
		
		NSString *key = [field stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
		
		if([[description allKeys] containsObject:key]){
			
			int type = [[description objectForKey:key] attributeType];
			
			if(type == NSStringAttributeType){
				[newObject setValue:[row objectForKey:field] forKey:key];
			}
			
			if(type == NSInteger16AttributeType || type == NSInteger32AttributeType || type == NSInteger64AttributeType){
				
				[newObject setValue:[NSNumber numberWithInt:[[row objectForKey:field] intValue]] forKey:key];
			}
			
			if(type == NSDecimalAttributeType || type == NSFloatAttributeType){
				[newObject setValue:[NSNumber numberWithFloat:[[row objectForKey:field] floatValue]] forKey:key];
			}
			
			if(type == NSDoubleAttributeType){
				[newObject setValue:[NSNumber numberWithFloat:[[row objectForKey:field] doubleValue]] forKey:key];
			}
			
			if(type == NSBooleanAttributeType){
				[newObject setValue:[NSNumber numberWithBool:[[row objectForKey:field] boolValue]] forKey:key];
			}
		}
	}
		
	NSLog(@"Inserted - %@", [[self insertedObjects] description]);
	
	NSError *error;
	if(![newObject validateForInsert:&error])
		NSLog(@"%@", [error localizedDescription]);
	else
		[self save:&error];
	
	return [newObject objectID];	
}

- (void) delete:(NSPredicate *)predicate inEntity:(NSString *)inEntity{
	
	NSError *error;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:inEntity inManagedObjectContext:self];
	[fetchRequest setEntity:entity];
	[fetchRequest setPredicate:predicate];
	NSArray *rows = [self executeFetchRequest:fetchRequest error:&error];
	
	for(NSManagedObject *row in rows){
		
		if(![row validateForDelete:&error])
			NSLog(@"%@", [error localizedDescription]);
		else
			[self deleteObject:row];
	}
	
	NSLog(@"Deleted - %@", [[self deletedObjects] description]);
	
	[self save:&error];
		
	[fetchRequest release];
}

@end
