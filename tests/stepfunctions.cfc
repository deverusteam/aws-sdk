component extends='testbox.system.BaseSpec' {

	function run() {

		describe( 'stepfunctions' , function() {

			beforeEach( function( currentSpec ) {
				service = new aws.stepfunctions(
					account = application.aws_settings.aws_accountid,
					secret = application.aws_settings.aws_secretkey
				);
			});

			it( 'extends aws' , function() {
				expect( service ).toBeInstanceOf('aws');
			});

			it( 'has a stepfunctions client stored' , function() {

				makePublic( service , 'getMyClient' , 'getMyClient' );

				actual = service.getMyClient();

				expect( actual.getClass().getName() ).toBe('com.amazonaws.services.stepfunctions.AWSStepFunctionsClient');

			});

			describe( 'startExecution()' , function() {

				it( 'returns expected response' , function() {
					payload = {
						reportID: 123,
						status: "Ordered"
					};

					actual = service.startExecution( 'arn:aws:states:us-east-1:430264674168:stateMachine:LambdaStateMachine', createUUID(), {who:'Micah Knox'} );
					//debug( actual );
					expect( actual.getClass().getName() ).toBe('com.amazonaws.services.stepfunctions.model.StartExecutionResult');
					expect( actual.getExecutionARN() ).toBeTypeOf('string');
					expect( actual.getStartDate() ).toBeTypeOf('time');

				});

			});

		});

	}

}
