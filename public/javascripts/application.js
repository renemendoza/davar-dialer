$(document).ready(function(){
  $("table.main tbody tr:odd").addClass("odd");
});




var viewModel = {};
viewModel.statusMessage = ko.observable(""); 
viewModel.callAttemptInProgress = ko.observable(false); 
viewModel.showContactInformation = ko.observable(true); 
viewModel.showScheduledTasks = ko.observable(false); 
viewModel.showNewScheduledTaskForm = ko.observable(false); 
viewModel.showCallHistory = ko.observable(false); 

//viewModel.showNotes = ko.observable(false); 

viewModel.UI = {};

viewModel.UI.mask = {

  "show": function() {
    div = $('div#mask').addClass("mask")
    div.css('width', screen.width); 
    div.css('height', screen.height); 
    $("div#mask").fadeIn('slow');
  },
  "hide": function() {
    $("div#mask").fadeOut('slow');
    div = $('div#mask').removeClass("mask")
    div.css('width', 0); 
    div.css('height', 0); 
  }


};

viewModel.UI.status_indicator = function(color, element_selector) {
  $(element_selector + " img").fadeOut().remove();

  path = "/images/phone_" + color + ".png";
  img = $('<img>').attr({ src : path })

  $(element_selector).append(img).fadeIn();
};


viewModel.UI.dial = function() {
  //viewModel.UI.mask.show();
  viewModel.statusMessage("Attempting call"); 
  viewModel.UI.status_indicator("gray", "div.remote_party");
};


viewModel.UI.contact_answered = function() {
  viewModel.statusMessage("Remote party answered..."); 
  viewModel.UI.status_indicator("green", "div.remote_party");
  viewModel.UI.status_indicator("gray", "div.local_party");
};

viewModel.UI.active_call = function() {
  viewModel.statusMessage("Call active"); 
  viewModel.UI.status_indicator("green", "div.local_party");
};

viewModel.UI.call_has_ended = function() {
  viewModel.statusMessage("Call has ended...."); 
  viewModel.UI.status_indicator("gray", "div.remote_party");
  viewModel.UI.status_indicator("gray", "div.local_party");
  viewModel.callAttemptInProgress(false); 
};

viewModel.UI.hangup = function() {
//    viewModel.UI.mask.hide();
    viewModel.statusMessage(""); 
};





viewModel.dial = function(contact_id) {

    this.callAttemptInProgress(true); 
    viewModel.originateAttempt(contact_id); 

};

viewModel.originateAttempt = function(contact_id) {
  uri = "/contacts/dial/" + contact_id;
  $.ajax({
    url: uri,
    dataType: "json",
    type: "GET",
    processData: false,
    contentType: "application/json",
    success: function(data) {
      viewModel.UI.dial(); 
      viewModel.pollSuccessfulContact(data["auto_call"]);
    }
  });
}

viewModel.callProgressControl = function(auto_call) {
  if (auto_call["hangup_at"] == null) {

    if ( (auto_call["result_leg_a"] == "answered") || (auto_call["leg_a_answered_at"] != null) ) {
      if ( (auto_call["result_leg_b"] == "answered") || (auto_call["leg_b_answered_at"] != null) ) {
        viewModel.UI.active_call(); 
      } else {
        viewModel.UI.contact_answered(); 
      }
    }
  } else {
    $(this).stopTime('successfulContact');
    viewModel.UI.call_has_ended(); 
    //CALL WRAPUP
    //SCHEDULE CALLBACK?
    //cleanup
  }


}


viewModel.callProgressUpdate = function(auto_call_id) {
// WE WANT TO USE LONG POLLING and OPTIMIZE USING CALLS TO REDIS / SILKWAMIK HERE
//uri = "/calls/progress/" + auto_call_id;  
  uri = "/calls/" + auto_call_id;   //rails-database based url
  $.ajax({
    url: uri,
    dataType: "json",
    type: "GET",
    processData: false,
    contentType: "application/json",
    success: function(data) {
      viewModel.callProgressControl(data["auto_call"]);
    }
  });
}

viewModel.pollSuccessfulContact = function(auto_call) {

  $(this).everyTime(1000, 'successfulContact', function() {
    this.callProgressUpdate(auto_call["id"]);
  });

}

viewModel.hangup = function() {
    this.callAttemptInProgress(false); 
    viewModel.UI.hangup();
};

// DE AQUI PARA ABAJO NECESITAMOS REFACTORAR

viewModel.toggleShowContactInformation = function() {
    this.showContactInformation(! this.showContactInformation() ); 
    $("#toggle_show_contact_information_link").toggleClass( "button_small_dark_gray" );
    $("#toggle_show_contact_information_link").toggleClass( "button_small_gray" );

    this.showScheduledTasks(false); 
    this.showCallHistory(false); 
};


viewModel.toggleShowScheduledTasks = function() {
    this.showScheduledTasks(! this.showScheduledTasks() ); 
    $("#toggle_show_scheduled_tasks_link").toggleClass( "button_small_dark_gray" );
    $("#toggle_show_scheduled_tasks_link").toggleClass( "button_small_gray" );
    this.showCallHistory(false); 
    this.showContactInformation(false); 
};

viewModel.newScheduledTask = function() {
    this.showNewScheduledTaskForm(! this.showNewScheduledTaskForm() ); 
    viewModel.UI.mask.show();
//    ko.observable(false); 
//    this.showNewScheduledTaskForm = ko.observable(false); 
}
viewModel.cancelScheduledTask = function() {
    viewModel.UI.mask.hide();
    this.showNewScheduledTaskForm(! this.showNewScheduledTaskForm() ); 
}


viewModel.toggleShowCallHistory = function() {
    this.showCallHistory(! this.showCallHistory() ); 
    $("#toggle_show_call_history_link").toggleClass( "button_small_dark_gray" );
    $("#toggle_show_call_history_link").toggleClass( "button_small_gray" );
    this.showContactInformation(false); 
    this.showScheduledTasks(false); 
};



// REFACTOR END



$(document).ready(function () {
 // $( "div#new_scheduled_task_form .date_picker" ).datepicker( { altField: '#scheduled_task_scheduled_at' } );
 $( "div#new_scheduled_task_form .date_picker" ).datetimepicker( { altField: '#scheduled_task_scheduled_at', showButtonPanel: false } );

  $('a#contact_sinformation_update_link').click(function() {
    $('form.edit_contact').submit();
  });
  $('a#schedule_task_save_link').click(function() {
    $('form.new_scheduled_task').submit();
//    $('form.new_scheduled_task').reset();
    viewModel.cancelScheduledTask();
  });
  ko.applyBindings(viewModel);
}); 



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

