import { LightningElement, api } from "lwc";

export default class ProjectResource extends LightningElement {
  @api resource;

  allocation;

  startD;
  endD;

  start;
  end;

  handleChange(event) {
    this.allocation = {
      resourceId: this.resource.id,
      startDate: this.start,
      endDate: this.end
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
    this.end = this.parseDate(event.target.value);
  }

  handleDate(event) {
    this.start = this.parseDate(event.target.value);
  }

  parseDate(frontFormat) {
    const dateData = frontFormat.split("-");

    const year = dateData[0];
    const month = dateData[1];
    const day = dateData[2];

    return [month, day, year].join("/");
  }
}
