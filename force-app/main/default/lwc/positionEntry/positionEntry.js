import { LightningElement, api } from "lwc";

export default class PositionEntry extends LightningElement {
  @api position;

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
    return this.position.soldHoursToCover;
  }
  @api get availableResource() {
    return this.position.availableResource;
  }
  @api get id() {
    return this.position.positionId;
  }
}
