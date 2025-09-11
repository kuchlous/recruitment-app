// Function used to find what status should be sent to the controllers
function findProperValueToBeDisplayed(value)
{
  if ( value == "Add Comment" )
  {
    return "Commented";
  }
  else if ( value == "Hold" )
  {
    return "Hold";
  }
  else if ( value == "Offered" )
  {
    return "Offered";
  }
  else if ( value == "Joining" )
  {
    return "Joining";
  }
  else if ( value == "Message" )
  {
    return "Message Sent";
  }
  else if ( value == "Status" )
  {
    return "Status Added";
  }
  else if ( value == "Declined" )
  {
    return "Declined";
  }
  else if ( value == "Forwarded" )
  {
    return "Forwarded";
  }
  else if ( value == "Manual Status" )
  {
    return "Manual status updated";
  }
  else
  {
    return value;
  }
}

// Function used to replace the last td of the "ajax_request_tr" row to the actiont taken(In bold)
// Used to remove the "ajax_request_tr" row as well.
function deleteAndCreateTDAfterAction(num_tds, value)
{
  // Replacing the last TD after finding the num_tds
  containing_tr.deleteCell(num_tds - 1);
  var cell       = containing_tr.insertCell(num_tds - 1);
  cell.innerHTML = value;
  cell.className = "cell_after_changing_status";

  // Removing the row.
  document.getElementById("ajax_request_tr").remove();
}

// Function used to change color of the current row(action taken row)
// Color would be changed to grey
function changeCurrentRowColor(tr)
{
  tr.style.backgroundColor = "#e6e6e6";
}
// Function used for deleting selected message
// Form will be posted to delete_selected_message in controller
function deleteSelectedMessage()
{
  setFormAction("delete_selected_message");
  document.form.submit();
}

// Function to set up the form action
function setFormAction(action)
{
  document.form.action = prepend_with_image_path + "/resumes/" + action;
  document.form.method = "post";
}

function createRadioBox(cell, name, id, value, is_selected)
{
  var element   = document.createElement("input");
  element.type  = "radio";
  element.name  = name;
  element.id    = id;
  element.value = value;
  if ( is_selected )
  {
    element.checked = true;
  }
  cell.appendChild(element);
}

function createLabel(cell, for_id, text) {
  var label = jQuery("<label>")
    .attr("for", for_id)
    .text(text);
  jQuery(cell).append(label);
}

function createHiddenElement(element, name, id, value)
{
  var input   = document.createElement("input");
  input.type  = "hidden";
  input.name  = name;
  input.id    = id;
  input.value = value;
  element.appendChild(input);
}

function createDropDownListNew(element, name, id, value, innerHTML, className) {
  var select = jQuery("<select>").addClass(className).attr("name", name).attr("id", id);
  for (i = 0; i < value.length; i++) {
    select.append(jQuery("<option>").attr("value", value[i]).html(innerHTML[i]));
  }
  jQuery(element).append(select);
}

function createDropDownList(element, name, id, value, innerHTML, className)
{
  var select       = document.createElement("select");
  select.name      = name;
  select.id        = id;
  select.className = className;
//  select.style.marginRight = "2px";

  for ( i = 0; i < value.length; i++)
  {
    option           = document.createElement("option");
    option.value     = value[i];
    option.innerHTML = innerHTML[i];
    select.appendChild(option);
  }
  element.appendChild(select);
  return select;
}

// Create link break elements "<br />"
function createLineBreakElement(element, num)
{
  var line_break_element   = document.createElement("span");
  if ( num == 3 )
  {
    line_break_element.innerHTML = "<br/> <br /> <br />";
  }
  else if ( num == 2 )
  {
    line_break_element.innerHTML = "<br/> <br />";
  }
  else
  {
    line_break_element.innerHTML = "<br />";
  }
  element.appendChild(line_break_element);
}

// hypen (-) separator between fields.
function createSpan(cell, isize)
{
  var span1         = document.createElement('span');
  span1.innerHTML   = "&nbsp;-&nbsp;";
  span1.style.fontSize = isize + "pt";
  cell.appendChild(span1);
}

// Function used to display the corresponding secondary actions when hover on particular link.
function showSecondaryActions(elementId)
{
  primaryActionIds = [ "messages_home", "misc_home" ];

  for (i = 0; i < primaryActionIds.length; i++)
  {
    elementIdToChange = primaryActionIds[i] + "_actions";
    linkElementIdToChange = primaryActionIds[i];
    element = document.getElementById(elementIdToChange);
    linkElement = document.getElementById(linkElementIdToChange);
    if ( primaryActionIds[i] == elementId )
    {
      if (element.style.visibility != "visible")
      {
        element.style.visibility = "visible";
        element.style.display = "inline";
        linkElement.style.borderWidth = "1px";
        linkElement.style.borderStyle = "solid";
        linkElement.style.borderColor = "#d8dcdf";
      }
    }
    else
    {
      if (element.style.visibility == "visible")
      {
        element.style.visibility = "hidden";
        element.style.display = "none";
        linkElement.style.border = "";
      }
    }
  }
}

// Contents on focus of an input field
// Used to toggling contents and color
function textBoxContentsOnFocus(id, elementType)
{
  var textBoxText;
  var theElement = document.getElementById(id);
  textBoxText = elementType;
  if ( theElement.value == textBoxText )
  { 
    theElement.value = '';
  }
  theElement.style.color = 'black';
}

// Contents on blur of an input field
// Used to toggling contents and color
function textBoxContentsOnBlur(id, elementType)
{
  var textBoxText;
  var theElement = document.getElementById(id);
  textBoxText = elementType;
  if (theElement.value == '') 
  { 
    theElement.value = textBoxText;
    theElement.style.color = '#A4A4A4'; 
  } 
  else 
  { 
    theElement.style.color = 'black'; 
  }
}

