component extends='testbox.system.BaseSpec' {

	function run() {

		describe( 'lambda' , function() {

			beforeEach( function( currentSpec ) {
				service = new aws.lambda(
					account = application.aws_settings.aws_accountid,
					secret = application.aws_settings.aws_secretkey,
					region = "us-east-1"
				);
			});

			it( 'extends aws' , function() {

				expect( 
					service
				).toBeInstanceOf(
					'aws.aws'
				);

			});

			it( 'has a Lambda client stored' , function() {

				makePublic( service , 'getMyClient' , 'getMyClient' );

				actual = service.getMyClient();

				expect(
					actual.getClass().getName()
				).toBe(
					'com.amazonaws.services.lambda.AWSLambdaClient'
				);

			});

			describe( 'invoke()' , function() {

				it( 'returns expected response' , function() {

					payload = {
						"url": "http://google.com",
						"token": "asdf2rdg23r"
					};

					service.invoke( 
						method = "saveRedirectURL",
						payload = payload
					);

				});

			});

		});

	}

}
