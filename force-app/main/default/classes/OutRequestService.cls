public with sharing class OutRequestService {
  public static List<OutRequest> getOutRequests(
    OutRequest request,
    List<ProjectResource> workPeriodList
  ) {
    List<OutRequest> requestList = new List<OutRequest>();

    if (workPeriodList.size() == 0) {
      requestList.add(createApprovedReq(request, request.getDateRange()));
    } else {
      for (ProjectResource workPeriod : workPeriodList) {
        addApprovedRanges(request, workPeriod, requestList);
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
    ProjectResource workPeriod,
    List<OutRequest> requestList
  ) {
    DateRange outRange = request.getDateRange();
    DateRange workRange = workPeriod.getDateRange();

    List<DateRange> approvedRanges = UtilDates.getApprovedRanges(
      outRange,
      workRange
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