function createLastRow($row, req_match_id) {
  var $last_row = $('<tr>');
  $row.after($last_row);

  var $stage_cell = $('<td>');
  $last_row.append($stage_cell);
  var $screening_option = $('<input>').attr("type", "radio").attr("name", "interview_stage").attr("id", "interview_stage_screening").attr("value", "SCREENING");
  $stage_cell.append($screening_option);
  var $screening_label = $('<label>').attr("for", "interview_stage_screening").text("Screening");
  $stage_cell.append($screening_label);

  var $fullpanel_option = $('<input>').attr("type", "radio").attr("name", "interview_stage").attr("id", "interview_stage_fullpanel").attr("value", "FULLPANEL").attr("checked", true);
  $stage_cell.append($fullpanel_option);
  var $fullpanel_label = $('<label>').attr("for", "interview_stage_fullpanel").text("Full Panel");
  $stage_cell.append($fullpanel_label);


  var $type_cell = $('<td>');
  $last_row.append($type_cell);
  var $telephonic_option = $('<input>').attr("type", "radio").attr("name", "interview_type").attr("id", "interview_stage_telephonic").attr("value", "TELEPHONIC");
  $type_cell.append($telephonic_option);
  var $telephonic_label = $('<label>').attr("for", "interview_stage_telephonic").text("Telephonic");
  $type_cell.append($telephonic_label);

  var $facetoface_option = $('<input>').attr("type", "radio").attr("name", "interview_type").attr("id", "interview_stage_facetoface").attr("value", "FACETOFACE").attr("checked", true);
  $type_cell.append($facetoface_option);
  var $facetoface_label = $('<label>').attr("for", "interview_stage_facetoface").text("Face To Face");
  $type_cell.append($facetoface_label);

  var $hidden_element = $('<input>').attr("type", "hidden").attr("name", "req_match_id").attr("id", "req_match_id").attr("value", req_match_id);
  $last_row.append($hidden_element);

}   

function addInterviewRow(event, req_match_id, time_array)
{
  var $table = $("#manage_interviews_table");
  event.preventDefault();

  // Remove the row containing the clicked element
  var $add_row = $(event.target).closest("tr");
  $add_row.hide();
  // Insert new row after the "Add Interviews" row
  var $row = $('<tr>');
  $add_row.after($row);

  var $td = $('<td>');
  $row.append($td);
  var $employee_input = $('<input>').attr("name", "interview_employee_name").attr("type", "text").attr("id", "interview_employee_name").addClass('form-control employee-autocomplete').attr("placeholder", "Type employee name...");
  $td.append($employee_input);
  
  $td = $('<td>');
  $row.append($td);
  createDropDownListNew($td, "interview_level", "interview_level", [1, 2, 3], ['L1', 'L2', 'L3'], 'form-control select-box');
  
  $td = $('<td>');
  $row.append($td);
  var $date_input = $('<input>').attr("name", "interview_date").attr("type", "text").attr("id", "interview_date").addClass('form-control datepicker');
  $date_input.datepicker({
    dateFormat: 'dd-mm-yy',
    showOn: "focus",
  });
  $td.append($date_input);

  $td = $('<td>');
  $row.append($td);
  var $time_select = createDropDownListNew($td, "time_slot", "time_slot", time_array, time_array, "form-control select-box-small");
  $td.append($time_select);

  $td = $('<td>');
  $row.append($td);
  var $textarea = $('<textarea>').attr("name", "interview_focus").attr("id", "interview_focus").attr("class", "form-control focus_textarea");
  $textarea.value = "Enter focus";
  $textarea.on("focus",
    function(textarea) {
      textBoxContentsOnFocus(this.id, 'Enter focus');
    }
  );
  $textarea.on("blur",
    function(textarea) {
      textBoxContentsOnBlur(this.id, 'Enter focus');
    }
  );
  $td.append($textarea);

  $td = $('<td>');
  $row.append($td);
  var $submit = $('<input>').attr("type", "submit").attr("value", "GO").attr("class", "manage_interviews_cell_submit_button");
  $td.append($submit);

  
  // Initialize autocomplete for the employee input after it's added to DOM
  createEmployeeAutocomplete('#interview_employee_name');
  
  createLastRow($row, req_match_id);
}


// Provide links to create portal/agencies if they are not present in current database
function showReferrals(id_array, name_array, add_status_var)
{
  jQuery(".add_resume_field").remove();
  var referral_div = jQuery("<div>").addClass("add_resume_field").css("font-size", "8pt");

  // Element for drop down list of referrals
  // Should be agency/portals/employees
  var select = createDropDownListNew(referral_div, "resume[referral_id]", "", id_array, name_array, "form-control");

  // If correct referral is not in the list then HR can add another referral
  link      = document.createElement('a');
  if ( add_status_var == 1 )
  {
    link.setAttribute('href', prepend_with_image_path + '/portals/new');
    createLineBreakElement(link, 1);
    text_node = document.createTextNode('If panel is not in list. Add here');
  }
  else if ( add_status_var == 2 )
  {
    link.setAttribute('href', prepend_with_image_path + '/agencies/new');
    createLineBreakElement(link, 1);
    text_node = document.createTextNode('If agency is not in list. Add here');
  }
  else
  {
    createLineBreakElement(link, 1);
    text_node = document.createTextNode('\u00A0');
  }
  link.setAttribute('target', '_blank');
  link.appendChild(text_node);
  referral_div.append(link);

  var current_referral_div = jQuery("#current_referral");
  current_referral_div.append(referral_div);
}

// Removing links and drop down list for referrals in case we use the DIRECT referral type
function hideReferrals()
{
  var tr_element = document.getElementById("swap_td_for_referrals");
  tr_element.style.visibility = "hidden";
}

