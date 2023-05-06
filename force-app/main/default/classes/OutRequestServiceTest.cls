@isTest
public with sharing class OutRequestServiceTest {
  @isTest
  static void getOutRequestsShouldReturnOutRangeApprovedWhenNoWorkRange() {
    OutRequest request = new OutRequest();
    request.setName('name');
    request.setResourceId('resourceId001');
    request.setDescription('description');
    request.setStartDate(Date.newInstance(2023, 5, 1));
    request.setEndDate(Date.newInstance(2023, 5, 6));

    List<ProjectResource> workPeriodList = new List<ProjectResource>();

    List<OutRequest> requests = OutRequestService.getOutRequests(
      request,
      workPeriodList
    );

    System.assertEquals(1, requests.size(), 'Wrong list size');

    OutRequest actualReq = requests.get(0);
    System.assertEquals(
      Date.newInstance(2023, 5, 1),
      actualReq.getStartDate(),
      'Wrong Start Date'
    );
    System.assertEquals(
      Date.newInstance(2023, 5, 6),
      actualReq.getEndDate(),
      'Wrong End Date'
    );
    System.assertEquals(
      'resourceId001',
      actualReq.getResourceId(),
      'Wrong resource Id'
    );
    System.assertEquals(null, actualReq.getProjectId(), 'Wrong project Id');
    System.assertEquals(
      OutRequest.APPROVED,
      actualReq.getStatus(),
      'Wrong status'
    );
    System.assertEquals('name', actualReq.getName(), 'Wrong name');
    System.assertEquals(
      'description',
      actualReq.getDescription(),
      'Wrong description'
    );
  }

  @isTest
  static void getOutRequestsShouldReturnOutRangePendingWhenOneFullWorkRange() {
    OutRequest request = new OutRequest();
    request.setName('name');
    request.setResourceId('resourceId001');
    request.setDescription('description');
    request.setStartDate(Date.newInstance(2023, 5, 1));
    request.setEndDate(Date.newInstance(2023, 5, 6));

    ProjectResource workPeriod = new ProjectResource();
    workPeriod.setResourceId('resourceId001');
    workPeriod.setProjectId('projectId001');
    workPeriod.setStartDate(Date.newInstance(2023, 5, 1));
    workPeriod.setEndDate(Date.newInstance(2023, 5, 6));

    List<ProjectResource> workPeriodList = new List<ProjectResource>();
    workPeriodList.add(workPeriod);

    List<OutRequest> requests = OutRequestService.getOutRequests(
      request,
      workPeriodList
    );

    System.assertEquals(1, requests.size(), 'Wrong list size');

    OutRequest actualReq = requests.get(0);
    System.assertEquals(
      Date.newInstance(2023, 5, 1),
      actualReq.getStartDate(),
      'Wrong Start Date'
    );
    System.assertEquals(
      Date.newInstance(2023, 5, 6),
      actualReq.getEndDate(),
      'Wrong End Date'
    );
    System.assertEquals(
      'resourceId001',
      actualReq.getResourceId(),
      'Wrong resource Id'
    );
    System.assertEquals(
      'projectId001',
      actualReq.getProjectId(),
      'Wrong project Id'
    );
    System.assertEquals(
      OutRequest.PENDING,
      actualReq.getStatus(),
      'Wrong status'
    );
    System.assertEquals('name', actualReq.getName(), 'Wrong name');
    System.assertEquals(
      'description',
      actualReq.getDescription(),
      'Wrong description'
    );
  }

  @isTest
  static void getOutRequestsShouldReturnOneApprovedOnePendingWhenWorkIsInTheMiddle() {
    OutRequest request = new OutRequest();
    request.setName('name');
    request.setResourceId('resourceId001');
    request.setDescription('description');
    request.setStartDate(Date.newInstance(2023, 5, 1));
    request.setEndDate(Date.newInstance(2023, 5, 6));

    ProjectResource workPeriod = new ProjectResource();
    workPeriod.setResourceId('resourceId001');
    workPeriod.setProjectId('projectId001');
    workPeriod.setStartDate(Date.newInstance(2023, 5, 4));
    workPeriod.setEndDate(Date.newInstance(2023, 5, 12));

    List<ProjectResource> workPeriodList = new List<ProjectResource>();
    workPeriodList.add(workPeriod);

    List<OutRequest> requests = OutRequestService.getOutRequests(
      request,
      workPeriodList
    );

    System.assertEquals(2, requests.size(), 'Wrong list size');

    OutRequest actualReq = requests.get(0);
    System.assertEquals(
      Date.newInstance(2023, 5, 1),
      actualReq.getStartDate(),
      'Wrong Start Date'
    );
    System.assertEquals(
      Date.newInstance(2023, 5, 3),
      actualReq.getEndDate(),
      'Wrong End Date'
    );
    System.assertEquals(
      'resourceId001',
      actualReq.getResourceId(),
      'Wrong resource Id'
    );
    System.assertEquals(null, actualReq.getProjectId(), 'Wrong project Id');
    System.assertEquals(
      OutRequest.APPROVED,
      actualReq.getStatus(),
      'Wrong status'
    );
    System.assertEquals('name', actualReq.getName(), 'Wrong name');
    System.assertEquals(
      'description',
      actualReq.getDescription(),
      'Wrong description'
    );

    actualReq = requests.get(1);
    System.assertEquals(
      Date.newInstance(2023, 5, 4),
      actualReq.getStartDate(),
      'Wrong Start Date'
    );
    System.assertEquals(
      Date.newInstance(2023, 5, 6),
      actualReq.getEndDate(),
      'Wrong End Date'
    );
    System.assertEquals(
      'resourceId001',
      actualReq.getResourceId(),
      'Wrong resource Id'
    );
    System.assertEquals(
      'projectId001',
      actualReq.getProjectId(),
      'Wrong project Id'
    );
    System.assertEquals(
      OutRequest.PENDING,
      actualReq.getStatus(),
      'Wrong status'
    );
    System.assertEquals('name', actualReq.getName(), 'Wrong name');
    System.assertEquals(
      'description',
      actualReq.getDescription(),
      'Wrong description'
    );
  }
  // vacation         |--------|
  // project1  |------|
  // project2                  |-----|

  @isTest
  static void getOutRequestsShouldReturn1Approved2PendingForExtremWorkRange() {
    OutRequest request = new OutRequest();
    request.setName('name');
    request.setResourceId('resourceId001');
    request.setDescription('description');
    request.setStartDate(Date.newInstance(2023, 5, 5));
    request.setEndDate(Date.newInstance(2023, 5, 10));

    ProjectResource workPeriod = new ProjectResource();
    workPeriod.setResourceId('resourceId001');
    workPeriod.setProjectId('projectId001');
    workPeriod.setStartDate(Date.newInstance(2023, 5, 1));
    workPeriod.setEndDate(Date.newInstance(2023, 5, 5));

    ProjectResource otherWork = new ProjectResource();
    otherWork.setResourceId('resourceId001');
    otherWork.setProjectId('projectId002');
    otherWork.setStartDate(Date.newInstance(2023, 5, 10));
    otherWork.setEndDate(Date.newInstance(2023, 5, 15));

    List<ProjectResource> workPeriodList = new List<ProjectResource>();
    workPeriodList.add(workPeriod);
    workPeriodList.add(otherWork);

    List<OutRequest> requests = OutRequestService.getOutRequests(
      request,
      workPeriodList
    );

    System.assertEquals(3, requests.size(), 'Wrong list size');

    OutRequest actualReq = requests.get(0);
    System.assertEquals(
      Date.newInstance(2023, 5, 1),
      actualReq.getStartDate(),
      'Wrong Start Date'
    );
    System.assertEquals(
      Date.newInstance(2023, 5, 3),
      actualReq.getEndDate(),
      'Wrong End Date'
    );
    System.assertEquals(
      'resourceId001',
      actualReq.getResourceId(),
      'Wrong resource Id'
    );
    System.assertEquals(null, actualReq.getProjectId(), 'Wrong project Id');
    System.assertEquals(
      OutRequest.APPROVED,
      actualReq.getStatus(),
      'Wrong status'
    );
    System.assertEquals('name', actualReq.getName(), 'Wrong name');
    System.assertEquals(
      'description',
      actualReq.getDescription(),
      'Wrong description'
    );

    actualReq = requests.get(1);
    System.assertEquals(
      Date.newInstance(2023, 5, 4),
      actualReq.getStartDate(),
      'Wrong Start Date'
    );
    System.assertEquals(
      Date.newInstance(2023, 5, 7),
      actualReq.getEndDate(),
      'Wrong End Date'
    );
    System.assertEquals(
      'resourceId001',
      actualReq.getResourceId(),
      'Wrong resource Id'
    );
    System.assertEquals(
      'projectId001',
      actualReq.getProjectId(),
      'Wrong project Id'
    );
    System.assertEquals(
      OutRequest.PENDING,
      actualReq.getStatus(),
      'Wrong status'
    );
    System.assertEquals('name', actualReq.getName(), 'Wrong name');
    System.assertEquals(
      'description',
      actualReq.getDescription(),
      'Wrong description'
    );
  }
}
