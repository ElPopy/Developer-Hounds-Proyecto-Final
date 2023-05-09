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
  @api get allocationStart() {
    if (this.startDate) {
      return this.dateToFront(this.startDate);
    }
    return this.dateToFront(this.projectStart);
  }

  handleDateEnd(event) {
    this.endDate = this.parseDate(event.target.value);
  }

  handleDate(event) {
    this.startDate = this.parseDate(event.target.value);
  }

  parseDate(frontFormat) {
    const dateData = frontFormat.split("-");

    const year = dateData[0];
    const month = dateData[1];
    const day = dateData[2];

    return [month, day, year].join("/");
  }

  dateToFront(date) {
    const dateData = date.split("/");

    const month = dateData[0];
    const day = dateData[1];
    const year = dateData[2];

    return [year, month, day].join("-");
  }
}
