public with sharing class OutRequest {
  public static final String APPROVED = 'Approved';
  public static final String PENDING = 'Pending Approval';
  public static final String REJECTED = 'Rejected';

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

  private String resourceId;
  private String projectId;
  private String name;
  private Date startDate;
  private Date endDate;
  private String description;
  private String status;

  public OutRequest() {
  }

  public OutRequest(Out_office_req__c request) {
    this.resourceId = request.Resource__c;
    this.projectId = request.Project__c;
    this.name = request.Name;
    this.startDate = request.Start_Date__c;
    this.endDate = request.End_Date__c;
    this.description = request.Description__c;
    this.status = request.Status__c;
  }

  public DateRange getDateRange() {
    return new DateRange(this.startDate, this.endDate);
  }

  public String getResourceId() {
    return resourceId;
  }

  public void setResourceId(String resourceId) {
    this.resourceId = resourceId;
  }

  public String getProjectId() {
    return projectId;
  }

  public void setProjectId(String projectId) {
    this.projectId = projectId;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public Date getStartDate() {
    return startDate;
  }

  public void setStartDate(Date startDate) {
    this.startDate = startDate;
  }

  public Date getEndDate() {
    return endDate;
  }

  public void setEndDate(Date endDate) {
    this.endDate = endDate;
  }

  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String status) {
    this.status = status;
  }
}
