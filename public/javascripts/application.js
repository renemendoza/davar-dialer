$(document).ready(function(){
  $("table.main tbody tr:odd").addClass("odd");
  $('div#flash_notice').delay(500).fadeOut();
  $('div#flash_error').delay(1000).fadeOut();
});


function DialAttempt(contact_id) {
  this.contact_id = contact_id;
  this.contact_uri = "/contacts/dial/" + this.contact_id;
  this.auto_call = null;
  this.auto_call_base_uri = "/calls/";
  this.auto_call_uri = null;
  this.state = "idle"; 
  this.start();
}



DialAttempt.prototype = {

  "start": function() {
    $.ajax({
      url: this.contact_uri,
      dataType: "json",
      type: "GET",
      processData: false,
      contentType: "application/json",
      context: this,
      success: function(data) {
        
        this.auto_call = data["id"];
        this.auto_call_uri = this.auto_call_base_uri + this.auto_call;

        this.stateUpdate(data["state"]);


      },
      error:function(request, textStatus, errorThrown) {
        //actually we should send a flash.error div, not an alert
        alert("there has been an error");
      }
    });
  },

  "pollStart": function() {
    $(this).everyTime(1000, 'autoCallPoll', function() {
      this.poll();
    });
  },

  "poll": function() {
    $.ajax({
      url: this.auto_call_uri,
      dataType: "json",
      type: "GET",
      processData: false,
      contentType: "application/json",
      context: this,
      success: function(data) {
        this.stateUpdate(data["state"]);
      }
    });
  },

  "pollStop": function() {
    $(this).stopTime('autoCallPoll');
  },

  "stateUpdate": function(s) {

    //#maybe if this.state == s then is shouldnt do a darn thing 


    if ((this.state == "idle") && (s == "originate_attempt")) {
      $("h4#state").text("Attempting call");
      this.pollStart();
    }

    if ((this.state != "remote_end_answered") && (s == "remote_end_answered")) {
      $("h4#state").text("Remote end answered");
    }

    if ((this.state != "live") && (s == "live")) {
      $("h4#state").text("Call is live");
      $("div#dialer_panel img").fadeOut();
    }

    if (s == "finished") {
      this.pollStop();
      $("h4#state").text("Call has ended");
      $("div#wrapup_contact_form").removeClass("viz_hidden").fadeIn();
    }

    if (s == "finished_with_error") {
      this.pollStop();
      $("h4#state").text("Call attempt failed");
      //disable certain elements
      //should display an alert
      //show reason for error
      $("div#wrapup_contact_form").removeClass("viz_hidden").fadeIn();
    }
 
    this.state = s;
    window.dialAttemptState = s;
  }
};

function tab_handler(el, tabs) {
  var tabs = $.map( tabs, function (a) { return (a==el ? null : a); } );
  //remove other elements
  $.each(tabs, function(i,el) {
    element_tab = el + "_tab";
    $(element_tab).removeClass("clicked_tab");
    $(el).hide();
  }); 
  //show element
  element_tab = el + "_tab";
  $(element_tab).addClass("clicked_tab"); 
  $(el).show();
}

function tab_setup(el, tabs) {
  tab_handler(el, tabs);  //initial state

  $.each(tabs, function(i,el) {
    element_tab = el + "_tab";

    $(element_tab).bind('click', function () {
      tab_handler(el, tabs);
    });

  });
};


  /* 
   DIAL COMPONENT

   1) Display the dial panel
   2) Launch an initial request to get the originate ACTION ID 
   3) Initiate a series of Long Posts (polling initially to see updates)
          I would have a rack/metal silkwamic component to query Redis using the action ID
          Adhearsion would need to keep Redis up to date (first we use the DB)
   4) Change the UI according to a State Machine

    CALL STATE MACHINE
    ________________________________________________________________________________________________________
    |                 |                    |                    | POLL FOR           |  POLL FOR           |
    | EVENTS/STATES   |  IDLE              | ORIGINATE ATTEMPT  | SUCCESSFUL CONTACT |  CALL ENDING        |
    |_________________|____________________|____________________|____________________|_____________________|
    |  DIAL           | SHOW DIALER STATUS |                    |                    |                     |
    |                 | SHOW MASK          |                    |                    |                     |
    |                 | next state is      |                    |                    |                     |
    |                 | ORIGINATE ATTEMPT  |                    |                    |                     |
    |_________________|____________________|____________________|____________________|_____________________|
    | TELEPHONY ERROR |                    | DISPLAY ERROR      |                    |                     |
    |                 |                    | CLOSE DIALOG       |                    |                     |
    |                 |                    | next state is      |                    |                     |
    |                 |                    | IDLE               |                    |                     |
    |_________________|____________________|____________________|____________________|_____________________|
    | ORIGINATE       |                    | GET AMI ACTION ID  |                    |                     |
    | QUEUED          |                    | next state is      |                    |                     |
    |                 |                    | POLL FOR           |                    |                     |
    |                 |                    | SUCCESFULL CONTACT |                    |                     |
    |_________________|____________________|____________________|____________________|_____________________|
    | UNSUCCESSFUL    |                    |                    | DISPLAY RESULT     |                     |
    | CONTACT         |                    |                    | CLOSE DIALOG       |                     |
    |                 |                    |                    | next state is      |                     |
    |                 |                    |                    | IDLE               |                     |
    |_________________|____________________|____________________|____________________|_____________________|
    | SUCCESSFUL      |                    |                    | DISPLAY RESULT     |                     |
    | CONTACT         |                    |                    | DISPLAY CONTACT    |                     |
    |                 |                    |                    | INFO               |                     |
    |                 |                    |                    | next state is      |                     |
    |                 |                    |                    | POLL FOR           |                     |
    |                 |                    |                    | CALL ENDING        |                     |
    |_________________|____________________|____________________|____________________|_____________________|
    | CALL ENDS       |                    |                    |                    | SHOW CALL WRAPUP    |
    |                 |                    |                    |                    | DIALOG              |
    |                 |                    |                    |                    | PROMPT TO SCHEDULE  |
    |                 |                    |                    |                    | A CALLBACK          |
    |                 |                    |                    |                    | CLOSE DIALOG        |
    |                 |                    |                    |                    | next state is       |
    |                 |                    |                    |                    | IDLE                |
    |_________________|____________________|____________________|____________________|_____________________|

    STATE VARIABLES

    CONTACT_ID
    ORIGINATE_ACTION_ID
    CURRENT_STATE
    ?

  */

