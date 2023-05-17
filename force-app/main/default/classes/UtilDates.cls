public with sharing class UtilDates {
  public static List<DateRange> getApprovedRanges(
    DateRange outOfOffice,
    List<DateRange> workingRanges
  ) {
    List<DateRange> approvedRanges = new List<DateRange>();
    List<DateRange> pendingRanges = getPendingRanges(
      outOfOffice,
      workingRanges
    );
    if (pendingRanges.size() == 0) {
      approvedRanges.add(outOfOffice.clone());
    } else if (pendingRanges.size() == 1) {
      List<DateRange> approved = getApprovedRanges(
        outOfOffice,
        pendingRanges.get(0)
      );
      approvedRanges.addAll(approved);
    } else {
      List<DateRange> orderedPending = orderRanges(pendingRanges);
      List<DateRange> allApproved = approvedListForMultiPending(
        outOfOffice,
        orderedPending
      );
      approvedRanges.addAll(allApproved);
    }
    return approvedRanges;
  }

  public static List<DateRange> approvedListForMultiPending(
    DateRange outOfOffice,
    List<DateRange> orderedPending
  ) {
    List<DateRange> allApproved = new List<DateRange>();

    for (Integer index = 0; index < orderedPending.size(); index++) {
      Date startDate = startDateForSubOut(
        index,
        outOfOffice,
        orderedPending[index]
      );
      Date endDate = endDateForSub(index, outOfOffice, orderedPending);

      List<DateRange> approved = getApprovedRanges(
        new DateRange(startDate, endDate),
        orderedPending[index]
      );

      if (!approved.isEmpty()) {
        allApproved.addAll(approved);
      }
    }

    return allApproved;
  }

  public static Date startDateForSubOut(
    Integer index,
    DateRange outOfOffice,
    DateRange pending
  ) {
    Date startDate;
    if (index == 0) {
      startDate = outOfOffice.getStartDate();
    } else {
      startDate = pending.getStartDate();
    }
    return startDate;
  }

  public static Date endDateForSub(
    Integer index,
    DateRange outOfOffice,
    List<DateRange> orderedPending
  ) {
    Date endDate;
    if (index < orderedPending.size() - 1) {
      endDate = orderedPending[index + 1].getStartDate() - 1;
    } else {
      endDate = outOfOffice.getEndDate();
    }
    return endDate;
  }

  public static List<DateRange> orderRanges(List<DateRange> ranges) {
    for (Integer index = 0; index < ranges.size() - 1; index++) {
      for (Integer i = index + 1; i < ranges.size(); i++) {
        if (ranges[i].getStartDate() < ranges[index].getStartDate()) {
          DateRange min = ranges[i];
          ranges[i] = ranges[index];
          ranges[index] = min;
        }
      }
    }
    return ranges;
  }

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

  public static List<DateRange> getPendingRanges(
    DateRange outOfOffice,
    List<DateRange> workingRanges
  ) {
    List<DateRange> pendingRanges = new List<DateRange>();

    for (DateRange working : workingRanges) {
      DateRange pending = getPendingRange(outOfOffice, working);
      if (!pending.isEmpty()) {
        pendingRanges.add(pending);
      }
    }

    return pendingRanges;
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
