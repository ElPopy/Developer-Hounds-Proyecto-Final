import { LightningElement, api } from "lwc";

export default class ProjectResource extends LightningElement {
  @api resource;

  allocation;

  handleChange(event) {
    this.allocation = {
      resourceId: this.resource.id,
      startDate: "22/4/23",
      endDate: "27/4/23"
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
}
