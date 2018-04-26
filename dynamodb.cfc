component accessors=true extends='aws' {

	property name='myClient' type='com.amazonaws.services.dynamodbv2.AmazonDynamoDBClient' getter='false' setter='false';	
	property name='dynamodb' type='com.amazonaws.services.dynamodbv2.document.DynamoDB' getter='false' setter='false';	

	property name='tables' type='struct' getter='false' setter='false';

	public dynamodb function init(required string account, required string secret, string region)
	{

		super.init(argumentCollection = arguments);

		variables.tables = {};

		var builder = createAWSObject('services.dynamodbv2.AmazonDynamoDBClientBuilder').standard()
			.withCredentials( getCredentialsProvider() )
			.withRegion(arguments.region);
			
		variables.myClient = builder.build();

		variables.dynamodb = CreateAWSObject( 'services.dynamodbv2.document.DynamoDB' ).init( getMyClient() );

		return this;
	}

	private function getDynamodb()
	{
		return variables.dynamodb;
	}

	private function getTables()
	{
		return variables.tables;
	}

	private function getTable(required string name)
	{
		if (
			!StructKeyExists( getTables() , arguments.name )
		) {

			var table = getDynamodb().getTable(
				arguments.name
			);

			// Just do a describe to check the table exists
			table.describe();

			variables.tables[ arguments.name ] = table;

		}
		return variables.tables[ arguments.name ];
	}

	public any function getItem(required string table, required string key, required string value, boolean asStruct=true, string key2, string value2)
	{
		var table = getTable( 
			name = arguments.table
		);

		if (
			StructKeyExists( arguments , 'key2' )
			&&
			StructKeyExists( arguments , 'value2' )
		) {
			var item = table.getItem(
				arguments.key,
				arguments.value,
				arguments.key2,
				arguments.value2
			);
		} else {
			var item = table.getItem(
				arguments.key,
				arguments.value
			);
		}

		// Set up an empty item if it is null. DynamoDB returns a null object if the document cannot be found by the lookup criteria.
		if ( isNull(item) )
			item = newItem();
		
		// Return a struct by default
		if ( arguments.asStruct )
			return deserializeJSON( item.toJSON() );

		// Return the item if requested by the `asStruct` arugment
		return item;
	}

	public any function newItem()
	{
		return createAWSObject( 'services.dynamodbv2.document.Item' ).init();
	}

	public any function newItemFromJson(required string json)
	{
		return createAWSObject( 'services.dynamodbv2.document.Item' ).init()
			.fromJson(arguments.json);
	}

	public any function newItemFromMap(required struct map)
	{
		return createAWSObject( 'services.dynamodbv2.document.Item' ).init()
			.fromMap(arguments.map);
	}

	public void function putItem(required string table, required any item )
	{
		var table = getTable(name=arguments.table);

		table.putItem(arguments.item);
	}

	public any function deleteItem(required string table, required string key, required string value)
	{
		var table = getTable( 
			name = arguments.table
		);

		var deleteItemOutcome = table.deleteItem(arguments.key, arguments.value);

		// Return the outcome
		return deleteItemOutcome;
	}

	public array function scan(required string table, string filterExpression, string projectionExpression, struct nameMap, struct valueMap, boolean asArray=true)
	{
		var table = getTable( 
			name = arguments.table
		);

		var results = table.scan(
			arguments.filterExpression ?: JavaCast( 'null' , 0 ),
			arguments.projectionExpression ?: JavaCast( 'null' , 0 ),
			arguments.nameMap ?: JavaCast( 'null' , 0 ),
			arguments.valueMap ?: JavaCast( 'null' , 0 )
		).iterator();

		if (!arguments.asArray)
			return results;

		var rendered_results = [];

		while ( results.hasNext() ) {
			rendered_results.add(
				deserializeJSON(
					results.next().toJSON()
				)
			);
		}

		return rendered_results;
	}

}