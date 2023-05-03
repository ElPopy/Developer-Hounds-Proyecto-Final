public with sharing class DateRange {
  private Date startDate;
  private Date endDate;

  public DateRange() {
    this.startDate = null;
    this.endDate = null;
  }

  public DateRange(Date startDate, Date endDate) {
    this.startDate = startDate;
    this.endDate = endDate;
  }

  public Date getStartDate() {
    return this.startDate;
  }
  public Date getEndDate() {
    return this.endDate;
  }

  public void setStartDate(Date startDate) {
    this.startDate = startDate;
  }
  public void setEndDate(Date endDate) {
    this.endDate = endDate;
  }
}