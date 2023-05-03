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
}
