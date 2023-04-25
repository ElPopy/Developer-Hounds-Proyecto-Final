import getAllocationData from "@salesforce/apex/ProjectService.getAllocationData";
import { LightningElement, api, wire } from "lwc";
/* incoming data const project = {
  projectId: "project001",
  projectLineItems: [
    {
      positionId: "position001",
      role: "Consultant",
      soldHoursToCover: 250,
      availableResource: [
        {
          id: "resource23",
          firstName: "Julian",
          lastName: "Vazquez",
          rateHour: 10
          //availableRange: 23 - 25  assignedHours: 22 - 25
        },
        {
          id: "resource22",
          firstName: "Maria",
          lastName: "Ramirez",
          rateHour: 12
        },
        {
          id: "resource21",
          firstName: "Rodrigo",
          lastName: "Gomez",
          rateHour: 9
        }
      ]
    },
    {
      positionId: "position002",
      role: "Developer",
      soldHoursToCover: 500,
      availableResource: [
        {
          id: "resource20",
          firstName: "Vinicius",
          lastName: "Alvareez",
          rateHour: 8
        },
        {
          id: "resource19",
          firstName: "Camila",
          lastName: "Dominguez",
          rateHour: 15
        }
      ]
    }
  ]
}; */
/* outcoming data const projectAllocations = {
  project001: {
    position001: [
      {
        resourceId: "resource23",
        startDate: "22/4/23",
        endDate: "25/4/23"
      }
    ],
    position002: [
      {
        resourceId: "resource20",
        startDate: "22/4/23",
        endDate: "23/4/23"
      },
      {
        resourceId: "resource19",
        startDate: "22/4/23",
        endDate: "27/4/23"
      }
    ]
  }
}; */

export default class ResourceAllocationTable extends LightningElement {
  @api recordId;

  project;
  allocatedProjectResources = {};

  addResource(positionId, resourceList) {
    this.allocatedProjectResources[positionId] = resourceList;

    console.log(
      `allocationTable positionId: `,
      JSON.parse(JSON.stringify(this.allocatedProjectResources))
    );
  }

  handleAllocationChange(event) {
    const { id, resourceList } = event.detail;
    this.addResource(id, resourceList);
  }

  @wire(getAllocationData, { projectId: "$recordId" })
  wireAllocationData({ data, error }) {
    if (data) {
      this.parseWrapper(data);
      // console.log("resourceAllocation data: ", JSON.parse(data));
    } else if (error) {
      // console.log("resourceAllocation error: ", error);
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
