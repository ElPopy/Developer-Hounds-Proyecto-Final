import { LightningElement, wire, api } from 'lwc';
import getResourcesWrapper from '@salesforce/apex/ResourceService.getResourcesWrapper';

export default class ResourceComponent extends LightningElement {
@api recordId;
resources;
error;
ListKeys=[];
ListUsers=[];
//

 


@wire(getResourcesWrapper, {projectId: '$recordId'})
wiredResources({ error, data }) {
    if (data) {
        //console.log('data: ' + JSON.stringify(data));
        this.resources = data.resources;
        this.SetUSerFromResource( this.resources);
        this.ListKeys=Object.keys(this.resources);
       // console.log('resourcessssssssssssssssssssssssssssssssss: ' + JSON.stringify(this.resources));
       console.log('este es mi listKeys' + this.ListKeys);
    } else if (error) {
        this.error = error;
    }
}

SetUSerFromResource(resources)
{
    //cargar los usuarios que vienen de this.resources a ListUsers para poder iterarlos en el html y separarlos por roles
    for (var key in resources) {
        if (resources.hasOwnProperty(key)) {
            for (var i = 0; i < resources[key].length; i++) {
                this.ListUsers.push(resources[key][i]);
            }
        }
}

    /*for(resource in resources)
    {
        for(user of resource)
        {
            this.ListUsers.push(user);
        }
    }*/
}


}