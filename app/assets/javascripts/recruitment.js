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
function deleteAndCreateTDAfterAction(value, containing_tr)
{
  var num_tds = containing_tr.cells.length;
  
  // Replacing the last td 
  containing_tr.deleteCell(num_tds - 1);
  var cell = containing_tr.insertCell(num_tds - 1);
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
  $stage_cell.attr("colspan", "3");
  $last_row.append($stage_cell);
  var $screening_option = $('<input>').attr("type", "radio").attr("name", "interview_stage").attr("id", "interview_stage_screening").attr("value", "SCREENING");
  $stage_cell.append($screening_option);
  var $screening_label = $('<label>').attr("for", "interview_stage_screening").text("Screening").addClass("radio-label-spaced");
  $stage_cell.append($screening_label);
  var $fullpanel_option = $('<input>').attr("type", "radio").attr("name", "interview_stage").attr("id", "interview_stage_fullpanel").attr("value", "FULLPANEL").attr("checked", true);
  $stage_cell.append($fullpanel_option);
  var $fullpanel_label = $('<label>').attr("for", "interview_stage_fullpanel").text("Full Panel").addClass("radio-label-spaced");
  $stage_cell.append($fullpanel_label);


  var $type_cell = $('<td>');
  $type_cell.attr("colspan", "5");
  $last_row.append($type_cell);
  var $facetoface_option = $('<input>').attr("type", "radio").attr("name", "interview_type").attr("id", "interview_stage_facetoface").attr("value", "FACETOFACE").attr("checked", true);
  $type_cell.append($facetoface_option);
  var $facetoface_label = $('<label>').attr("for", "interview_stage_facetoface").text("Face To Face").addClass("radio-label-spaced");
  
  $type_cell.append($facetoface_label);
  var $telephonic_option = $('<input>').attr("type", "radio").attr("name", "interview_type").attr("id", "interview_stage_telephonic").attr("value", "TELECONF");
  $type_cell.append($telephonic_option);
  var $telephonic_label = $('<label>').attr("for", "interview_stage_telephonic").text("Telephone Conf.").addClass("radio-label-spaced");
  $type_cell.append($telephonic_label);

  var $videoconf_option = $('<input>').attr("type", "radio").attr("name", "interview_type").attr("id", "interview_stage_videoconf").attr("value", "VIDEOCONF");
  $type_cell.append($videoconf_option);
  var $videoconf_label = $('<label>').attr("for", "interview_stage_videoconf").text("Video Conf.").addClass("radio-label-spaced");
  $type_cell.append($videoconf_label);

  var $telephone_option = $('<input>').attr("type", "radio").attr("name", "interview_type").attr("id", "interview_stage_telephone").attr("value", "TELEPHONE");
  $type_cell.append($telephone_option);
  var $telephone_label = $('<label>').attr("for", "interview_stage_telephone").text("Telephone").addClass("radio-label-spaced");
  $type_cell.append($telephone_label);

  var $hidden_element = $('<input>').attr("type", "hidden").attr("name", "req_match_id").attr("id", "req_match_id").attr("value", req_match_id);
  $last_row.append($hidden_element);

  // Add event listeners to radio buttons for office location toggle
  $last_row.find('input[name="interview_type"]').on('change', function() {
    var $row = $(this).closest('tr');
    toggleOfficeLocationField($row, $(this).val());
  });
  // Initially show office location for face-to-face (default selection)
  var defaultType = $last_row.find('input[name="interview_type"]:checked').val();
  toggleOfficeLocationField($last_row, defaultType);
}   