// Create the appropriate forms for actions based upon the value of drop down list
// This is for HR/ADMIN
function actionBox(value, event, req_id_array, req_name_array, req_match_id, resume_id)
{
  // Finding element where mouse(which td/tr) is clicked
  cur_element = event.target;
  if ( value == "Add Comment" )
  {
    // Show the add comment box
    showAddCommentBox(cur_element, resume_id);
  }
  else if ( value == "Forward to" )
  {
    // Show the forward to box
    showForwardBox(cur_element, req_name_array, req_id_array, resume_id);
  }
  else if ( value == "Message" )
  {
    // Show the message box
    showMessageBox(cur_element, resume_id);
  }
  else if ( value == "Interviews" )
  {
    // Show the links to interview
    getInterviews(cur_element, req_match_id);
  }
  else if ( value == "Set Status" )
  {
    // Show the add status box
    showAddStatusBox(cur_element, resume_id, req_match_id, "req_match_id");
  }
  else if ( value == "Reject" )
  {
    // Show the reject box
    showActionBoxReqMatchInternal(cur_element, req_match_id, "Reject", "req_match_id", 0);
  }
  else if ( value == "Shortlist" )
  {
    // Show the shortlist box
    forward_id = req_match_id;
    showShortlistBox(cur_element, forward_id, resume_id);
  }
  else if ( value == "Mark Hold" )
  {
    // Show the hold box
    showActionBoxReqMatchInternal(cur_element, req_match_id, "Hold", "req_match_id", 0);
  }
  else if ( value == "Mark Offered" )
  {
    // Show the offered box
    showActionBoxReqMatchInternal(cur_element, req_match_id, "Offered", "req_match_id", 0);
  }
  else if ( value == "Mark Joining" )
  {
    // Show the joining box
    showActionBoxReqMatchInternal(cur_element, req_match_id, "Joining", "req_match_id", 0);
  }
  else if (value == "Yet to Offer" )
  {
    // Show yet to offer box
    showActionBoxReqMatchInternal(cur_element, req_match_id, "YTO", "req_match_id", 0);
  }
  else if (value == "Engg Select" )
  {
    // Show yet to offer box
    showActionBoxReqMatchInternal(cur_element, req_match_id, "ENG_SELECT", "req_match_id", 0);
  }
  else if (value == "HAC" )
  {
    // Show yet to offer box
    showActionBoxReqMatchInternal(cur_element, req_match_id, "HAC", "req_match_id", 0);
  }
}

// Create the appropriate forms for actions based upon the value of drop down list
// This is for Manager
function actionBoxManager(value, event, req_id_array, req_name_array, req_match_id, resume_id, is_shortlist_page)
{
  if ( is_shortlist_page )
  {
    req_match_id_or_req_id = "req_match_id";
  }
  else
  {
    req_match_id_or_req_id = "req_ids";
  }

  // Finding element where mouse(which td/tr) is clicked
  cur_element = event.target;

  var selValue = new Array;

  // Finds the multiple drop down list
  // First find the table and then selects and then first select
  table   = cur_element.parentNode.parentNode;
  selects = table.getElementsByTagName('select');
  var status_selected_elem = selects[0];

  // Find number of options in drop down and iterate through them
  var num_of_options = status_selected_elem.length;

  var j = 0;
  for ( i = 0; i < num_of_options; i++ )
  {
    if (status_selected_elem[i].selected === true)
    {
      selValue[j] = status_selected_elem[i].value;
      j++;
     }
  }
  if(selValue.length >1 && value != "Shortlist"){
    alert ("Please select only one requirement!");
    return;
  }
  // Lastly, join the selected elements using comma
  selValue = selValue.join(",");

  if ( value == "Add Comment" )
  {
    // Show the add comment box
    showAddCommentBox(cur_element, resume_id);
  }
  else if ( value == "Forward to" )
  {
    // Show the forward to box
    showForwardBox(cur_element, req_name_array, req_id_array, resume_id);
  }
  else if ( value == "Message" )
  {
    // Show the message box
    showMessageBox(cur_element, resume_id);
  }
  else
  {
    if ( selValue )
    {
      if ( value == "Set Status" )
      {
        // Show the add status box
        showAddStatusBox(cur_element, resume_id, selValue, req_match_id_or_req_id);
      }
      else if ( value == "Reject" )
      {
        // Show the reject box
        showActionBoxReqMatchInternal(cur_element, selValue, "Reject", req_match_id_or_req_id, req_match_id);
      }
      else if ( value == "Shortlist" )
      {
        // Show the shortlist box
        forward_id = req_match_id;
        showShortlistBox(cur_element, forward_id, resume_id, selValue);
      }
      else if ( value == "Hold" )
      {
        // Show the hold box
        showActionBoxReqMatchInternal(cur_element, selValue, "Hold", req_match_id_or_req_id, req_match_id);
      }
      else if ( value == "Offer" )
      {
        // Show the offered box
        showActionBoxReqMatchInternal(cur_element, selValue, "Offered", req_match_id_or_req_id, req_match_id);
      }
      else if ( value == "Joining" )
      {
        // Show the joining box
        showActionBoxReqMatchInternal(cur_element, selValue, "Joining", req_match_id_or_req_id, req_match_id);
      }
      else if ( value == "Interviews" )
      {
        // Show the links to interview
        getInterviews(cur_element, req_match_id);
      }
      else if ( value == "YTO" )
      {
        // Show the YTO box
        showActionBoxReqMatchInternal(cur_element, selValue, "YTO", req_match_id_or_req_id, req_match_id);
      }
      else if ( value == "Engg Select" )
      {
        showActionBoxReqMatchInternal(cur_element, selValue, "ENG_SELECT", req_match_id_or_req_id, req_match_id);
      }
      else if ( value == "HAC" )
      {
        showActionBoxReqMatchInternal(cur_element, selValue, "HAC", req_match_id_or_req_id, req_match_id);
      }
    }
    else
    {
      // Creates the ajax row under the current element to display that you should have selected at least one requirement
      var elements = createRow(cur_element);

      // Close box link
      closeBoxLink(elements[0]);

      span = document.createElement('span');
      span.className = "span_with_13";
      span.style.fontWeight = "bold";
      span.innerHTML = "Please select one requirement";
      elements[0].appendChild(span);

    }
  }
}

function getInterviews(cur_element, req_match_id)
{
  $('#loader').show();
  var $table = $(cur_element).closest('table');
  var form = $(cur_element).closest('form');
  form.attr("action", prepend_with_image_path + "/resumes/add_interview");
  form.attr("method", "POST");

  $('#ajax_request_tr').remove();
  var $tr = $('<tr>').attr("id", "ajax_request_tr");
  $tr.append($('<td>').attr("colspan", $table.find("td").length));
  $(cur_element).closest('tr').after($tr);

  $.ajax({url: prepend_with_image_path + "/resumes/manage_interviews?req_match_id=" + req_match_id,
    type: 'POST',
    success: function(result) {
      $('#loader').hide();
    },
    error: function(err) {
      $('#loader').hide();
      alert("Server was down while performing this action. Please contact administrators.");
    }
  });
}

