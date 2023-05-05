public with sharing class UtilDates {
  public static List<DateRange> getApprovedRanges(
    DateRange outOfOffice,
    DateRange working
  ) {
    List<DateRange> approvedRanges = new List<DateRange>();

    DateRange pending = getIntersection(outOfOffice, working);

    if (pending.isEmpty()) {
      approvedRanges.add(outOfOffice);
    }

    DateRange approvedStart = approvedStartRange(pending, outOfOffice);
    if (!approvedStart.isEmpty()) {
      approvedRanges.add(approvedStart);
    }

    DateRange approvedEnd = approvedEndRange(pending, outOfOffice);
    if (!approvedEnd.isEmpty()) {
      approvedRanges.add(approvedEnd);
    }

    return approvedRanges;
  }

  public static DateRange approvedStartRange(
    DateRange pending,
    DateRange outOfOffice
  ) {
    DateRange approved = new DateRange();

    if (pending.getStartDate() > outOfOffice.getStartDate()) {
      approved.setStartDate(outOfOffice.getStartDate());
      approved.setEndDate(pending.getStartDate() - 1);
    }

    return approved;
  }

  public static DateRange approvedEndRange(
    DateRange pending,
    DateRange outOfOffice
  ) {
    DateRange approved = new DateRange();

    if (pending.getEndDate() < outOfOffice.getEndDate()) {
      approved.setStartDate(pending.getEndDate() + 1);
      approved.setEndDate(outOfOffice.getEndDate());
    }

    return approved;
  }

  public static DateRange getPendingRange(
    DateRange outOfOffice,
    DateRange working
  ) {
    return getIntersection(outOfOffice, working);
  }

  public static DateRange getIntersection(
    DateRange rangeOne,
    DateRange rangeTwo
  ) {
    DateRange intersection = new DateRange(
      intersectionStart(rangeOne, rangeTwo),
      intersectionEnd(rangeOne, rangeTwo)
    );
    return intersection;
  }

  public static Date intersectionStart(DateRange rangeOne, DateRange rangeTwo) {
    Date startDate;

    if (areOverlapped(rangeOne, rangeTwo)) {
      if (rangeOne.getStartDate() >= rangeTwo.getStartDate()) {
        startDate = rangeOne.getStartDate();
      } else {
        startDate = rangeTwo.getStartDate();
      }
    }

    return startDate;
  }

  public static Date intersectionEnd(DateRange rangeOne, DateRange rangeTwo) {
    Date endDate;

    if (areOverlapped(rangeOne, rangeTwo)) {
      if (rangeOne.getEndDate() <= rangeTwo.getEndDate()) {
        endDate = rangeOne.getEndDate();
      } else {
        endDate = rangeTwo.getEndDate();
      }
    }

    return endDate;
  }

  public static Boolean areOverlapped(DateRange rangeOne, DateRange rangeTwo) {
    if (
      rangeOne.getEndDate() >= rangeTwo.getStartDate() &&
      rangeOne.getStartDate() <= rangeTwo.getEndDate()
    ) {
      return true;
    }
    return false;
  }
}
