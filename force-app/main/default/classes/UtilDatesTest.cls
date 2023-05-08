@isTest
public class UtilDatesTest {
  @isTest
  static void areOverlappedShoulReturnTrue() {
    DateRange outOfOffice = new DateRange(
      Date.newInstance(2023, 5, 8),
      Date.newInstance(2023, 5, 10)
    );
    DateRange workingRange = new DateRange(
      Date.newInstance(2023, 5, 3),
      Date.newInstance(2023, 5, 8)
    );

    Boolean overlapped = UtilDates.areOverlapped(outOfOffice, workingRange);

    System.assertEquals(true, overlapped, 'Wrong answer');
  }

  @isTest
  static void intersectionStartShoulReturn2023a5m8d() {
    DateRange outOfOffice = new DateRange(
      Date.newInstance(2023, 5, 8),
      Date.newInstance(2023, 5, 10)
    );
    DateRange workingRange = new DateRange(
      Date.newInstance(2023, 5, 3),
      Date.newInstance(2023, 5, 8)
    );

    Date startDate = UtilDates.intersectionStart(outOfOffice, workingRange);

    System.assertEquals(Date.newInstance(2023, 5, 8), startDate, 'Wrong Date');
  }

  @isTest
  static void intersectionStartShoulReturn2023a5m9d() {
    DateRange outOfOffice = new DateRange(
      Date.newInstance(2023, 5, 8),
      Date.newInstance(2023, 5, 10)
    );
    DateRange workingRange = new DateRange(
      Date.newInstance(2023, 5, 9),
      Date.newInstance(2023, 5, 11)
    );

    Date startDate = UtilDates.intersectionStart(outOfOffice, workingRange);

    System.assertEquals(Date.newInstance(2023, 5, 9), startDate, 'Wrong Date');
  }

  @isTest
  static void intersectionStartShoulReturnNull() {
    DateRange outOfOffice = new DateRange(
      Date.newInstance(2023, 5, 8),
      Date.newInstance(2023, 5, 10)
    );
    DateRange workingRange = new DateRange(
      Date.newInstance(2023, 5, 11),
      Date.newInstance(2023, 5, 12)
    );

    Date startDate = UtilDates.intersectionStart(outOfOffice, workingRange);

    System.assertEquals(null, startDate, 'Wrong Date');
  }

  @isTest
  static void intersectionEndShoulReturn2023a5m10d() {
    DateRange outOfOffice = new DateRange(
      Date.newInstance(2023, 5, 8),
      Date.newInstance(2023, 5, 10)
    );
    DateRange workingRange = new DateRange(
      Date.newInstance(2023, 5, 9),
      Date.newInstance(2023, 5, 12)
    );

    Date endDate = UtilDates.intersectionEnd(outOfOffice, workingRange);

    System.assertEquals(Date.newInstance(2023, 5, 10), endDate, 'Wrong Date');
  }

  @isTest
  static void intersectionEndShoulReturn2023a5m11d() {
    DateRange outOfOffice = new DateRange(
      Date.newInstance(2023, 5, 8),
      Date.newInstance(2023, 5, 12)
    );
    DateRange workingRange = new DateRange(
      Date.newInstance(2023, 5, 9),
      Date.newInstance(2023, 5, 11)
    );

    Date endDate = UtilDates.intersectionEnd(outOfOffice, workingRange);

    System.assertEquals(Date.newInstance(2023, 5, 11), endDate, 'Wrong Date');
  }

  @isTest
  static void intersectionEndShoulReturnNull() {
    DateRange outOfOffice = new DateRange(
      Date.newInstance(2023, 5, 8),
      Date.newInstance(2023, 5, 10)
    );
    DateRange workingRange = new DateRange(
      Date.newInstance(2023, 5, 11),
      Date.newInstance(2023, 5, 12)
    );

    Date endDate = UtilDates.intersectionEnd(outOfOffice, workingRange);

    System.assertEquals(null, endDate, 'Wrong Date');
  }

  @isTest
  static void getIntersectionShouldReturnOneDayRange() {
    DateRange outOfOffice = new DateRange(
      Date.newInstance(2023, 5, 8),
      Date.newInstance(2023, 5, 10)
    );
    DateRange workingRange = new DateRange(
      Date.newInstance(2023, 5, 3),
      Date.newInstance(2023, 5, 8)
    );
    DateRange intersection = UtilDates.getIntersection(
      outOfOffice,
      workingRange
    );

    System.assertEquals(
      Date.newInstance(2023, 5, 8),
      intersection.getStartDate(),
      'Wrong Start Date'
    );

    System.assertEquals(
      Date.newInstance(2023, 5, 8),
      intersection.getEndDate(),
      'Wrong End Date'
    );
  }