// Used to mark any reqmatch status as joining
function markJoining(match_id, resume_id, event)
{
  document.getElementById("loader").style.display="flex";
  // Finds joining date from the input box
  joining_date = document.getElementById("resume_joining_date" + match_id).value;
  if ( !joining_date )
  {
    alert("Please select joining date");
    return false;
  }
  // Creates Ajax request to mark req_match as joining
  jQuery.ajax(
    {
      url: prepend_with_image_path + '/resumes/mark_joining',
      data: 'match=' + match_id + '&resume_id=' + resume_id + '&joining_date=' + joining_date,
      type: 'POST',
      success: function (result) {
        document.getElementById("loader").style.display="none";
        replaceTDvalue(event, 2, "Joining date added");
      },
      error: function (err) {
        document.getElementById("loader").style.display="none";
        alert("Server was down while performing this action. Please contact administrators.");
      }
    }
  );
}

// Used to mark resume as not accepted
function markNotAccepted(resume_id, event)
{
  document.getElementById("loader").style.display="flex";
  jQuery.ajax({
    url:
      prepend_with_image_path + '/resumes/mark_not_accepted',
    data: 'resume_id=' + resume_id,
    type: 'POST',
    success: function (result) {
      document.getElementById("loader").style.display="none";
      replaceTDvalue(event, 1, "Not accepted");
    },
    error: function (err) {
      document.getElementById("loader").style.display="none";
      alert("Server was down while performing this action. Please contact administrators.");
    }
  }
  );
}

function showShortlistBox(cur_element, forward_id, resume_id, selValue)
{
  // Merge forward_id value with shortlist and then find it in createAjaxRequest()
  // Not a good solution but i do not want to pass another parameter to the function.
  action_merged_with_forward_id = "Shortlist" + forward_id;

  createAjaxRequest(cur_element, selValue, action_merged_with_forward_id, resume_id, "req_ids", forward_id);
}

function getJoiningDateBox(div_element)
{
  var input_element  = document.createElement("input");
  input_element.name = "joining_date";
  input_element.id   = "joining_date";
  div_element.appendChild(input_element);

  jQuery(function () {
    jQuery(input_element).datepicker({
      dateFormat: 'dd-mm-yy',
      showOn: "button",
      buttonImage: prepend_with_image_path + "/assets/calendar.gif",
      buttonImageOnly: true,
      buttonText: "Select date",
    }).next(".ui-datepicker-trigger").addClass("joining_date_image");
  });
}


// Get the autocomplete input text box which will be used for 
// autocompletion for the names of employees
// The names will come from file "jquery_autocomplete/localdata.js"
function getAutoCompleteTextBox(tdElement)
{
  var txtElement         = document.createElement("input");
  txtElement.type        = "text";
  txtElement.name        = "message_emp_name";
  txtElement.id          = "message_emp_name";
  txtElement.value       = "Enter employee name";
  txtElement.style.color = "#A4A4A4";
  txtElement.className   = "employee_name_text_field_in_message_box";
  txtElement.setAttribute("autocomplete", "off");

  // Change color on Onfocus of autocomplete input box
  jQuery(txtElement).bind("focus",
    function(txtElement)
    {
      textBoxContentsOnFocus(this.id, 'Enter employee name');
    }
  );

  // Change color on Onblur of autocomplete input box
   jQuery(txtElement).bind("blur",
    function(txtElement)
    {
      textBoxContentsOnBlur(this.id, 'Enter employee name');
    }
  );

  tdElement.appendChild(txtElement);
  createLineBreakElement(tdElement, 2);

  // Filling input box with employee names.
  // This function is lied in the file "jquery_autocomplete/test.js"
  // Need to be called for filling the input box with names
  fillInputBoxWithContents();
}

// Function to show add comment box
// Will replace the innerHTML of "ajax_request_tr" with the comment box
function showAddCommentBox(cur_element, resume_id)
{
  forward_id          = 0;
  value               = "Add Comment";
  createAjaxRequest(cur_element, forward_id, value, resume_id, "req_match_id", 0);
}

// Function to show add status box
// Will replace the innerHTML of "ajax_request_tr" with the status box
function showAddStatusBox(cur_element, resume_id, req_match_id, req_match_id_or_req_id)
{
  // Create "ajax_request_tr" row
  var elements = createRow(cur_element);
  
  // Close box link
  closeBoxLink(elements[0]);

  // Creating text area element
  createTextAreaElement(elements[0], "Set Status");

  // Creating an image inside the tr
  var element   = imageForGoIcon(-22, 70);

  // Onclick ajax request to add status to req_matches
  jQuery(element).bind("click",
    function(element)
    {
      document.getElementById("loader").style.display="flex";
      jQuery.ajax({
        url: prepend_with_image_path + "/resumes/add_interview_status_to_req_matches?resume_id=" + resume_id + "&" + req_match_id_or_req_id + "=" + req_match_id,
        data: 'resume[comment]=' + jQuery('#comment_textarea').val(),
        type: 'POST',
        success: function (result) {
          document.getElementById("loader").style.display="none";
          value = "Status";
          value = findProperValueToBeDisplayed(value);
          deleteAndCreateTDAfterAction(elements[2], value);
          changeCurrentRowColor(elements[3]);
        },
        error: function (err) {
          document.getElementById("loader").style.display="none";
          alert("There was some error while performing this action. Please check the name or try again later");
        }
      });
      return false;
    }
  );
  elements[0].appendChild(element);
}

function showEditJoiningBox(event, resume_id, req_match_id)
{
  event.preventDefault();

  // Finding element where mouse(which td/tr) is clicked
  cur_element = event.target;

  // Create "ajax_request_tr" row
  var elements = createRow(cur_element);

  // Close box link
  closeBoxLink(elements[0]);

  // Joining date box
  getJoiningDateBox(elements[0]);

  // Drop down list for statuses
  var value   = [ "SELECT", "JOINED", "NOT JOINED", "REJECTED", "FUTURE" ];
  var html    = [ "Select", "Joined", "Not Joined", "Rejected", "Future" ];
  var select  = createDropDownList(elements[0], "resume[status]", "resume_status", value, html, "");

  createLineBreakElement(elements[0], 3);
  // Creating text area element
  createTextAreaElement(elements[0], "edit joining date");

  // Creating an image inside the tr
  var element   = imageForGoIcon(10, 70);

  // Onclick ajax request to add status to req_matches
  jQuery(element).bind("click",
    function(element)
    {
      document.getElementById("loader").style.display="flex";
      jQuery.ajax({
        url: prepend_with_image_path + "/resumes/update_joining?resume_id=" + resume_id + "&req_match_id=" + req_match_id,
        data: 'resume[comment]=' + encodeURIComponent(jQuery('#comment_textarea').val()) + '&resume[joining_date]=' + jQuery('#joining_date').val() + '&resume[status]=' + jQuery('#resume_status').val(),
        type: 'POST',
        success: function (result) {
          document.getElementById("loader").style.display="none";
          value = "Action Taken"
          value = findProperValueToBeDisplayed(value);
          deleteAndCreateTDAfterAction(elements[2], value);
          changeCurrentRowColor(elements[3]);
        },
        error: function (err) {
          document.getElementById("loader").style.display="none";
          alert("There was some error while performing this action. Please check the name or try again later");
        }
      });
      return false;
    }
  );
  elements[0].appendChild(element);
}

