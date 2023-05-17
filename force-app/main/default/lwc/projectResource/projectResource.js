import { LightningElement, api } from "lwc";

export default class ProjectResource extends LightningElement {
  @api resource;
  @api projectStart;
  @api projectEnd;

  allocation;

  start;
  end;

  startDate;
  endDate;

  dateDisable = false;
  checkResourceDisable = true;

  handleChange(event) {
    this.allocation = {
      resourceId: this.resource.id,
      startDate: this.startDate,
      endDate: this.endDate
    };
    if (event.target.checked) {
      this.dispatchAddResource();
      this.dateDisable = true;
    } else {
      this.dispatchDeleteResource();
      this.dateDisable = false;
    }
  }

  dispatchAddResource() {
    const addResource = new CustomEvent("addresorce", {
      detail: { allocation: this.allocation }
    });
    this.dispatchEvent(addResource);
  }

  dispatchDeleteResource() {
    const deleteResource = new CustomEvent("deleteresource", {
      detail: { allocation: this.allocation }
    });
    this.dispatchEvent(deleteResource);
  }

  @api get firstName() {
    return this.resource.firstName;
  }
  @api get lastName() {
    return this.resource.lastName;
  }
  @api get rateHour() {
    return this.resource.rateHour;
  }
  @api get projectStartDate() {
    return this.dateToFront(this.projectStart);
  }
  @api get projectEndDate() {
    return this.dateToFront(this.projectEnd);
  }
  @api get allocationStarts() {
    if (this.validStartDate(this.startDate)) {
      return this.dateToFront(this.startDate);
    }
    return this.dateToFront(this.projectStart);
  }
  @api get isCheckResourceDisable() {
    return this.checkResourceDisable;
  }

  handleEndDate(event) {
    const endDateValue = event.target.value;
    this.endDate = this.parseDate(endDateValue);
    this.end = endDateValue;
    if (this.datesAreInProjectRange()) {
      this.checkResourceDisable = false;
    } else {
      this.checkResourceDisable = true;
    }
  }

  handleStartDate(event) {
    const startDateValue = event.target.value;
    this.startDate = this.parseDate(startDateValue);
    this.start = startDateValue;
    if (this.datesAreInProjectRange()) {
      this.checkResourceDisable = false;
    } else {
      this.checkResourceDisable = true;
    }
  }

  datesAreInProjectRange() {
    return this.validStartDate(this.start) && this.validEndDate(this.end);
  }

  validEndDate(dateValue) {
    if (
      new Date(dateValue) >= new Date(this.allocationStarts) &&
      new Date(dateValue) <= new Date(this.projectEndDate)
    ) {
      return true;
    }
    return false;
  }

  validStartDate(dateValue) {
    if (
      new Date(dateValue) >= new Date(this.projectStartDate) &&
      new Date(dateValue) <= new Date(this.projectEndDate)
    ) {
      return true;
    }
    return false;
  }

  parseDate(frontFormat) {
    const dateData = frontFormat.split("-");

    const year = dateData[0];
    const month = dateData[1].padStart(2, 0);
    const day = dateData[2].padStart(2, 0);

    return [month, day, year].join("/");
  }

  dateToFront(date) {
    const dateData = date.split("/");

    const month = dateData[0].padStart(2, 0);
    const day = dateData[1].padStart(2, 0);
    const year = dateData[2];

    return [year, month, day].join("-");
  }
}

