public with sharing class OutRequestService {
  public static List<OutRequest> getOutRequests(
    OutRequest request,
    ProjectResource workPeriod
  ) {
    List<OutRequest> requestList = new List<OutRequest>();

    DateRange outRange = request.getDateRange();
    DateRange workRange = workPeriod.getDateRange();

    Boolean notOverlapped = !UtilDates.areOverlapped(outRange, workRange);

    if (notOverlapped) {
      OutRequest approved = createApprovedReq(
        request,
        workPeriod,
        request.getDateRange()
      );
      requestList.add(approved);
    } else {
      DateRange pendingRange = UtilDates.getPendingRange(outRange, workRange);
      OutRequest newRequest = createPendingReq(
        request,
        workPeriod,
        pendingRange
      );
      requestList.add(newRequest);
    }

    return requestList;
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
    ProjectResource workPeriod,
    DateRange range
  ) {
    OutRequest newRequest = fromRequest.clone();
    newRequest.setResourceId(workPeriod.getResourceId());
    newRequest.setStartDate(range.getStartDate());
    newRequest.setEndDate(range.getEndDate());
    newRequest.setStatus(OutRequest.APPROVED);
    return newRequest;
  }
}