function declineInterviewBox(event, interview_id)
{
  event.preventDefault();
  // Finding element where mouse(which td/tr) is clicked
  cur_element = event.target;
  
  // Create "ajax_request_tr" row
  var elements = createRow(cur_element);

  // Close box link
  closeBoxLink(elements[0]);

  // Creating text area element
  createTextAreaElement(elements[0], "decline interview");

  // Creating an image inside the tr
  var element   = imageForGoIcon(-22, 70);

  // Onclick ajax request to add status to req_matches
  jQuery(element).bind("click",
    function(element)
    {
      document.getElementById("loader").style.display="flex";
      jQuery.ajax({
        url: prepend_with_image_path + "/resumes/decline_interview?interview_id=" + interview_id,
        data: 'resume[comment]=' + jQuery('#comment_textarea').val(),
        type: 'POST',
        success: function (result) {
          document.getElementById("loader").style.display="none";
          value = "Declined";
          value = findProperValueToBeDisplayed(value);
          deleteAndCreateTDAfterAction(elements[2], value);
          changeCurrentRowColor(elements[3]);
        },
        error: function (err) {
          document.getElementById("loader").style.display="none";
          alert("There was some error while performing this action. Please check the name or try again later");
        }
      });
      return false;
    }
  );
  elements[0].appendChild(element);
}

function showMessageBoxAtTop(event, resume_id)
{
  cur_element = event.target;
  showMessageBox(cur_element, resume_id);
}

// Function to show add message box
// Will replace the innerHTML of "ajax_request_tr" with the message box
function showMessageBox(cur_element, resume_id)
{
  // Create "ajax_request_tr" row
  var elements = createRow(cur_element);

  // Close box link
  closeBoxLink(elements[0]);

  // Get autocomplete text box for employee names
  getAutoCompleteTextBox(elements[0]);

  // Creating text area element
  createTextAreaElement(elements[0], "Message");

  // Creating an image inside the tr
  var element   = imageForGoIcon(10, 70);

  // Onclick ajax request to send message
  jQuery(element).bind("click",
    function(element)
    {
      document.getElementById("loader").style.display="flex";
      jQuery.ajax({
        url: prepend_with_image_path + "/resumes/add_message?resume_id=" + resume_id + "&counter_value=0" + "&req_match=0",
        data: 'resume[comment]=' + jQuery('#comment_textarea').val() + "&employee_id=" + jQuery('#message_emp_name').val(),
        type: 'POST',
        success: function (result) {
          document.getElementById("loader").style.display="none";
          value = "Message";
          value = findProperValueToBeDisplayed(value);
          document.getElementById("ajax_request_tr").innerHTML = "";
          window.location.reload();
        },
        error: function (err) {
          document.getElementById("loader").style.display="none";
          alert("There was some error while performing this action. Please check the name or try again later");
        }
      });
      return false;
     }
  );
  elements[0].appendChild(element);
}

// =========Functions used for new_resumes page START========

// Function used to display the add comment box under current row
function AddCommentBox(event, resume_id)
{
  event.preventDefault();
  cur_element = event.target;
  showAddCommentBox(cur_element, resume_id);
}

// Function used to display the reject box under current row
function RejectBox(event, resume_id, action)
{
  event.preventDefault();
  cur_element  = event.target;
  req_match_id = 0;
  createAjaxRequest(cur_element, req_match_id, action, resume_id, "req_match_id", 0);
}

// Function used to display the forward box under current row
function ForwardBox(event, req_names, req_ids, resume_id)
{
  event.preventDefault();
  cur_element = event.target;
  showForwardBox(cur_element, req_names, req_ids, resume_id);
}
// =========Functions used for new_resumes page END========

// For reject/offer/joining/hold 
function showActionBoxReqMatchInternal(cur_element, req_match_id, action, req_match_id_or_req_id, forward_id)
{
  resume_id           = 0;
  createAjaxRequest(cur_element, req_match_id, action, resume_id, req_match_id_or_req_id, forward_id);
}

// Function used to show the forward to box filled with requirements
function showForwardBox(cur_element, req_names, req_ids, resume_id)
{
  // Creates the ajax row under the current element
  var elements = createRow(cur_element);

  // Close box link
  closeBoxLink(elements[0]);

  div             = document.createElement("div");
  div.className   = "multi_selected_qualification_with_no_border";
  div.style.width = "800px";
  table           = document.createElement("table");
  tr              = document.createElement("tr");
  count           = 0;

  // This code chunk is used to display four reqs in a line
  // and if there are more than 4 reqs then those will comes in
  // another line
  for ( i = 0; i < req_names.length; i++ )
  {
    if (count == 4)
    {
      table.appendChild(tr);
      tr    = document.createElement("tr");
      count = 0;
    }
    createRequirementsRow(tr, req_ids, req_names);
    count = count + 1;
  }
  table.appendChild(tr);
  div.appendChild(table);
  elements[0].appendChild(div);

  // Image for Go-Icon
  var link_element  = document.createElement("a");

  // Creating an image and append it to the td
  var img_element = imageForGoIcon(10, 0);
  img_element.style.paddingBottom = "10px";

  var req_details = document.getElementsByName("req_names[]");
  jQuery(link_element).bind("click",
    function(img_element)
    {
      document.getElementById("loader").style.display="flex";
      var selected_req_array   = new Array();
      var index                = 0;
      var display_value        = "Forwarded";
      for ( i = 0; i < req_details.length; i++) {
        if (req_details[i].checked) {
          ivalue = req_details[i].value;
          if ( ivalue != "undefined" ) {
            selected_req_array[index] = req_details[i].value;
            index = index + 1;
          }
        }
      }
      if ( selected_req_array.length == 0 ) {
        display_value = "Not Forwarded";
      }
      jQuery.ajax({
        url: prepend_with_image_path + "/resumes/create_multiple_forwards?" + "resume_id=" + resume_id + "&req_names=" + selected_req_array,
        type: 'POST',
        success: function (result) {
          document.getElementById("loader").style.display="none";
          value = findProperValueToBeDisplayed(display_value);
          deleteAndCreateTDAfterAction(elements[2], value);
          changeCurrentRowColor(elements[3]);
        },
        error: function (err) {
          document.getElementById("loader").style.display="none";
          alert("Server was down while performing this action. Please contact administrators.");
        }
      });
      return false;
    }
  );
  link_element.appendChild(img_element);
  elements[0].appendChild(link_element);
  containing_tr.after( elements[1]);
}