  @isTest
  static void getIntersectionShouldReturnNull() {
    DateRange outOfOffice = new DateRange(
      Date.newInstance(2023, 5, 8),
      Date.newInstance(2023, 5, 10)
    );
    DateRange workingRange = new DateRange(
      Date.newInstance(2023, 5, 3),
      Date.newInstance(2023, 5, 6)
    );
    DateRange intersection = UtilDates.getIntersection(
      outOfOffice,
      workingRange
    );

    System.assertEquals(null, intersection.getStartDate(), 'Wrong Start Date');

    System.assertEquals(null, intersection.getEndDate(), 'Wrong End Date');
  }

  @isTest
  static void getPendingRangeShouldReturnOutOfOffice() {
    DateRange outOfOffice = new DateRange(
      Date.newInstance(2023, 5, 2),
      Date.newInstance(2023, 5, 5)
    );
    DateRange working = new DateRange(
      Date.newInstance(2023, 5, 2),
      Date.newInstance(2023, 5, 5)
    );

    DateRange pending = UtilDates.getPendingRange(outOfOffice, working);

    System.assertEquals(
      Date.newInstance(2023, 5, 2),
      pending.getStartDate(),
      'Wrong Start Date'
    );

    System.assertEquals(
      Date.newInstance(2023, 5, 5),
      pending.getEndDate(),
      'Wrong End Date'
    );
  }

  @isTest
  static void getPendingRangeShouldReturnWorkingRange() {
    DateRange outOfOffice = new DateRange(
      Date.newInstance(2023, 5, 1),
      Date.newInstance(2023, 5, 6)
    );
    DateRange working = new DateRange(
      Date.newInstance(2023, 5, 2),
      Date.newInstance(2023, 5, 5)
    );

    DateRange pending = UtilDates.getPendingRange(outOfOffice, working);

    System.assertEquals(
      Date.newInstance(2023, 5, 2),
      pending.getStartDate(),
      'Wrong Start Date'
    );

    System.assertEquals(
      Date.newInstance(2023, 5, 5),
      pending.getEndDate(),
      'Wrong End Date'
    );
  }

  @isTest
  static void getApprovedRangeShouldReturnOutOfOfficeRangeWhenNotOverlapping() {
    DateRange outOfOffice = new DateRange(
      Date.newInstance(2023, 5, 1),
      Date.newInstance(2023, 5, 6)
    );
    DateRange working = new DateRange(
      Date.newInstance(2023, 4, 25),
      Date.newInstance(2023, 4, 29)
    );

    List<DateRange> approved = UtilDates.getApprovedRanges(
      outOfOffice,
      working
    );

    System.assertEquals(1, approved.size(), 'Wrong list size');

    System.assertEquals(
      Date.newInstance(2023, 5, 1),
      approved.get(0).getStartDate(),
      'Wrong Start Date'
    );

    System.assertEquals(
      Date.newInstance(2023, 5, 6),
      approved.get(0).getEndDate(),
      'Wrong End Date'
    );
  }

  @isTest
  static void getApprovedRangeShouldReturnOutOfOfficeRangeLessOne() {
    DateRange outOfOffice = new DateRange('2023/5/1', '2023/5/6');
    DateRange workingOne = new DateRange('2023/4/28', '2023/5/1');

    List<DateRange> approved = UtilDates.getApprovedRanges(
      outOfOffice,
      workingOne
    );

    System.assertEquals(1, approved.size(), 'Wrong list size');

    System.assertEquals(
      Date.newInstance(2023, 5, 2),
      approved.get(0).getStartDate(),
      'Wrong Start Date'
    );

    System.assertEquals(
      Date.newInstance(2023, 5, 6),
      approved.get(0).getEndDate(),
      'Wrong End Date'
    );
  }

  @isTest
  static void getApprovedRangeShouldReturnEmptyList() {
    DateRange outOfOffice = new DateRange(
      Date.newInstance(2023, 5, 1),
      Date.newInstance(2023, 5, 6)
    );
    DateRange working = new DateRange(
      Date.newInstance(2023, 4, 28),
      Date.newInstance(2023, 5, 6)
    );

    List<DateRange> approved = UtilDates.getApprovedRanges(
      outOfOffice,
      working
    );

    System.assertEquals(0, approved.size(), 'Wrong list size');
  }