function addInterviewRow(event, req_match_id, time_array, feedback_form_ids, feedback_form_titles)
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
  var $date_input = $('<input>').attr("name", "interview_date").attr("autocomplete", "off").attr("type", "text").attr("id", "interview_date").addClass('form-control datepicker');
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
  var $duration_select = createDropDownListNew($td, "duration", "duration", [30, 45, 60, 90, 120], ['30 min', '45 min', '60 min', '90 min', '120 min'], "form-control select-box-small");
  $td.append($duration_select);

  $td = $('<td>');
  $row.append($td);
  var $office_location_select = $('<select>').attr("name", "officelocation_id").attr("id", "officelocation_id").addClass("form-control select-box-small office-location-select");
  $office_location_select.append($('<option>').attr("value", "").text("Select Office Location"));
  
  // Populate office locations from database
  if (typeof window.officeLocations !== 'undefined') {
    window.officeLocations.forEach(function(location) {
      $office_location_select.append($('<option>').attr("value", location[1]).text(location[0]));
    });
  }
  
  $td.append($office_location_select);
  // Initially show N/A (will be changed based on interview type)
  $office_location_select.hide();
  $td.append('<span class="text-muted">N/A</span>');

  $td = $('<td>');
  $row.append($td);
  // Create select with "No form_config" as first option
  var $title_select = $('<select>').attr("name", "interview_feedback_form").attr("id", "interview_feedback_form").addClass("form-control select-box-small");
  $title_select.append($('<option>').attr("value", "").text("No Template"));
  $title_select.append($('<option>').attr("value", "skills_based").text("Skills Based"));
  // Add form config options
  for (var i = 0; i < feedback_form_ids.length; i++) {
    $title_select.append($('<option>').attr("value", feedback_form_ids[i]).text(feedback_form_titles[i]));
  }
  $td.append($title_select);

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

// Function to toggle office location field visibility based on interview type
function toggleOfficeLocationField($row, interviewType) {
  // Find the previous row that contains the office location cell (interview data row)
  var $interviewDataRow = $row.prev('tr');
  var $officeLocationCell = $interviewDataRow.find('td').eq(5); // Office location is the 6th column (0-indexed)
  var $officeLocationSelect = $officeLocationCell.find('.office-location-select');
  
  if (interviewType === 'TELECONF' || interviewType === 'VIDEOCONF' || interviewType === 'TELEPHONE') {
    // Show N/A for non-face-to-face interviews
    $officeLocationCell.show();
    $officeLocationSelect.hide();
    if ($officeLocationCell.find('.text-muted').length === 0) {
      $officeLocationCell.append('<span class="text-muted">N/A</span>');
    }
  } else {
    // Show office location dropdown for face-to-face interviews
    $officeLocationCell.show();
    $officeLocationSelect.show();
    $officeLocationSelect.prop('disabled', false);
    $officeLocationCell.find('.text-muted').remove();
  }
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
function actionBox(value, event, req_match_id, resume_id)
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
    showForwardBox(cur_element, resume_id);
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
function actionBoxManager(value, event, req_match_id, resume_id, is_shortlist_page)
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
    showForwardBox(cur_element, resume_id);
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
      closeBoxLink(elements.tdElement);

      span = document.createElement('span');
      span.className = "span_with_13";
      span.style.fontWeight = "bold";
      span.innerHTML = "Please select one requirement";
      elements.tdElement.appendChild(span);

    }
  }
}

function getInterviews(cur_element, req_match_id)
{
  $('#loader').show();
  var $table = $(cur_element).closest('table');

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
  $(txtElement).bind("focus",
    function(txtElement)
    {
      textBoxContentsOnFocus(this.id, 'Enter employee name');
    }
  );

  // Change color on Onblur of autocomplete input box
  $(txtElement).bind("blur",
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
  closeBoxLink(elements.tdElement);

  // Creating text area element
  createTextAreaElement(elements.tdElement, "Set Status");

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
          deleteAndCreateTDAfterAction(value, elements.containing_tr);
          changeCurrentRowColor(elements.containing_tr);
        },
        error: function (err) {
          document.getElementById("loader").style.display="none";
          alert("There was some error while performing this action. Please check the name or try again later");
        }
      });
      return false;
    }
  );
  elements.tdElement.appendChild(element);
}