// This chunk of code will be used to display the req_names
// in forward to box
function createRequirementsRow(tr, req_ids, req_names)
{
  td   = document.createElement("td");
  div2 = document.createElement("div");
  div2.className = "one_element_div_qual_with_no_border";
  div2.id        = "one_element_div_qual_" + req_ids[i];
  var chk_input    = document.createElement("input");
  chk_input.type = "checkbox";
  chk_input.id = "qual_checkbox_" + req_ids[i];
  chk_input.name  = "req_names[]";
  chk_input.value = req_ids[i];
  div2.appendChild(chk_input);
  label         = document.createElement("label");
  label.htmlFor = "qual_checkbox_" + req_ids[i];
  if ( req_names[i] == "Select requirement" )
  {
    text = document.createTextNode("Select all reqs");
  }
  else
  {
    text = document.createTextNode(req_names[i].substring(0, 18));
  }
  label.appendChild(text);
  div2.appendChild(label);
  td.appendChild(div2);
  tr.appendChild(td);
}

// Function to be used by almost all actions
// Creates ajax request for reject/comment/hold/offered/joining etc
function createAjaxRequest(cur_element, req_match_id, value, resume_id, req_match_id_or_req_id, forward_id)
{
  // Defining variable for aligning of joining box propperly
  var join_align_var = 0;

  // Creates the ajax row under the current element
  var elements = createRow(cur_element);

  // Close box link
  closeBoxLink(elements[0]);

  if ( value == "Joining" )
  {
    getJoiningDateBox(elements[0]);
    join_align_var = 32;
    createLineBreakElement(elements[0], 3);
  }

  // Creating text area
  createTextAreaElement(elements[0], value);

  // Creating an image and append it to the td
  var element = imageForGoIcon(-22 + join_align_var, 70);

  // If action is joining then extra parameter(joining date) will be
  // added to parameters
  ids = req_match_id;

  // Onclick method for the image
  jQuery(element).bind("click",
    function(element)
    {
      document.getElementById("loader").style.display="flex";
  
      // If action is shortlist then we have to pass forward_id as well as req_ids
      // So i merged forward_id with "Shortlist" earlier. Now i am extracting forward_id
      if ( value.match("Shortlist") )
      {
        value      = "Shortlist";
      }
      url_params = '&forward_id=' + forward_id;

      // Earlier for joining condition, the same code was written seprately
      // So based updon value, finding joining date here only.
      // PROS: Helps in removing redundant code
      if ( value == "Joining" )
      {
        params = '&joining_date=' + jQuery('#joining_date').val();
        if (!jQuery('#joining_date').val() )
        {
          alert("Please select joining date first");
          document.getElementById("loader").style.display="none";
          return false;
        }
      }
      else
      {
        params = "";
      }
      jQuery.ajax({
        url: prepend_with_image_path + "/resumes/resume_action?" + req_match_id_or_req_id + "=" + ids + "&status=" + value + "&resume_id=" + resume_id + url_params,
        data: 'resume[comment]=' + encodeURIComponent(jQuery('#comment_textarea').val()) + params,
        type: 'POST',
        success: function (result) {
          document.getElementById("loader").style.display = "none";
          value = findProperValueToBeDisplayed(value);
          deleteAndCreateTDAfterAction(elements[2], value);
          changeCurrentRowColor(elements[3]);
        },
        error: function (err) {
          document.getElementById("loader").style.display = "none";
          console.log("from jquery");
          alert("Server was down while performing this action. Please contact administrators.");
        }
      });
      return false;
     }
  );
  elements[0].appendChild(element);
  containing_tr.after(elements[1]);
}

// Show the div
function showDiv(id)
{
  $('#'+id).show();
}


// Close Box link
// Will close the opened div when clicked on it.
function closeBoxLink(element)
{
  var span = document.createElement("span");
  span.className = "close_box_link";

  // Display the close box button.
  var img_element   = imageforCrossIcon();

  // Onclick event for img_element
  jQuery(img_element).bind("click",
    function(img_element)
    {
      element.remove();
    }
  );
  span.appendChild(img_element);
  element.appendChild(span);
}

// Deleting newly created row(ajax_request_tr) used by the 
// show comments and show feedbacks
function deleteAjaxRequestTr(element)
{
  document.getElementById(element).remove();
  total_interview_num = total_interview_num_bkup;
  index = 0;
}

// Creates a textarea element of specified parameters
function createTextAreaElement(element, value)
{
  // Creating comment's textarea inside show resumes comments div.
  var textarea         = document.createElement("textarea");
  textarea.value       = "Enter your comment and click on arrow to " + value.toLowerCase();
  textarea.name        = "resume[comment]";
  textarea.id          = "comment_textarea";
  textarea.className   = "comment_textarea";
//  textarea.style.clear = "both";
//  textarea.style.cssFloat = "left";
  textarea.rows           = "6";
  jQuery(textarea).bind("focus",
    function(textarea)
    {
      textBoxContentsOnFocus(this.id, 'Enter your comment and click on arrow to ' + value.toLowerCase());
    }
  );
  jQuery(textarea).bind("blur",
    function(textarea_element)
    {
      textBoxContentsOnBlur(this.id, 'Enter your comment and click on arrow to ' + value.toLowerCase());
    }
  );
  element.appendChild(textarea);
}

