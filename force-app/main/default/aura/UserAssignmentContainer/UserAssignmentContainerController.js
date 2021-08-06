({
    doInit : function(component, event, helper) {

        let action = component.get('c.getOrderItems');
            action.setParams({
                orderId: component.get('v.recordId')
            });
            action.setCallback(this,$A.getCallback(function(response){
                let state = response.getState();
                if(state==='SUCCESS'){
                    console.log("data: "+ JSON.stringify(response.getReturnValue()));
                    component.set("v.orderItemData", response.getReturnValue());
                } else {            
                    console.log("error getting data: "+ response.getState());            
                    let errors = response.getError();
                    console.error(errors);
                }
            }));
            $A.enqueueAction(action);

    },

    closeQuickAction : function(component, event, helper){
        console.log('closing quick action');
        let dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },

    componentLoaded : function(component, event, helper){
        console.log('connecteCallback event caught');
        if(component.get('v.loaded')){
            component.set("v.loaded", true);
        }
        console.log('component.get(v.loaded): ' + component.get('v.loaded'));
    }
})