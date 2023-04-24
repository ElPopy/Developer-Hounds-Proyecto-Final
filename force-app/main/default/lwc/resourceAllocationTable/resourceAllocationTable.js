import getAllocationData from "@salesforce/apex/ProjectService.getAllocationData";
import { LightningElement, api, wire } from "lwc";

const projectResourcesResult = {
  pli001: [
    {
      resourceId: "resource23",
      projectId: "project001",
      startDate: "22/4/23",
      endDate: "25/4/23"
    }
  ],
  pli002: [
    {
      resourceId: "resource20",
      projectId: "project001",
      startDate: "22/4/23",
      endDate: "23/4/23"
    },
    {
      resourceId: "resource19",
      projectId: "project001",
      startDate: "22/4/23",
      endDate: "27/4/23"
    }
  ]
};

export default class ResourceAllocationTable extends LightningElement {
  @api recordId;

  project;

  @wire(getAllocationData, { projectId: "$recordId" })
  wireAllocationData({ data, error }) {
    if (data) {
      this.parseWrapper(data);
      console.log("resourceAllocation data: ", JSON.parse(data));
    } else if (error) {
      console.log("resourceAllocation error: ", error);
    }
  }

  parseWrapper(data) {
    this.project = JSON.parse(data);
  }

  @api get positions() {
    if (this.project) {
      return this.project.projectLineItems;
    }
    return [];
  }
}
