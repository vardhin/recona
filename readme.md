event_bus.dart handles the event emitter and listener logic
event_service.dart registers what event is called upon what
handlers directory contains handles which have functions declared and defined, so upon an event with a name, a certain handler can be called to handle that event
events directory contain how these events and handlers must be utilized, it shows what parameters and requirements does a handler need upon the activation of an event
the utils directory contains the main backend logic and functions which would be imported in handlers