  @isTest
  static void getApprovedRangeShouldReturnTwoApprovedRanges() {
    DateRange outOfOffice = new DateRange(
      Date.newInstance(2023, 5, 1),
      Date.newInstance(2023, 5, 6)
    );
    DateRange working = new DateRange(
      Date.newInstance(2023, 5, 3),
      Date.newInstance(2023, 5, 5)
    );

    List<DateRange> approved = UtilDates.getApprovedRanges(
      outOfOffice,
      working
    );

    System.assertEquals(2, approved.size(), 'Wrong list size');

    System.assertEquals(
      Date.newInstance(2023, 5, 1),
      approved.get(0).getStartDate(),
      'Wrong Start Date first approved'
    );

    System.assertEquals(
      Date.newInstance(2023, 5, 2),
      approved.get(0).getEndDate(),
      'Wrong End Date first approved'
    );

    System.assertEquals(
      Date.newInstance(2023, 5, 6),
      approved.get(1).getStartDate(),
      'Wrong Start Date second approved'
    );

    System.assertEquals(
      Date.newInstance(2023, 5, 6),
      approved.get(1).getEndDate(),
      'Wrong End Date second approved'
    );
  }

  @isTest
  static void getApprovedRangeShouldReturnOutOfOfficeWhenWorkingsDoNotOverlapp() {
    DateRange workingOne = new DateRange('2023/4/15', '2023/4/20');

    DateRange outOfOffice = new DateRange('2023/5/1', '2023/5/6');

    DateRange workingTwo = new DateRange('2023/5/15', '2023/5/20');

    List<DateRange> approvedList = UtilDates.getApprovedRanges(
      outOfOffice,
      new List<DateRange>{ workingOne, workingTwo }
    );

    System.assertEquals(1, approvedList.size(), 'Wrong list size');

    System.assertEquals(
      Date.newInstance(2023, 5, 1),
      approvedList.get(0).getStartDate(),
      'Wrong Start Date first approved'
    );

    System.assertEquals(
      Date.newInstance(2023, 5, 6),
      approvedList.get(0).getEndDate(),
      'Wrong End Date first approved'
    );
  }

  @isTest
  static void getApprovedRangeShouldReturnTwoRangesWhenOneWorkingMiddleOverlapp() {
    DateRange workingOne = new DateRange('2023/4/15', '2023/4/20');

    DateRange outOfOffice = new DateRange('2023/5/1', '2023/5/6');

    DateRange workingTwo = new DateRange('2023/5/3', '2023/5/5');

    List<DateRange> approvedList = UtilDates.getApprovedRanges(
      outOfOffice,
      new List<DateRange>{ workingOne, workingTwo }
    );

    System.assertEquals(2, approvedList.size(), 'Wrong list size');

    System.assertEquals(
      Date.newInstance(2023, 5, 1),
      approvedList.get(0).getStartDate(),
      'Wrong Start Date first approved'
    );
    System.assertEquals(
      Date.newInstance(2023, 5, 2),
      approvedList.get(0).getEndDate(),
      'Wrong End Date first approved'
    );

    System.assertEquals(
      Date.newInstance(2023, 5, 6),
      approvedList.get(1).getStartDate(),
      'Wrong Start Date second approved'
    );
    System.assertEquals(
      Date.newInstance(2023, 5, 6),
      approvedList.get(1).getEndDate(),
      'Wrong End Date secomd approved'
    );
  }

  @isTest
  static void getApprovedRangeShouldReturnEmptyListWhenWorkingsTotalOverlapp() {
    DateRange workingOne = new DateRange('2023/5/1', '2023/5/3');

    DateRange outOfOffice = new DateRange('2023/5/1', '2023/5/6');

    DateRange workingTwo = new DateRange('2023/5/4', '2023/5/9');

    List<DateRange> approvedList = UtilDates.getApprovedRanges(
      outOfOffice,
      new List<DateRange>{ workingOne, workingTwo }
    );

    System.assertEquals(0, approvedList.size(), 'Wrong list size');
  }

  @isTest
  static void getApprovedRangeShouldReturnOneWhenWorkingExtremeOverlapp() {
    DateRange workingOne = new DateRange('2023/5/1', '2023/5/3');

    DateRange outOfOffice = new DateRange('2023/5/3', '2023/5/6');

    DateRange workingTwo = new DateRange('2023/5/6', '2023/5/19');

    List<DateRange> approvedList = UtilDates.getApprovedRanges(
      outOfOffice,
      new List<DateRange>{ workingOne, workingTwo }
    );

    System.assertEquals(1, approvedList.size(), 'Wrong list size');
    System.assertEquals(
      Date.newInstance(2023, 5, 4),
      approvedList[0].getStartDate(),
      'Worng Start Date'
    );
    System.assertEquals(
      Date.newInstance(2023, 5, 5),
      approvedList[0].getEndDate(),
      'Worng End Date'
    );
  }
}