function showEditJoiningBox(event, resume_id, req_match_id)
{
  event.preventDefault();

  // Finding element where mouse(which td/tr) is clicked
  cur_element = event.target;

  // Create "ajax_request_tr" row
  var elements = createRow(cur_element);

  // Close box link
  closeBoxLink(elements.tdElement);

  // Joining date box
  getJoiningDateBox(elements.tdElement);

  // Drop down list for statuses
  var value   = [ "SELECT", "JOINED", "NOT JOINED", "REJECTED", "FUTURE" ];
  var html    = [ "Select", "Joined", "Not Joined", "Rejected", "Future" ];
  var select  = createDropDownList(elements.tdElement, "resume[status]", "resume_status", value, html, "");

  createLineBreakElement(elements.tdElement, 3);
  // Creating text area element
  createTextAreaElement(elements.tdElement, "edit joining date");

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
          deleteAndCreateTDAfterAction(value, elements.containing_tr);
          changeCurrentRowColor(elements.containing_tr);
        },
        error: function (err) {
          document.getElementById("loader").style.display="none";
          alert("There was some error while performing this action. Please check the name or try again later");
        }
      });
      return false;
    }
  );
  elements.tdElement.appendChild(element);
}

function declineInterviewBox(event, interview_id)
{
  event.preventDefault();
  // Finding element where mouse(which td/tr) is clicked
  cur_element = event.target;
  
  // Create "ajax_request_tr" row
  var elements = createRow(cur_element);

  // Close box link
  closeBoxLink(elements.tdElement);

  // Creating text area element
  createTextAreaElement(elements.tdElement, "decline interview");

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
          deleteAndCreateTDAfterAction(value, elements.containing_tr);
          changeCurrentRowColor(elements.containing_tr);
        },
        error: function (err) {
          document.getElementById("loader").style.display="none";
          alert("There was some error while performing this action. Please check the name or try again later");
        }
      });
      return false;
    }
  );
  elements.tdElement.appendChild(element);
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
  var elements = createRow(cur_element);

  // Close box link
  closeBoxLink(elements.tdElement);

  // Get autocomplete text box for employee names
  getAutoCompleteTextBox(elements.tdElement);

  // Creating text area element
  createTextAreaElement(elements.tdElement, "Message");

  // Creating an image inside the tr
  var go_icon   = imageForGoIcon(10, 70);

  // Onclick ajax request to send message
  $(go_icon).on("click",
    function()
    {
      document.getElementById("loader").style.display="flex";
      jQuery.ajax({
        url: prepend_with_image_path + "/resumes/add_message?resume_id=" + resume_id + "&counter_value=0" + "&req_match=0",
        data: 'resume[comment]=' + $('#comment_textarea').val() + "&employee_id=" + $('#message_emp_name').val(),
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
  elements.tdElement.appendChild(go_icon);
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
function ForwardBox(event, resume_id)
{
  event.preventDefault();
  cur_element = event.target;
  showForwardBox(cur_element, resume_id);
}
// =========Functions used for new_resumes page END========

// For reject/offer/joining/hold 
function showActionBoxReqMatchInternal(cur_element, req_match_id, action, req_match_id_or_req_id, forward_id)
{
  resume_id           = 0;
  createAjaxRequest(cur_element, req_match_id, action, resume_id, req_match_id_or_req_id, forward_id);
}

// Function used to show the forward to box filled with requirements
function showForwardBox(cur_element, resume_id)
{
  // Creates the ajax row under the current element
  var elements = createRow(cur_element);

  // Close box link
  closeBoxLink(elements.tdElement);

  div             = document.createElement("div");
  div.className   = "multi_selected_qualification_with_no_border";
  div.style.width = "800px";
  
  // Create text input for requirements autocomplete
  var input_div = document.createElement("div");
  input_div.style.marginBottom = "10px";
  
  var text_input = document.createElement("input");
  text_input.type = "text";
  text_input.id = "requirement_autocomplete_input";
  text_input.name = "requirement_names";
  text_input.className = "form-control requirements-autocomplete";
  text_input.placeholder = "Type requirement names to search...";
  text_input.style.width = "100%";
  text_input.setAttribute("data-autocomplete-url", prepend_with_image_path + "/requirements/autocomplete_requirements");
  
  // Store selected IDs (will be populated as user selects from autocomplete)
  text_input.setAttribute("data-selected-ids", JSON.stringify([]));
  
  input_div.appendChild(text_input);
  div.appendChild(input_div);
  elements.tdElement.appendChild(div);

  // Initialize autocomplete for the text input using existing function
  // We need to use a selector string, so we'll use the ID
  createCommaSeparatedAutocomplete('#' + text_input.id);

  // Image for Go-Icon
  var link_element  = document.createElement("a");

  // Creating an image and append it to the td
  var img_element = imageForGoIcon(10, 0);
  img_element.style.paddingBottom = "10px";

  $(link_element).on("click",
    function()
    {
      document.getElementById("loader").style.display="flex";
      // Get selected IDs directly from stored data
      let selected_req_ids = JSON.parse(text_input.getAttribute("data-selected-ids"));
      
      if (selected_req_ids.length === 0) {
        document.getElementById("loader").style.display="none";
        alert("Please select at least one requirement to forward the resume.");
        return false;
      }
      
      let url = prepend_with_image_path + "/resumes/create_multiple_forwards?";
      url += "resume_id=" + resume_id + "&req_ids=" + selected_req_ids;
      jQuery.ajax({
        url: url,
        type: 'POST',
        success: function (result) {
          document.getElementById("loader").style.display="none";
          deleteAndCreateTDAfterAction("Forwarded", elements.containing_tr);
          changeCurrentRowColor(elements.trElement);
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
  elements.tdElement.appendChild(link_element);
  elements.containing_tr.after(elements.trElement);
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
  closeBoxLink(elements.tdElement);

  if ( value == "Joining" )
  {
    getJoiningDateBox(elements.tdElement);
    join_align_var = 32;
    createLineBreakElement(elements.tdElement, 3);
  }

  // Creating text area
  createTextAreaElement(elements.tdElement, value);

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
          deleteAndCreateTDAfterAction(value, elements.containing_tr);
          changeCurrentRowColor(elements.containing_tr);
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
  elements.tdElement.appendChild(element);
  elements.containing_tr.after(elements.trElement);
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
  closeBoxLink(elements.tdElement);

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

  elements.tdElement.appendChild(div);

  // Creating text area element
  createTextAreaElement(elements.tdElement, "Message");

  // Creating an image inside show resumes comments div.
  var img_element   = imageForGoIcon(10, 70);
  img_element.style.marginBottom = "10px";
  jQuery(img_element).bind("click",
    function(img_element)
    {
      document.form.submit();
    }
  );
  elements.tdElement.appendChild(img_element);

  // Create hidden element to pass message id
  createHiddenElement(elements.tdElement, "message_id", "message_id", message_id);
}

function createRow(cur_element)
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

  return {tdElement: $tdElement[0], trElement: $trElement[0], containing_tr: $containing_tr[0] };
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
  var elements = createRow(cur_element);
  // Sending ajax request to get interviews
  // The interviews will replace innerHTML of the row created by createRow
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
  duration = jQuery("#duration" + index).val();
  officelocation_id = jQuery("#officelocation_id" + index).val();
  form_config_id = jQuery("#interview_feedback_form_" + index).val();
  // Construct URL with parameters
  var url = prepend_with_image_path + '/resumes/update_interview?' + 
    'interview_id=' + interview_id + 
    '&interview_employee_name=' + encodeURIComponent(emp_id) + 
    '&interview_time=' + encodeURIComponent(int_time) + 
    '&interview_date=' + encodeURIComponent(int_date) + 
    '&interview_focus=' + encodeURIComponent(int_focus) +
    '&interview_level=' + encodeURIComponent(interview_level) +
    '&duration=' + encodeURIComponent(duration) +
    '&officelocation_id=' + encodeURIComponent(officelocation_id) +
    '&interview_feedback_form=' + encodeURIComponent(form_config_id);

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
  var cur_element   = event.target;
  var containing_tr = cur_element.up('tr');
  var num_tds       = containing_tr.childElements().length;
  // Replacing the last TD after finding the num_tds
  containing_tr.deleteCell(num_tds - whichTD);
  var cell       = containing_tr.insertCell(num_tds - whichTD);
  cell.innerHTML = value;
  cell.className = "cell_after_changing_status";
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
  closeBoxLink(elements.tdElement);

  // Creating text area element
  createTextAreaElement(elements.tdElement, "Set manual status");

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
          deleteAndCreateTDAfterAction(value, elements.containing_tr);
          changeCurrentRowColor(elements.containing_tr);
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
  elements.tdElement.appendChild(element);
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

// Helper function to create comma-separated autocomplete with filtering
function createCommaSeparatedAutocomplete(selector, options) {
  var defaultOptions = {
    minLength: 0,
    delay: 300,
    autoFocus: true,
    position: { my: "left top", at: "left bottom", collision: "flip" }
  };
  
  var config = $.extend({}, defaultOptions, options);
  
  $(selector).autocomplete({
    source: function(request, response) {
      // Extract the current word being typed (after the last comma)
      var terms = request.term.split(',');
      var currentTerm = terms[terms.length - 1].trim();
      
      // Only proceed if current term has at least 2 characters
      if (currentTerm.length < 2) {
        response([]);
        return;
      }
      
      // Get all currently selected names (excluding the current term being typed)
      var selectedNames = [];
      if (terms.length > 1) {
        selectedNames = terms.slice(0, -1).map(function(name) {
          return name.trim();
        });
      }
      
      $.ajax({
        url: $(this.element).data('autocomplete-url'),
        dataType: 'json',
        data: {
          query: currentTerm
        },
        success: function(data) {
          // Process autocomplete data (all endpoints now return {id, name} objects)
          var processedData = data.map(function(item) {
            return { label: item.name, value: item.name, id: item.id };
          });
          
          // Filter out already selected names
          var filteredData = processedData.filter(function(item) {
            return selectedNames.indexOf(item.value) === -1;
          });
          response(filteredData);
        }
      });
    },
    minLength: config.minLength,
    delay: config.delay,
    autoFocus: config.autoFocus,
    position: config.position,
    select: function(event, ui) {
      // Get the current value and split by commas
      var terms = this.value.split(',');
      // Replace the last term with the selected value
      terms[terms.length - 1] = ui.item.value;
      // Join back with commas and update the field
      this.value = terms.join(', ');
      
      // Store the selected ID if available
      if (ui.item.id) {
        var selectedIds = JSON.parse(this.getAttribute("data-selected-ids") || "[]");
        selectedIds.push(ui.item.id);
        this.setAttribute("data-selected-ids", JSON.stringify(selectedIds));
      }
      
      return false; // Prevent default behavior
    }
  });
}

// for employees available in our database
function fillInputBoxWithContents()
{
  element = $("#message_emp_name");
  element.autocomplete({source: empNames["listedEmployees"]});
}

// Function to initialize all components
function initializeComponents() {
  console.log('Initializing components...');
  
  $('.hidden_by_default').hide();
  
  // Debug: Check if jQuery is loaded
  console.log('jQuery version:', $.fn.jquery);
  
  // Debug: Check if jQuery UI is loaded
  console.log('jQuery UI datepicker available:', typeof $.fn.datepicker);
  
  // Initialize datepicker for all elements with datepicker class
  $('.datepicker').datepicker({
    dateFormat: 'dd-mm-yy',
    showOn: "focus",
    buttonText: "Select date"
  });
  
  // Debug: Log datepicker elements
  console.log('Datepicker elements found:', $('.datepicker').length);
  
  // Debug: Test datepicker functionality
  $('.datepicker').on('focus', function() {
    console.log('Datepicker focused:', $(this).attr('id') || $(this).attr('name'));
  });
  
  // Initialize location autocomplete for both location and preferred location fields
  $('.location-autocomplete').autocomplete({
    source: function(request, response) {
      $.ajax({
        url: $(this.element).data('autocomplete-url'),
        dataType: 'json',
        data: {
          query: request.term
        },
        success: function(data) {
          // Process autocomplete data (endpoint returns {id, name} objects)
          var processedData = data.map(function(item) {
            return { label: item.name, value: item.name, id: item.id };
          });
          response(processedData);
        }
      });
    },
    minLength: 1,
    delay: 300,
    autoFocus: true,
    position: { my: "left top", at: "left bottom", collision: "flip" }
  });

  // Initialize comma-separated autocomplete fields using the helper function
  createCommaSeparatedAutocomplete('.eng-leads-autocomplete');
  createCommaSeparatedAutocomplete('.ta-leads-autocomplete');
  createCommaSeparatedAutocomplete('.requirements-autocomplete');
  createCommaSeparatedAutocomplete('.feedback-skills-autocomplete');

  // File upload label update
  $('.file-input').on('change', function() {
    var fileName = $(this).val().split('\\').pop();
    var label = $(this).siblings('.file-input-label');
    if (fileName) {
      label.find('span').text(fileName);
    } else {
      label.find('span').text('Choose File');
    }
  });

  // Initialize Bootstrap tooltips
  $('[data-toggle="tooltip"]').tooltip();
  
  // Initialize Bootstrap popovers with body container to avoid clipping
  $('[data-toggle="popover"]').popover({
    container: 'body',
    boundary: 'viewport'
  });
}

// Ensure jQuery is available as $ for our main code
jQuery(document).ready(function($) {
  console.log('jQuery noConflict ready fired');
  initializeComponents();
});

// Handle Turbolinks page loads
$(document).on('turbolinks:load', function() {
  console.log('Turbolinks load fired');
  initializeComponents();
});

function showEventDetails(event)
{
  $('#event_desc').html(event.description);
  $('#desc_dialog').dialog({
      title: event.title,
      width: 400,
      close: function(event, ui) { $('#desc_dialog').dialog('destroy') }
  });
}

function redirectToResumeDetails(path, event)
{
  window.open(path + "/resumes/show/" + event.resume_uniqid);
}

function show_column_for_date_when_resume_moved_to_joining()
{
  $('.hidden_by_default').toggle();
}

// Single-value autocomplete function for employee names
function createEmployeeAutocomplete(selector, options) {
  var defaultOptions = {
    minLength: 2,
    delay: 300,
    autoFocus: true,
    position: { my: "left top", at: "left bottom", collision: "flip" }
  };
  
  var config = $.extend({}, defaultOptions, options);
  
  $(selector).autocomplete({
    source: function(request, response) {
      $.ajax({
        url: prepend_with_image_path + '/employees/autocomplete_employees',
        dataType: 'json',
        data: {
          query: request.term
        },
        success: function(data) {
          // Process autocomplete data (endpoint now returns {id, name} objects)
          var processedData = data.map(function(item) {
            return { label: item.name, value: item.name, id: item.id };
          });
          response(processedData);
        }
      });
    },
    minLength: config.minLength,
    delay: config.delay,
    autoFocus: config.autoFocus,
    position: config.position
  });
}

// Bootstrap alert styled like alert_box with different types
function showBootstrapAlert(message, type) {
  // Remove any existing alerts and background shader
  jQuery('.bootstrap-alert, #background_shader').remove();
  
  // Create background shader (like the original alert_box)
  var backgroundShader = '<div id="background_shader"></div>';
  
  // Get alert type class
  var alertClass = 'bootstrap-alert';
  
  switch(type) {
    case 'success':
      alertClass += ' alert-success';
      break;
    case 'warning':
      alertClass += ' alert-warning';
      break;
    case 'danger':
    case 'error':
      alertClass += ' alert-danger';
      break;
    case 'info':
      alertClass += ' alert-info';
      break;
    default:
      alertClass += ' alert-success';
  }
  
  // Create alert box with type-specific styling
  var alertHtml = '<div class="' + alertClass + '">' +
    '<div class="alert-content">' +
    '<span class="alert-message">' + message + '</span>' +
    '</div>' +
    '<div class="alert-ok-button">' +
    '<img src="' + prepend_with_image_path + '/assets/Ok.png" onclick="closeBootstrapAlert(); return false;">' +
    '</div>' +
    '</div>';
  
  // Add background shader and alert to body
  jQuery('body').append(backgroundShader);
  jQuery('body').append(alertHtml);
  
  // Auto-hide after 5 seconds
  setTimeout(function() {
    closeBootstrapAlert();
  }, 5000);
}

function closeBootstrapAlert() {
  jQuery('.bootstrap-alert, #background_shader').remove();
}

