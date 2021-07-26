# GateGoat

Gate Goat is an event registration system for the SCA.  It allows people to register for events in advance using either their computer at home or their phone while in line, using only the information they would normally supply on the paper sign-in sheet.  No login is necessary, in order to make the system as accessible as possible.  Valid registrations are confirmed by physical membership cards.

Registrations can be validated on the backend by registered users of the system (as setup by an admin).  Once confirmed, people will pay as normal external to the system.

### User Roles

- Admins have full read/write access to all data
- Event Managers have access to their event + event schedule
- Users have access to user verification only

Gate Goat uses Guardian to manage authentication.  Users cannot self-register.  They have to be added by an admin.

### Scheduling

This is a trial feature that hasn't been used at an event yet.  It allows the event manager to add events and tracks changes.  Any changes to the event are displayed at the top of the schedule.

No more missing events because it was moved to the day prior and the only way to find out is to walk 20 minutes to information point!

### How to Run

- have Docker
- run script/dev_setup
- run script/dev_server
- visit localhost:4000

### Testing

There are tests.  Most of them were auto-generated.  I can't remember if they're passing or not.