component extends='testbox.system.BaseSpec' {

	function run() {

		describe( 'dynamodb' , function() {

			beforeEach( function( currentSpec ) {
				service = new aws.dynamodb(
					account = application.aws_settings.aws_accountid,
					secret = application.aws_settings.aws_secretkey,
					region = 'us-east-1'
				);
			});

			it( 'extends aws' , function() {
				expect( service).toBeInstanceOf('aws.aws');
			});


			it( 'has a dynamodb client stored' , function() {

				makePublic( service , 'getMyClient' , 'getMyClient' );

				actual = service.getMyClient();

				expect(actual.getClass().getName()).toBe('com.amazonaws.services.dynamodbv2.AmazonDynamoDBClient');

			});


			it( 'has a dynamodb service stored' , function() {

				makePublic( service , 'getDynamodb' , 'getDynamodb' );

				actual = service.getDynamodb();

				expect(actual.getClass().getName()).toBe('com.amazonaws.services.dynamodbv2.document.DynamoDB');

			});

			describe( 'getTable()' , function() {

				beforeEach( function( currentSpec ) {
					makePublic( service , 'getTable' , 'getTable' );
				});

				it( 'can get a table' , function() {

					actual = service.getTable("requestor");

					expect(actual.getClass().getName()).toBe('com.amazonaws.services.dynamodbv2.document.Table');
				});

				it( 'throws an error for a nonexistant table' , function() {

					expect( function() {
						service.getTable('i-do-not-exist');
					}).toThrow();

				});

				it( 'caches requested tables' , function() {

					makePublic( service , 'getTables' , 'getTables' );

					before = service.getTables();

					expect( before ).toBe( {} );

					service.getTable("requestor");

					actual = service.getTables();

					expect( actual ).toHaveKey("requestor");

					expect(actual["requestor"].getClass().getName()).toBe('com.amazonaws.services.dynamodbv2.document.Table');

				});


			});

			describe( 'getItem() as a structure' , function() {

				it( 'can get a structure using a hash+range lookup' , function() {

					actual = service.getItem(
						table = "requestor",
						key = 'requestorId',
						value = '4313FAC4-64BD-4211-B964-456F109C2427'
					);

					//debug(actual);

					expect ( actual ).toBeTypeOf("struct");
					expect ( actual ).notToBeEmpty();
				});

				it( 'returns an empty structure for a nonexistant record' , function() {					
					actual = service.getItem(
						table = "requestor",
						key = 'requestorId',
						value = "testKey"
					);

					expect ( actual ).toBeTypeOf("struct");
					expect ( actual ).toBeEmpty();
				});

			});

			describe( 'getItem() as an `com.amazonaws.services.dynamodbv2.document.Item` object' , function() {

				it( 'can get an Item object using a hash+range lookup' , function() {

					actual = service.getItem(
						table = "requestor",
						key = 'requestorId',
						value = '4313FAC4-64BD-4211-B964-456F109C2427',
						asStruct = false
					);

					debug( actual.toJsonPretty() );

					expect( actual.getClass().getName() ).toBe('com.amazonaws.services.dynamodbv2.document.Item');
					expect( actual.hasAttribute('requestorId') ).toBeTrue();
				});

				it( 'returns an empty Item object for a nonexistant record' , function() {					
					actual = service.getItem(
						table = "requestor",
						key = 'requestorId',
						value = "testKey",
						asStruct = false
					);

					debug( actual.toJsonPretty() );

					expect( actual.getClass().getName() ).toBe('com.amazonaws.services.dynamodbv2.document.Item');
					expect( actual.hasAttribute('requestorId') ).toBeFalse();
				});

			});

			describe( 'putItem()' , function() {

				it( 'should store a new json document' , function() {

					var item = service.newItemFromMap( getMockRequestor() );

					service.putItem(table="requestor", item=item);

					// Look up the new json document
					actual = service.getItem(
						table = "requestor",
						key = 'requestorId',
						value = item.get("requestorId"),
						asStruct = false
					);

					//debug( actual.toJsonPretty() );

					expect( actual.getClass().getName() ).toBe('com.amazonaws.services.dynamodbv2.document.Item');
					expect( actual.hasAttribute('requestorId') ).toBeTrue();
					
					// Tear down the test requestor doc
					actual = service.deleteItem(
						table = "requestor",
						key = 'requestorId',
						value = item.get("requestorId")
					);

					//debug(actual.getDeleteItemResult().toString());

					expect( actual.getClass().getName() ).toBe('com.amazonaws.services.dynamodbv2.document.DeleteItemOutcome');
					expect( actual.getDeleteItemResult() ).notToBeNull();
					expect( actual.getDeleteItemResult().toString() ).toBe("{}");
				});

				it( 'should overwrite an existing json document' , function() {

					var item = service.newItemFromMap( getMockRequestor() );

					// Initial save
					service.putItem(table="requestor", item=item);

					// Look up the new json document
					actual = service.getItem(
						table = "requestor",
						key = 'requestorId',
						value = item.get("requestorId"),
						asStruct = false
					);

					expect( actual.getClass().getName() ).toBe('com.amazonaws.services.dynamodbv2.document.Item');
					expect( actual.hasAttribute('requestorId') ).toBeTrue();
					expect( actual.get('apiSecretKey') ).toBe("eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJtdnBpZCI6Ijc4IiwiaW50ZWdyYXRlZFBhcnRuZXJJZCI6MTYsImludGVncmF0ZWRQYXJ0bmVyIjoiSUNJTVMoVEVTVCkiLCJyZXF1ZXN0b3JJZCI6NTgxMzF9.D4V5PocBQgI7w0K3EdRpOW3TAUrlingciblcd2x5kh8");

					// Change the secret key and put the item again
					service.putItem(table="requestor", item=item.withString("apiSecretKey","My 2nd secret key"));

					// Look up the new json document
					actual = service.getItem(
						table = "requestor",
						key = 'requestorId',
						value = item.get("requestorId"),
						asStruct = false
					);

					expect( actual.getClass().getName() ).toBe('com.amazonaws.services.dynamodbv2.document.Item');
					expect( actual.hasAttribute('requestorId') ).toBeTrue();
					expect( actual.get('apiSecretKey') ).toBe("My 2nd secret key");
					
					// Tear down the test requestor doc
					actual = service.deleteItem(
						table = "requestor",
						key = 'requestorId',
						value = item.get("requestorId")
					);

					//debug(actual.getDeleteItemResult().toString());

					expect( actual.getClass().getName() ).toBe('com.amazonaws.services.dynamodbv2.document.DeleteItemOutcome');
					expect( actual.getDeleteItemResult() ).notToBeNull();
					expect( actual.getDeleteItemResult().toString() ).toBe("{}");
				});

			});

			describe( 'scan()' , function() {

				it( 'should retrieve all documents from a table' , function() {

					var item = service.newItemFromMap( getMockRequestor() );

					actual = service.scan(
						table="requestor"
						// filterExpression="##ip >= :interationPartner",
					);

					debug(actual);

					expect( actual ).toBeTypeOf("array");
					expect( actual.len() ).toBeGT(0);
				
				});

				xit( 'should retrieve all documents from a table matching a filter expression' , function() {

					actual = service.scan(
						table="requestor",
						filterExpression="##ip = :val",
						nameMap={
							"##ip": "integratedPartner"
						},
						valueMap={
							":val": {"S":"Jobvite"}
						}
					);

					debug(actual);

					expect( actual ).toBeTypeOf("array");
					expect( actual.len() ).toBeGT(0);
				
				});

			});
		});
	}

	private any function getMockRequestor()
	{
		var requestor = {
			requestorId: createGUID(),
			apiSecretKey: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJtdnBpZCI6Ijc4IiwiaW50ZWdyYXRlZFBhcnRuZXJJZCI6MTYsImludGVncmF0ZWRQYXJ0bmVyIjoiSUNJTVMoVEVTVCkiLCJyZXF1ZXN0b3JJZCI6NTgxMzF9.D4V5PocBQgI7w0K3EdRpOW3TAUrlingciblcd2x5kh8",						
			verocityMetadata: {
				mvpId: 75,
				requestorId: 1,				
				integratedPartnerId: 1,
				integratedPartner: "ICIMS"
			},
			partnerMetadata: {
				api: "partner_api_key",
				customerId: "6271",
				jobFields: "bgcpackagetype,jobtitle,field117848,recruiter,drugscreenpackage,billingcode,joblocation,field104813,field104813,field120800,field178463",				
				password: "V7WbUK78",
				personFields: "firstname,middlename,lastname,usssn,birthdate,email,addresses,education,drivinglicensestate,drivinglicensenumber,field174226",
				username: "deverusapiuser",
				mappings: [
					{
						fieldName: "person.field174226.value",
						verocityApiFieldName: "package.packageId"
					},
					{
						fieldName: "person.field174226",
						verocityApiFieldName: "package.packageName"
					},
					{
						entityFieldName: "job.field104813",
						verocityApiFieldName: "location.locationId"
					},
					{
						entityFieldName: "job.field104813.value",
						verocityApiFieldName: "location.locationId"
					}
				]
			},
			dateCreated: dateTimeFormat( now(), "yyyy-mm-dd hh:nn:ss")
		};

		return requestor;
	}
}