function replyToBox(event, message, parent_message, message_id)
{
  document.getElementById("loader").style.display="flex";
  // Finding element where mouse(which td/tr) is clicked
  cur_element = event.target;

  // Ajax request to set is_read of message to false
  jQuery.ajax({
    url: prepend_with_image_path + "/resumes/set_is_read?" + "message_id=" + message_id,
    type: 'POST',
    success: function (result) {
      document.getElementById("loader").style.display="none";
      cur_element.parentNode.style.fontWeight = "normal";
    },
    error: function (err) {
      document.getElementById("loader").style.display="none";
      alert("Server was down while performing this action. Please contact administrators.");
    }
  });

  // Setting form action
  setFormAction("reply_message");

  var elements = createRow(cur_element);

  // Close box link
  closeBoxLink(elements[0]);

  // Displays message inside a div
  var div       = document.createElement("div");
  div.className = "message_in_reply_to_div";
  var text_node     = document.createTextNode("MESSAGE:- " + message);
  div.appendChild(text_node);

  createLineBreakElement(div, 1);

  if (! (parent_message == message) )
  {
    var span                     = document.createElement("span");
    span.className               = "parent_message_color";
  
    // First text node for arrows to distinguish last message
    var parent_text_node1        = document.createTextNode(">>>>>>>>>");
    span.appendChild(parent_text_node1);
    createLineBreakElement(span, 1);
  
    // Second text node for last message for which reply had came
    var parent_text_node2        = document.createTextNode(parent_message);
    span.appendChild(parent_text_node2);
    createLineBreakElement(span, 1);
  
    // Third text node for arrows to distinguish last message
    var parent_text_node3        = document.createTextNode(">>>>>>>>>");
    span.appendChild(parent_text_node3);
  
    div.appendChild(span);
  }

  elements[0].appendChild(div);

  // Creating text area element
  createTextAreaElement(elements[0], "Message");

  // Creating an image inside show resumes comments div.
  var img_element   = imageForGoIcon(10, 70);
  img_element.style.marginBottom = "10px";
  jQuery(img_element).bind("click",
    function(img_element)
    {
      document.form.submit();
    }
  );
  elements[0].appendChild(img_element);

  // Create hidden element to pass message id
  createHiddenElement(elements[0], "message_id", "message_id", message_id);
}
function createRowNew(cur_element)
{
  // Remove existing ajax_request_tr if it exists
  $("#ajax_request_tr").remove();
  
  // Get the containing row and calculate number of columns
  var $containing_tr = $(cur_element).closest("tr");
  num_tds = $containing_tr.children("td").length;
  
  var $trElement = $("<tr>", {
    id: "ajax_request_tr"
  });
  
  var $tdElement = $("<td>", {
    colspan: num_tds
  });
  
  $trElement.append($tdElement);
  $containing_tr.after($trElement);

  return {tdElement: $tdElement[0], trElement: $trElement[0], num_tds: num_tds, containing_tr: $containing_tr[0] };
}

// Function used to create extra row after the current row.
// Wherever the mouse is clicked, the row will be created just after it
function createRow(cur_element,num_tds)
{
  old_tr              = document.getElementById("ajax_request_tr");
  if (old_tr)
  {
    old_tr.remove();
  }
  containing_tr       = cur_element.parentNode.parentNode;
  num_tds             = containing_tr.children.length;
  var trElement       = document.createElement("tr");
  trElement.id        = "ajax_request_tr";
  var tdElement       = document.createElement("td");
  tdElement.colSpan   = num_tds;
  trElement.appendChild(tdElement);
  containing_tr.after(trElement);

  // Way to return the multiple values in javascript
  return [ tdElement, trElement, num_tds, containing_tr ];
}

// Function used for displaying the Go-Icon
function imageForGoIcon(mright, mtop)
{
  var element                = document.createElement("img");
  element.src                = prepend_with_image_path + "/assets/GoIcon.gif";
  element.className          = "goto_image";
  element.style.marginRight  = mright + "px";
  element.style.marginTop    = mtop   - 2 + "px";

  return element;
}

// Function used for displaying the cross-mark image
function imageforCrossIcon()
{
  var img_element          = document.createElement("img");
  img_element.src          = prepend_with_image_path + "/assets/RedCross.png";
  img_element.className    = "cross_icon_image";

  return img_element;
}




function viewFeedback(event, resume_id, action, cols)
{
  document.getElementById("loader").style.display="flex";
  event.preventDefault();
  // TODO: We can removed this event(line) from this and next function as well as we do not need them anymore.

  // Finding element where mouse(which td/tr) is clicked
  cur_element = event.target;

  // Create "ajax_reuest_tr" Row
  var elements = createRowNew(cur_element);
  // Sending ajax request to get interviews
  // The interviews will replace innerHTML of the row created by createRowNew
  jQuery.ajax({
    url: prepend_with_image_path + "/resumes/" + action + "?resume_id=" + resume_id + "&columns=" + cols,
    type: 'POST',
    success: function (result) {
      document.getElementById("loader").style.display = "none";
    },
    error: function (err) {
      document.getElementById("loader").style.display="none";
      alert("Server was down while performing this action. Please contact administrators.");
    }
  });
}

// Basically we use this function to create/send feedback
function createFeedbackBox(event, interviewId, resumeId, req_name)
{
  event.preventDefault();
  setFormAction("feedback");

  cur_element = event.target;

  var elements = createRowNew(cur_element);

  // Close box link
  closeBoxLink(elements.tdElement);

  // Create ratings drop down list
  var ratings = [ "Select", "Poor", "Below Average", "Average", "Good", "Very Good" ];
  createDropDownListNew(elements.tdElement, "feedback[rating]", "feedback[rating]", ratings, ratings, "feedback_fields");

  createLineBreakElement(elements.tdElement, 2);

  // Create text area
  createTextAreaElement(elements.tdElement, "Add Feedback");

  // Image for go-icon
  var element   = imageForGoIcon(10, 64);

  // Onclick event for image element
  jQuery(element).bind("click",
    function(element)
    {
      document.form.submit();
    }
  );
  elements.tdElement.appendChild(element);

  // Pass resume id as hidden element
  createHiddenElement(elements.tdElement, "feedback[resume_id]", "feedback_resume_id", resumeId);
  createHiddenElement(elements.tdElement, "feedback[interview_id]", "feedback_interview_id", interviewId);
  createHiddenElement(elements.tdElement, "requirement_name",    "requirement_name",   req_name);
}

