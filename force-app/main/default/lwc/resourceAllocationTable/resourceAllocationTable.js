import { LightningElement, api } from "lwc";

const project = {
  projectId: "project001",
  projectLineItems: [
    {
      positionId: "pli001",
      role: "Consultant",
      soldHoursToCover: 250,
      availableResource: [
        {
          id: "resource23",
          firstName: "Julian",
          lastName: "Vazquez",
          rateHour: 10,
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
      positionId: "pli002",
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
};

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
  @api get positions() {
    return project.projectLineItems;
  }
}
