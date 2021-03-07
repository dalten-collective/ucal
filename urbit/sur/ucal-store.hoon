/-  *hora, *ucal, ucal-timezone, *ucal-almanac, *resource
|%
::
::
+$  calendar-patch
  $:  =calendar-code
      title=(unit @t)
  ==
::
+$  event-patch
  $:  =calendar-code
      =event-code
      ::  fields of detail
      title=(unit title)
      desc=(unit (unit @t))
      loc=(unit (unit location))
      ::
      when=(unit moment)
      era=(unit (unit era))
      tzid=(unit tape)
  ==
::
+$  rsvp-change
  $:  =calendar-code
      =event-code
      who=@p
      :: if ~, then uninvite the @p
      status=(unit rsvp)
  ==
::
+$  permission-change
  $:  =calendar-code
      ::  %change with unit means revoke all permissions for the @p
      $%  [%change who=@p role=(unit calendar-role)]
          [%make-public ~]
          [%make-private ~]
      ==
  ==
::
+$  action
  $%  $:  %create-calendar
          title=@t
          :: should be used for testing only
          calendar-code=(unit calendar-code)
          permissions=calendar-permissions
      ==
      ::
      $:  %update-calendar
          patch=calendar-patch
      ==
      ::
      $:  %delete-calendar
          =calendar-code
      ==
      ::
      $:  %create-event
          =calendar-code
          ::  should be used for testing only
          event-code=(unit event-code)
          organizer=@p
          =detail
          when=moment
          era=(unit era)
          =invites
          tzid=tape
      ==
      ::
      $:  %update-event
          patch=event-patch
      ==
      ::
      :: - delete event
      $:  %delete-event
          =calendar-code
          =event-code
      ==
      :: - cancel event?
      :: - change rsvp
      $:  %change-rsvp
          =rsvp-change
      ==
      :: - import calendar from file
      $:  %import-from-ics
          =path
      ==
      ::
      $:  %change-permissions
          change=permission-change
      ==
  ==
::
::  $to-subscriber: sent to subscribers - union of initial
::  payload and periodic updates
::
+$  to-subscriber
  $:  =resource
      $%  [%initial =calendar events=(list event)]
          [%update =update]
      ==
  ==
::
::  $update: updates sent to subscribers
::
+$  update
  $%  [%calendar-changed =calendar-patch modify-time=@da]
      [%calendar-removed =calendar-code]
      [%event-added =event]
      [%event-changed =event-patch modify-time=@da]
      [%event-removed =calendar-code =event-code]
      [%rsvp-changed =rsvp-change]
      [%permissions-changed =calendar-code =calendar-permissions]
  ==
::  $invitation: sent to ships invited to a particular event. if the
::  event is changed, new invitations will be sent. rsvp-required should
::  be true if a new rsvp is needed (i.e. if the time has changed) - it
::  should always be true on the initial invitation.
::
+$  invitation
  $:  =event
      rsvp-required=flag
      ::  The invitation needs to specify the ship hosting the calendar.
      ::  This is because the event organizer isn't necessarily the host
      ::  and there's no guarantee that the invitee has access to the
      ::  calendar this event is on - that's because being invited to an
      ::  event on a calendar shouldn't give you any sort of access to
      ::  the rest of the calendar that you didn't already have.
      cal-host=@p
  ==
::  $invitation-reply: sent by ships who are invited to an event,
::  indicating whether they can attend or not.
::
+$  invitation-reply
  $:  status=rsvp
      =calendar-code
      =event-code
      ::  mug of the moment and era of the event this is a response to.
      ::  this is used by the host to determine if the reply is for the
      ::  latest version of the event. consider the following scenario.
      ::  1. ~sovmep invites ~marnus to an event.
      ::  2. ~marnus sends a reply indicating they can attend
      ::  3. while ~marnus's reply is in flight, ~sovmep updates
      ::     the time of the event, sending a new invitation to ~marnus
      ::  4. ~sovmep receives ~marnus's initial reply. ~sovmep needs
      ::     a way to know whether this reply is based on the most
      ::     recent version of the event - hence the mug.
      hash=@
  ==
--
