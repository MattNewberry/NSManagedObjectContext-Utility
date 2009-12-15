//
//  NSManagedObjectContext+Utility.m
//  Shopify
//
//  Created by Matt Newberry on 12/4/09.
//  Copyright 2009 Jaded Pixel Technologies Inc. All rights reserved.
//

#import "NSManagedObjectContext+Utility.h"
#import "ShopifyAppDelegate.h"

static NSManagedObjectContext *_sharedInstance;


@implementation NSManagedObjectContext (NSManagedObjectContext_Utility)

+ (NSManagedObjectContext *) shared{
	
	if(!_sharedInstance){
		
		ShopifyAppDelegate *delegate	= [[UIApplication sharedApplication] delegate];
		_sharedInstance					= [delegate managedObjectContext];
	}
	
	return _sharedInstance;
}

- (NSArray *) find:(NSPredicate *)predicate inEntity:(NSString *)inEntity sortBy:(NSArray *)sortBy{
		
	NSError *error;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:inEntity inManagedObjectContext:self];
	[fetchRequest setEntity:entity];
	[fetchRequest setPredicate:predicate];
	[fetchRequest setSortDescriptors:sortBy];
	
	NSArray *rows = [self executeFetchRequest:fetchRequest error:&error];
	
	[fetchRequest release];
		
	return [rows count] > 0 ? rows : nil;
}

- (NSManagedObject *) add:(NSDictionary *)row inEntity:(NSString *)inEntity{
	
	return [self update:row inEntity:inEntity forObjectID:nil];
}

- (NSManagedObject *) update:(NSDictionary *)row inEntity:(NSString *)inEntity forObjectID:(NSManagedObjectID *)forObjectID{
	
	NSManagedObject *newObject;
	
	if(forObjectID == nil)
		newObject = (NSManagedObject *) [NSEntityDescription insertNewObjectForEntityForName:inEntity inManagedObjectContext:self];
	else
		newObject = (NSManagedObject *) [self objectWithID:forObjectID];
	
	NSDictionary *description	= [[NSEntityDescription entityForName:[[newObject entity] name] inManagedObjectContext:self] propertiesByName];
	
	for(NSString *field in row){
		
		NSString *key = [field stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
		
		if([[description objectForKey:key] isKindOfClass:[NSRelationshipDescription class]]){
			
			if([[row objectForKey:field] isKindOfClass:[NSSet class]])
				[newObject setValue:[row objectForKey:field] forKey:key];
		}
		else if([[description allKeys] containsObject:key]){
			
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
			
			if(type == NSDateAttributeType){
				
				NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
				[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
				NSDate *date = [formatter dateFromString:[row objectForKey:field]];
				[newObject setValue:date forKey:key];
				[formatter release];
			}
		}
	}
	
	//NSLog(@"Inserted - %@", [[self insertedObjects] description]);
	//NSLog(@"Updated - %@", [[self updatedObjects] description]);
	
	NSError *error;
	if(![newObject validateForInsert:&error])
		NSLog(@"%@", [error localizedDescription]);
	else
		[self save:&error];
	
	return newObject;	
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
	
	//NSLog(@"Deleted - %@", [[self deletedObjects] description]);
	
	[self save:&error];
	
	[fetchRequest release];
}

@end
