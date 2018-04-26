component extends='testbox.system.BaseSpec' {

	function run() {

		describe( 'sns' , function() {

			beforeEach( function( currentSpec ) {
				service = new aws.sns(
					account = application.aws_settings.aws_accountid,
					secret = application.aws_settings.aws_secretkey,
					region = "us-east-1"
				);
			});

			it( 'extends aws' , function() {
				expect( service ).toBeInstanceOf('aws');
				var env = CreateObject( 'java' , 'java.lang.System' ).getenv();
				debug(server);
			});

			it( 'has a sns client stored' , function() {

				makePublic( service , 'getMyClient' , 'getMyClient' );

				actual = service.getMyClient();

				expect( actual.getClass().getName() ).toBe('com.amazonaws.services.sns.AmazonSNSClient');

			});

			describe( 'publish()' , function() {

				it( 'returns expected response' , function() {
					payload = {
						reportID: 123,
						status: "Ordered"
					};

					actual = service.publish( topicArn="arn:aws:sns:us-east-1:430264674168:test", message=serializeJSON(payload) );

					expect( actual.getClass().getName() ).toBe('com.amazonaws.services.sns.model.PublishResult');
					expect( actual.getMessageId() ).toBeTypeOf('string');

				});

			});

		});

	}

}