function closeShowCommentsBox(elementId)
{ 
  var elem = document.getElementById(elementId);
  elem.hide();
  if ( elem.hasChildNodes() )
  {     
    while ( elem.childNodes.length >= 1 )
    {
        elem.removeChild ( elem.firstChild );
    }
  }
}

function changeInterview(interview_id, index)
{
  document.getElementById("loader").style.display="flex";
  emp_id    = jQuery("#interview_employee_name" + index).val();
  int_time  = jQuery("#time_slot" + index).val();
  int_date  = jQuery("#interview_date" + index).val();
  int_focus = jQuery("#interview_focus" + index).val();
  interview_level = jQuery("#interview_level_" + index).val();
  // Construct URL with parameters
  var url = prepend_with_image_path + '/resumes/update_interview?' + 
    'interview_id=' + interview_id + 
    '&interview_employee_name=' + encodeURIComponent(emp_id) + 
    '&interview_time=' + encodeURIComponent(int_time) + 
    '&interview_date=' + encodeURIComponent(int_date) + 
    '&interview_focus=' + encodeURIComponent(int_focus) +
    '&interview_level=' + encodeURIComponent(interview_level);

  // Redirect to the constructed URL
  window.location.href = url;
  return false;
}

function showHide(elem)
{
  // TODO: Write code for toggling image as well when we click on link.
  //       Somehow elem.prev() is not working out otherwise it could have been as
  //       var image = elem.prev('img')
  var table = elem.next('table');
  if ( table.style.display == 'none' )
  {
    elem.src            = prepend_with_image_path + "/images/minusIcon.gif";
    table.style.display = '';
  }
  else
  {
    elem.src = prepend_with_image_path + "/images/plusIcon.gif";
    table.style.display = 'none';
  }
}

function replaceTDvalue(event, whichTD, value)
{
  // Finding element where mouse(which td/tr) is clicked
  cur_element   = event.target;
  containing_tr = cur_element.up('tr');
  num_tds       = containing_tr.childElements().length;
  // Replacing the last TD after finding the num_tds
  containing_tr.deleteCell(num_tds - whichTD);
  var cell       = containing_tr.insertCell(num_tds - whichTD);
  cell.innerHTML = value;
  cell.className = "cell_after_changing_status";
}

function openResumeInNewTab(resume_uniqid) {
  window.open ( prepend_with_image_path + "/resumes/show/" + resume_uniqid);
  return false;
}

// Function to show manual status box
// Will replace the innerHTML of "ajax_request_tr" with the manual status box
function showManualStatusBox(event, resume_id)
{
  event.preventDefault();

  // Finding element where mouse(which td/tr) is clicked
  cur_element = event.target;

  // Create "ajax_request_tr" row
  var elements = createRow(cur_element);
  
  // Close box link
  closeBoxLink(elements[0]);

  // Creating text area element
  createTextAreaElement(elements[0], "Set manual status");

  // Creating an image inside the tr
  var element   = imageForGoIcon(-22, 70);

  // Onclick ajax request to add status to req_matches
  jQuery(element).bind("click",
    function(element)
    {
      document.getElementById("loader").style.display="flex";
      jQuery.ajax({
        url: prepend_with_image_path + "/resumes/add_manual_status_to_resume?resume_id=" + resume_id,
        data: 'resume[comment]=' + jQuery('#comment_textarea').val(),
        type: 'POST',
        success: function (result) {
          document.getElementById("loader").style.display="none";
          value = "Manual Status";
          value = findProperValueToBeDisplayed(value);
          var textbox_value = jQuery('#comment_textarea').val();
          deleteAndCreateTDAfterAction(elements[2], value);
          changeCurrentRowColor(elements[3]);
          cur_element.innerHTML = textbox_value;
        },
        error: function (err) {
          document.getElementById("loader").style.display="none";
          alert("There was some error while performing this action. Please check the name or try again later");
        }
      });
      return false;
    }
  );
  elements[0].appendChild(element);
}

function get_image_name(likely_to_join) {
  var img_name = "";
  if (likely_to_join == "R") {
    img_name = "Red";
  } else if (likely_to_join == "G") {
    img_name = "Green";
  } else {
    img_name = "Orange";
  }
  return 'https://apps.mirafra.com/new-recruit/assets/' + img_name + '_Image.png';
}

function get_image_tag(likely_to_join, resume_id) {
  var $img = jQuery('<img/>').attr('src', get_image_name(likely_to_join)).click({resume_id : resume_id, likely_to_join: likely_to_join}, update_joining_status);
  return $img;
}

function show_current_joining_status(resume_id, likely_to_join) {
  var $cell = jQuery('#likely-to-join-' + resume_id);
  $cell.html("");
  var $img = jQuery('<img/>').attr('src', get_image_name(likely_to_join)).click({resume_id : resume_id}, show_all_images_for_likely_to_join);
  $cell.append($img);
}

function update_joining_status(event) {
  var resume_id = event.data.resume_id;
  var likely_to_join = event.data.likely_to_join;
  jQuery.ajax({
      url : prepend_with_image_path + "/resumes/update_resume_likely_to_join",
      data : {
        resume_id : resume_id,
        likely_to_join: likely_to_join
      },
      success : function (data) {
        show_current_joining_status(resume_id, likely_to_join);
        alert("Successfully updated status for resume");
      },
      failure : function (data) {
        alert("Server was down while performing this action. Please contact administrators.");
      }
    });
  return false;
}

// JQuery presents a different interface to callbacks, hence this wrapper.
function show_all_images_for_likely_to_join(event) {
  var resume_id = event.data.resume_id;
  showAllImagesForLikelyToJoin(event, resume_id);
}

function showAllImagesForLikelyToJoin(event, resume_id) {
  var $cell = jQuery('#likely-to-join-' + resume_id);
  $cell.html("");

  var imageTags = [ "R", "G", "O" ];

  for (i = 0; i < imageTags.length; i++) {
    var $img = get_image_tag(imageTags[i], resume_id);
    $cell.append($img);
  }
  return false;
}
