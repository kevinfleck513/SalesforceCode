trigger OrderItemTrigger on OrderItem (before insert, before update, after insert, after update) {

    new OrderItemTriggerHandler().run();

}