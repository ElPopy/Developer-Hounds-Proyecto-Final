public with sharing class UtilDates {
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

  public static Boolean areOverlapped(DateRange rangeOne, DateRange rangeTwo) {
    if (
      rangeOne.getEndDate() >= rangeTwo.getStartDate() &&
      rangeOne.getStartDate() <= rangeTwo.getEndDate()
    ) {
      return true;
    }
    return false;
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
}
