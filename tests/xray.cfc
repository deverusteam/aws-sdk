component extends='testbox.system.BaseSpec' {

	function run() {

		describe( 'xray' , function() {

			beforeEach( function( currentSpec ) {
				service = new aws.xray();
			});

			it( 'extends aws' , function() {
				expect( service ).toBeInstanceOf('aws');
				var env = CreateObject( 'java' , 'java.lang.System' ).getenv();
				debug(server);
			});

			it( 'has an xray client stored' , function() {

				makePublic( service , 'getMyClient' , 'getMyClient' );

				actual = service.getMyClient();

				expect( actual.getClass().getName() ).toBe('com.amazonaws.services.xray.AWSXRayClient');

			});

			describe( 'putTraceSegments()' , function() {

				it( 'returns expected response' , function() {
					payload = {
						name: 123,
						id: "0f7caffc5721546ca7520c2670247a6c",
						trace_id: "1-58406520-a006649127e371903a2de979",
						start_time: "#dateConvert('local2utc', now())#",
						end_time: "#dateConvert('local2utc', now())#",
						in_progress: "false"
					};

					actual = service.putTraceSegments(serializeJSON(payload));

					expect( actual.getClass().getName() ).toBe('com.amazonaws.services.xray.model.PutTraceSegmentsResult');
					expect( actual.getMessageId() ).toBeTypeOf('string');

				});

			});

		});

	}

}