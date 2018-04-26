component accessors=true extends='aws' {

	property name='myClient' type='com.amazonaws.services.xray.AWSXRayClient' getter=false setter=false;		

	public xray function init( string account = '',  string secret = '', string region = '')
	{

		super.init(argumentCollection = arguments);

		variables.myClient = CreateAWSObject( 'services.xray.AWSXRayClientBuilder' ).defaultClient();

		return this;
	}

	public any function batchGetTraces(string nextToken='', required string traceIds)
	{
		return getMyClient().batchGetTraces(arguments.nextToken, arguments.traceIds);
	}

	public any function getServiceGraph(required timestamp endTime, string nextToken='', required timestamp startTime)
	{
		return getMyClient().getServiceGraph(arguments.endTime, arguments.nextToken, arguments.startTime);
	}

	public any function getTraceGraph(string nextToken='', required string traceIds)
	{
		return getMyClient().getTraceGraph(arguments.nextToken, arguments.traceIds); //length constraint of traceIds is 35
	}

	public any function getTraceSummaries(required timestamp endTime, string filterExpression='', string nextToken='', boolean sampling=false, required timestamp startTime)
	{
		return getMyClient().getTraceSummaries(arguments.endTime, arguments.nextToken, arguments.startTime);
	}

	public any function putTelemetryRecords(string EC2InstanceId='', string hostName='', string resourceARN='', required array telemetryRecords)
	{
		return getMyClient().putTelemetryRecords(arguments.EC2InstanceId, arguments.hostName, arguments.resourceARN, arguments.telemetryRecords);
	}

	public any function putTraceSegments(required String traceSegmentDocuments)
	{
		var putTraceSegmentsRequest = CreateAWSObject( 'services.xray.model.PutTraceSegmentsRequest' ).init()
			.withTraceSegmentDocuments( arguments.traceSegmentDocuments, arguments.traceSegmentDocuments );

		return getMyClient().putTraceSegments(putTraceSegmentsRequest);
	}
}