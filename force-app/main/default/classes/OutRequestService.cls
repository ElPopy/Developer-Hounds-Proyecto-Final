public with sharing class OutRequestService {
  @InvocableMethod(label='Create Out Of Office Requests')
  public static List<Results> createOutRequest(List<Requests> requestList) {
    List<Out_office_req__c> inputCollection = requestList[0].inputCollection;
    Out_office_req__c outRequest = inputCollection[0];

    List<Project_Resources__c> projects = [
      SELECT Resource__c, Project__c, Start_Date__c, End_Date__c
      FROM Project_Resources__c
      WHERE
        Resource__c = :outRequest.Resource__c
        AND End_Date__c >= :outRequest.Start_Date__c
        AND Start_Date__c <= :outRequest.End_Date__c
    ];

    OutRequestWithWorkList request = new OutRequestWithWorkList(
      outRequest,
      projects
    );

    List<OutRequest> outRequests = getOutRequests(
      request.getData(),
      request.getWorkPeriodList()
    );

    List<Out_office_req__c> outOffice = new List<Out_office_req__c>();
    for (OutRequest toParse : outRequests) {
      outOffice.add(parseRequest(toParse));
    }

    //Create a Results object to hold the return values
    Results response = new Results();
    //Add the return values to the Results object
    response.outputMember = outOffice;
    List<Results> responseWrapper = new List<Results>();
    responseWrapper.add(response);

    return responseWrapper;
  }

  public class Requests {
    @InvocableVariable(
      label='Records for Input'
      description='yourDescription'
      required=true
    )
    public List<Out_office_req__c> inputCollection;
  }

  public class Results {
    @InvocableVariable(
      label='Records for Output'
      description='yourDescription'
      required=true
    )
    public List<Out_office_req__c> outputMember;
  }

  public static Out_office_req__c parseRequest(OutRequest request) {
    Id resourceId;
    Id projectId;
    if (request.getResourceId() != null) {
      resourceId = (Id) request.getResourceId();
    }
    if (request.getProjectId() != null) {
      projectId = (Id) request.getProjectId();
    }
    return new Out_office_req__c(
      Resource__c = resourceId,
      Project__c = projectId,
      Name = request.getName(),
      Start_Date__c = request.getStartDate(),
      End_Date__c = request.getEndDate(),
      Description__c = request.getDescription(),
      Status__c = request.getStatus()
    );
  }

  public static List<OutRequest> getOutRequests(
    OutRequest request,
    List<ProjectResource> workPeriodList
  ) {
    List<OutRequest> requestList = new List<OutRequest>();

    if (workPeriodList.size() == 0) {
      requestList.add(createApprovedReq(request, request.getDateRange()));
    } else {
      addApprovedRanges(request, workPeriodList, requestList);

      for (ProjectResource workPeriod : workPeriodList) {
        addPendingRange(request, workPeriod, requestList);
      }
    }

    return requestList;
  }

  public static void addPendingRange(
    OutRequest request,
    ProjectResource workPeriod,
    List<OutRequest> requestList
  ) {
    DateRange outRange = request.getDateRange();
    DateRange workRange = workPeriod.getDateRange();

    DateRange pendingRange = UtilDates.getPendingRange(outRange, workRange);
    Boolean thereIsPendingRange = !pendingRange.isEmpty();
    if (thereIsPendingRange) {
      OutRequest newRequest = createPendingReq(
        request,
        workPeriod,
        pendingRange
      );
      requestList.add(newRequest);
    }
  }

  public static void addApprovedRanges(
    OutRequest request,
    List<ProjectResource> workPeriod,
    List<OutRequest> requestList
  ) {
    DateRange outRange = request.getDateRange();
    List<DateRange> workRangeList = new List<DateRange>();

    for (ProjectResource project : workPeriod) {
      DateRange workRange = project.getDateRange();
      workRangeList.add(workRange);
    }

    List<DateRange> approvedRanges = UtilDates.getApprovedRanges(
      outRange,
      workRangeList
    );

    for (DateRange approvedRange : approvedRanges) {
      OutRequest approved = createApprovedReq(request, approvedRange);
      requestList.add(approved);
    }
  }

  public static OutRequest createPendingReq(
    OutRequest fromRequest,
    ProjectResource workPeriod,
    DateRange range
  ) {
    OutRequest newRequest = fromRequest.clone();
    newRequest.setResourceId(workPeriod.getResourceId());
    newRequest.setProjectId(workPeriod.getProjectId());
    newRequest.setStartDate(range.getStartDate());
    newRequest.setEndDate(range.getEndDate());
    newRequest.setStatus(OutRequest.PENDING);
    return newRequest;
  }

  public static OutRequest createApprovedReq(
    OutRequest fromRequest,
    DateRange range
  ) {
    OutRequest newRequest = fromRequest.clone();
    newRequest.setStartDate(range.getStartDate());
    newRequest.setEndDate(range.getEndDate());
    newRequest.setStatus(OutRequest.APPROVED);
    return newRequest;
  }
}
