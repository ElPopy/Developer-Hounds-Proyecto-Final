import allocateResources from "@salesforce/apex/ProjectService.allocateResources";
import getAllocationData from "@salesforce/apex/ProjectService.getAllocationData";
import { LightningElement, api, wire } from "lwc";
// incoming data
/* const project = {
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
// outcoming data
/* const allocations = {
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
}; */

export default class ResourceAllocationTable extends LightningElement {
  @api recordId;

  isLoading = true;
  isEnabled = false;

  project;
  allocationsByPosition = {};

  addResource(positionId, resourceList) {
    this.allocationsByPosition[positionId] = resourceList;

    console.log(
      `allocationTable positionId: `,
      JSON.parse(JSON.stringify(this.allocationsByPosition))
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
    this.setLoading(false);
  }

  handleClick() {
    this.sendAllocation();
  }

  sendAllocation() {
    this.setLoading(true);
    const allocationData = JSON.stringify(this.allocationsByPosition);
    allocateResources({ projectId: this.recordId, allocationData })
      .then((response) => this.handleResponse(response))
      .catch((error) => this.handleError(error))
      .finally(() => {
        this.setLoading(false);
        this.allocationsByPosition = {};
      });
  }

  handleResponse(response) {
    console.log("allocationTable response", JSON.parse(response));
  }

  handleError(error) {
    console.log("allocationTable error", JSON.parse(error));
  }

  @api get positions() {
    if (this.project) {
      return this.project.projectLineItems;
    }
    return [];
  }

  // @api get enabled() {
  //   return this.isEnabled;
  // }
  // set enabled(allocations) {
  //   for (const key in allocations) {
  //     if (Object.hasOwnProperty.call(allocations, key)) {
  //       const element = allocations[key];
  //     }
  //   }
  // }

  setLoading(state) {
    this.isLoading = state;
  }
}
