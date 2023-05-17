import { LightningElement, api } from "lwc";

export default class PositionEntry extends LightningElement {
  @api position;
  @api projectStart;
  @api projectEnd;

  allocatedResources = [];

  addResource(allocationToAdd) {
    this.allocatedResources.push(allocationToAdd);
    this.dispatchAllocationChange();
  }
  deleteResource(allocationToDelete) {
    this.allocatedResources = this.allocatedResources.filter(
      ({ resourceId }) => resourceId !== allocationToDelete.resourceId
    );
    this.dispatchAllocationChange();
  }

  handleAdd(event) {
    const { allocation } = event.detail;
    this.addResource(allocation);
    this.dispatchAllocationChange();
  }

  handleDelete(event) {
    const { allocation } = event.detail;
    this.deleteResource(allocation);
    this.dispatchAllocationChange();
  }

  dispatchAllocationChange() {
    const allocationChange = new CustomEvent("allocationchange", {
      detail: { id: this.id, resourceList: this.allocatedResources }
    });
    this.dispatchEvent(allocationChange);
  }

  @api get role() {
    return this.position.role;
  }
  @api get soldHoursToCover() {
    if (this.position.soldHoursToCover < 0) {
      return 0;
    }
    return this.position.soldHoursToCover;
  }
  @api get assignedHours() {
    return this.position.assignedHours;
  }
  @api get availableResource() {
    return this.position.availableResource;
  }
  @api get id() {
    return this.position.positionId;
  }
  @api get anyHoursLeftToCover() {
    if (this.soldHoursToCover === 0) {
      return false;
    }
    return true;
  }
  @api get allHoursCovered() {
    return !this.anyHoursLeftToCover;
  }
  @api get anyHoursButnoResourcesAvailables() {
    if (
      this.anyHoursLeftToCover &&
      this.position.availableResource.length === 0
    ) {
      return true;
    }
    return false;
  }
}
