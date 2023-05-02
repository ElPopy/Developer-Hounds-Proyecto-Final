import { LightningElement, api } from "lwc";

export default class ProjectResource extends LightningElement {
  @api resource;

  allocation;

  start;
  end;

  startDate;
  endDate;

  handleChange(event) {
    this.allocation = {
      resourceId: this.resource.id,
      startDate: this.startDate,
      endDate: this.endDate
    };
    if (event.target.checked) {
      this.dispatchAddResource();
    } else {
      this.dispatchDeleteResource();
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
}

