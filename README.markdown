Designed for use with NSDictionary and Core Data, this class extends the native functionality of NSManagedObjectContext to allow for easy handling of data.

## Example
	
	NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:@"myValue", @"myKey", nil];

	[managedObjectContext delete:nil inEntity:@"Shop"];
	[managedObjectContext add:data toEntity:@"Shop"];
