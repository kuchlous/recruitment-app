// Shortlist Javascript file for recruitment database
// recruitment.js


// Focus on login text box when page loads
// Appending the path variable(prepend_with_image_path) with every manual url given based upon the
// environment.
var prepend_with_image_path;
function loadInitialContext()
{
  if ( server_type == 0 )
  {
    prepend_with_image_path = "";
  }
  else
  {
    // ALOK: TBD
     prepend_with_image_path = "/new-recruit";
     //prepend_with_image_path = "";
  }
  element = $("login");
  if ( element )
  {
    element.focus();
  }
}

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
  $("ajax_request_tr").remove();
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

function createLabel(cell, for_id, text)
{
  var label      = document.createElement("label");
  label.htmlFor  = for_id;
  label.appendChild(document.createTextNode(text));
  cell.appendChild(label);
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
    element = $(elementIdToChange);
    linkElement = $(linkElementIdToChange);
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
  var theElement = $(id);
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
  var theElement = $(id);
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

// Next 4 functions are for event listeners.
// For popping up window(flash[:notice])
// ================POP UP Functions Start===============
if (window.addEventListener)
{
  window.addEventListener("load", initAlertFunction, false);
}
else if (window.attachEvent)
{
  window.attachEvent("onload", initAlertFunction);
}
else if ($)
{
  window.onload = initAlertFunction;
}

function initAlertFunction()
{
  var enableFade  = "no";
  var autoHideBox = ["no", 5];
  // Get the handler for the popup element
  var popupElement = $ ? $("alert_box") : document.all["alert_box"];
  var positionVar  = 0;
  setTimeout(function(){displayFadeinBox(enableFade, autoHideBox, popupElement, positionVar)}, 100);
}

function displayFadeinBox(mFade, mAutohide, mElement, positionVar)
{
  var ie = document.all && !window.opera;
  var iebody = (document.compatMode == "CSS1Compat") ? document.documentElement : document.body;

  var scrollTop = (ie) ? iebody.scrollTop : window.pageYOffset;
  var docWidth  = (ie) ? iebody.clientWidth : window.innerWidth;
  var docHeight = (ie) ? iebody.clientHeight: window.innerHeight;
  var objWidth  = mElement.offsetWidth;
  var objHeight = mElement.offsetHeight;
  var top = 0;
  var left = 0;
  if ( positionVar == 1 )
  {
    top  = 100;
  }
  mElement.style.left = docWidth/2 - objWidth/2 - left + "px";
  mElement.style.top  = scrollTop + docHeight/2 - objHeight/2 - top + "px";
  
  setTimeout(function(){staticFadeBox(mElement, positionVar)}, 50);

  if (mFade == "yes" && mElement.filters)
  {
    mElement.filters[0].duration = 1;
    mElement.filters[0].Apply();
    mElement.filters[0].Play();
  }
  mElement.style.visibility = "visible";
  $("background_shader").style.visibility = "visible";
  if (mElement.style.MozOpacity)
  {
    if (mFade == "yes")
      mozFadeFunction(mFade, mAutohide, mElement);
    else
    {
      mElement.style.MozOpacity = 1;
      controlledHideBox(mFade, mAutohide, mElement);
    }
  }
  else
    controlledHideBox(mFade, mAutohide, mElement);
}

function mozFadeFunction(mFade, mAutohide, mElement)
{
  if (parseFloat(mElement.style.MozOpacity) < 1)
    mElement.style.MozOpacity = parseFloat(mElement.style.MozOpacity) + 0.05;
  else
  {
    controlledHideBox(mFade, mAutohide, mElement);
  }
  setTimeout(function(){mozFadeFunction(mFade, mAutohide, mElement)}, 90);
}

function staticFadeBox(mElement, positionVar)
{
  var ie = document.all && !window.opera;
  var iebody = (document.compatMode == "CSS1Compat") ? document.documentElement : document.body;
  var scrollTop = (ie) ? iebody.scrollTop : window.pageYOffset;
  var docHeight     = (ie) ? iebody.clientHeight: window.innerHeight;
  var objHeight     = mElement.offsetHeight;
  var top = 0;
  if ( positionVar == 1 )
  {
    top  = 100;
  }
  mElement.style.top = scrollTop + docHeight / 2 - objHeight / 2 - top + "px";
}

function controlledHideBox(mFade, mAutohide, mElement)
{
  if (mAutohide[0] == "yes")
  {
    var delayVar = (mFade == "yes" && mElement.filters) ? (mAutohide[1] + mElement.filters[0].duration) * 1000 : mAutohide[1] * 1000;
    setTimeout(function(){hideBox(mElement)}, delayVar);
  }
}
// ================POP UP Functions End===============


// Fading function
// Used to fade the row completely in a while
function FadeEffect(element)
{
  new Effect.Fade(element, 
  {
    duration : 1
  });
}

// For closing the already open div.
// Normally using it for closing the div opened by flash[:notice]
function closeBox(elementId)
{
  var mElement = $(elementId);
  hideBox(mElement);
}

// Hides the background shader div
function hideBox(mElement)
{
  mElement.style.visibility = "hidden";
  $("background_shader").style.visibility = "hidden";
}

// Show the div
function showDiv(id)
{
  $(id).style.display = 'block';
}

// Adding interview schedule rows
// Max number possible is 5
total_interview_num = 0;
index               = 0;
total_interview_num_bkup = 0;
function addInterviewRow(event,existing_interview_num, req_match_id, row_index, emp_ids, emp_names, time_array)
{
  event.preventDefault();
  if ( index == 0 )
  {
    total_interview_num = existing_interview_num;
    total_interview_num_bkup = total_interview_num;
  }
  var error_message_div = $("error_messages_div");
  if ( total_interview_num < 5 )
  {
    var table          = $("manage_interviews_table");
    var row            = table.insertRow(total_interview_num + 2);
    row.className      = "float_right";
    var cell           = row.insertCell(0);
    cell.className     = "manage_interviews_cell";

    // First element for ddl of employees
    var select         = createDropDownList(cell, "interview_employee_name" + total_interview_num, "interview_employee_name" + total_interview_num, emp_ids, emp_names, "select_box_with_full_width");
    createSpan(cell, 8);

    // Second element for date input
    var element2  = document.createElement("input");
    element2.name = "interview_date" + total_interview_num;
    element2.id   = "interview_date" + total_interview_num;
    cell.appendChild(element2);

    // Third element for image to pop up calendar
    var element3  = document.createElement("img");
    element3.src  = prepend_with_image_path + "/images/calendar_date_select/calendar.gif";
    element3.style.cursor = "pointer";
    element3.style.paddingLeft = "5px";

    // Onclick event for image.(Poping up calendar)
    Event.observe(element3, "click",
      function(element3)
      {
        new CalendarDateSelect( $(this).previous(), {year_range:[2018, 2020]} );
      }
    );
    cell.appendChild(element3);
    createSpan(cell, 8);

    // Fourth element for ddl of time slots
    var select             = createDropDownList(cell, "time_slot" + total_interview_num, "time_slot" + total_interview_num, time_array, time_array, "select_box_with_low_width");
    createSpan(cell, 8);

    var textarea           = document.createElement("textarea");
    textarea.value         = "Enter focus";
    textarea.name          = "interview_focus" + total_interview_num;
    textarea.id            = "interview_focus" + total_interview_num;
    textarea.className     = "focus_textarea";
    textarea.style.marginRight  = "3px";
    textarea.style.marginTop    = "0px";
    textarea.style.paddingBottom = "4px";

    // On focus prototype function
    Event.observe(textarea, "focus",
      function(textarea)
      {
        textBoxContentsOnFocus(this.id, 'Enter focus');
      }
    );
    // On blur prototype function
    Event.observe(textarea, "blur",
      function(textarea)
      {
        textBoxContentsOnBlur(this.id, 'Enter focus');
      }
    );
    cell.appendChild(textarea);

    // Last element is for deleting the newly created row incase we do not want to use.
    var link_element       = document.createElement("a");
    link_element.innerHTML = "Delete";
    link_element.style.cursor = "pointer";

    // Onclick event for link. Removing the row here.
    Event.observe(link_element, "click",
      function(link_element)
      {
        total_interview_num = total_interview_num - 1;
        // Get the row number
        var row_number = this.parentNode.parentNode.rowIndex;
        row.remove();

        var elements_ids = [ "interview_employee_name", "interview_date", "time_slot", "interview_focus" ];
        for (i = row_number; i <= 4; i++ )
        {
          for ( j = 0; j < elements_ids.length; j++)
          {
            var element = $(elements_ids[j] + i);
            if ( element )
            {
              new_row_number = i - 1;
              element.name = elements_ids[j] + new_row_number;
              element.id   = elements_ids[j] + new_row_number;
            }
          }
        }
        // Hides the error message div if already displayed
        $("error_messages_div").style.visibility = "hidden";
        if ( total_interview_num == 0)
        {
          // Delete ajax div here
          table.up().up().remove();
        }
      }
    );
    cell.appendChild(link_element);

    // If clicked first time on add interviews, then create an extra row at bottom of table
    if ( index == 0 )
    {
      // Last Row created for radio buttons/labels and submit tag for adding interviews
      var last_row      = table.insertRow(total_interview_num + 3);
      last_row.className = "float_right_with_10_padding";
      var last_cell     = last_row.insertCell(0);
      last_cell.className  = "manage_interviews_last_cell";

      // Span1 for appending interview stage radio buttons/labels
      var span1         = document.createElement('span');
      span1.className   = "stage_span_for_border";
      createRadioBox(span1, "interview_stage", "interview_stage_screening", "SCREENING", 0);
      createLabel(span1, "interview_stage_screening", "Screening");
      createRadioBox(span1, "interview_stage", "interview_stage_fullpanel", "FULLPANEL", 1);
      createLabel(span1, "interview_stage_fullpanel", "Full Panel");
      last_cell.appendChild(span1);

      // Span1 for appending interview type radio buttons/labels
      var span2         = document.createElement('span');
      span2.className   = "type_span_for_border";
      createRadioBox(span2, "interview_type", "interview_type_telephonic", "TELEPHONIC", 0);
      createLabel(span2, "interview_type_telephonic", "Telephonic");
      createRadioBox(span2, "interview_type", "interview_type_facetoface", "FACETOFACE", 1);
      createLabel(span2, "interview_type_facetoface", "Face To Face");
      last_cell.appendChild(span2);

      // Two hidden elements created for passing req_match_id and index number(from where to start in controllers)
      createHiddenElement(last_cell, "req_match_id", "req_match_id", req_match_id);
      createHiddenElement(last_cell, "row_index",    "row_index",    row_index);

      // Lastly, submit tag to submit the form
      var submit  = document.createElement('input');
      submit.type = "submit";
      submit.value = "GO";
      submit.className = "manage_interviews_cell_submit_button";

      // Appending elements
      last_cell.appendChild(submit);
      last_row.appendChild(last_cell);
    }

    total_interview_num = total_interview_num + 1;
    index               = index + 1;
  }
  else
  {
    // If schedule added rows will become greater than 5 then show message
    error_message_div.innerHTML = "You can not add more than 5 schedules of an candidate";
    error_message_div.style.visibility = "visible";
    return false;
  }
}

// Shows requirements corresponding to their groups.
// Clicking on any group will open requirements for that respective group
// resumes/_resume_form
function showGroupRequirements(id_array, name_array)
{
  var optElement;
  var new_td     = document.createElement("td");
  new_td.className = "ddl_with_multiples";
  new_td.style.fontSize = "8pt";

  // Multiple drop down list
  var element  = document.createElement("select");
  element.name = "requirement_name[]";
  element.id = "requirement_name";
  element.setAttribute("multiple", "multiple");

  // Element for creating ddl for requirements
  for ( i = 0; i < name_array.length; i++ )
  {
    optElement           = document.createElement("option");
    optElement.value     = id_array[i];
    optElement.innerHTML = name_array[i];
    element.appendChild(optElement);

    // Select all requirements if clicked on "select all reqs"
    if ( i == 0)
    {
      Event.observe(optElement, "click",
        function(optElement)
        {
          selectAllValuesOfDropDownList();
        }
      );
    }
  }
  new_td.appendChild(element);

  // Deletes and replaces the innerHTML of existing multiple ddl
  var tr_element = $("swap_ddl_with_multiples");
  var ref_td     = tr_element.getElementsByTagName("td").item(2);
  tr_element.deleteCell(1);
  tr_element.insertBefore(new_td, ref_td);
}

// Select all values of drop down list if clicked on "select all reqs" ( Used on page load )
function selectAllValuesOfDropDownListAtStart()
{
  select_element = $("requirement_name");
  selected_index = select_element.options[select_element.selectedIndex].value;
  if ( selected_index == "Select all reqs" )
  {
    selectAllValuesOfDropDownList();
  }
}

// Select all values of drop down list if clicked on "select all reqs" ( Used after page loading )
function selectAllValuesOfDropDownList()
{
  select_element = $("requirement_name");
  for ( i = 0; i < select_element.options.length; i++ )
  {
    select_element.options[i].selected = true;
  }
  select_element.options[0].selected   = false;
}

// Provide links to create portal/agencies if they are not present in current database
function showReferrals(id_array, name_array, add_status_var)
{
  var new_td             = document.createElement("td");
  new_td.className       = "add_resume_field";
  new_td.style.fontSize  = "8pt";

  // Element for drop down list of referrals
  // Should be agency/portals/employees
  var select = createDropDownList(new_td, "resume[referral_id]", "", id_array, name_array, "");

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
  new_td.appendChild(link);

  var tr_element = $("swap_td_for_referrals");
  tr_element.style.visibility = "visible";
  var ref_td     = tr_element.getElementsByTagName("td").item(2);
  tr_element.deleteCell(1);
  tr_element.insertBefore(new_td, ref_td);
}

// Removing links and drop down list for referrals in case we use the DIRECT referral type
function hideReferrals()
{
  var tr_element = $("swap_td_for_referrals");
  tr_element.style.visibility = "hidden";
}

// Create the appropriate forms for actions based upon the value of drop down list
// This is for HR/ADMIN
function actionBox(value, event, req_id_array, req_name_array, req_match_id, resume_id)
{
  // Finding element where mouse(which td/tr) is clicked
  cur_element = Event.element(event);
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
  cur_element = Event.element(event);

  var selValue = new Array;

  // Finds the multiple drop down list
  // First find the table and then selects and then first select
  table   = cur_element.up().up();
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
    }
    else
    {
      // Creates the ajax row under the current element to display that you should have selected at least one requirement
      var elements = createRow();

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

// Send an ajax request
// Replace the row with interviews
function getInterviews(cur_element, req_match_id)
{
  // Setting form action
  setFormAction("add_interviews");

  // Create "ajax_reuest_tr" Row
  var elements = createRow();

  // Sending ajax request to get interviews
  // The interviews will replace innerHTML of the row created by addRow()
  new Ajax.Request(prepend_with_image_path + "/resumes/manage_interviews?req_match_id=" + req_match_id,
  { asynchronous:true, evalScripts:true,
    onFailure: function(transport)
    {
      alert("Server was down while performing this action. Please contact administrators.");
    }
  });
}

// Used to mark any reqmatch status as joining
function markJoining(match_id, resume_id, event)
{
  // Finds joining date from the input box
  joining_date = $("resume_joining_date" + match_id).value;
  if ( !joining_date )
  {
    alert("Please select joining date");
    return false;
  }
  // Creates Ajax request to mark req_match as joining
  new Ajax.Request( 
        prepend_with_image_path + '/resumes/mark_joining',
        { method: 'post', 
          parameters: 'match=' + match_id + '&resume_id=' + resume_id + '&joining_date=' + joining_date,
          asynchronous:true, 
          evalScripts:true,
          onSuccess: function(transport)
          {
            replaceTDvalue(event, 2, "Joining date added");
          },
          onFailure: function(transport)
          {
            alert("Server was down while performing this action. Please contact administrators.");
          }
        }
      );
}

// Used to mark resume as not accepted
function markNotAccepted(resume_id, event)
{
  new Ajax.Request( 
        prepend_with_image_path + '/resumes/mark_not_accepted',
        { method: 'post',
          parameters: 'resume_id=' + resume_id,
          asynchronous:true, 
          evalScripts:true,
          onSuccess: function(transport)
          {
            replaceTDvalue(event, 1, "Not accepted");
          },
          onFailure: function(transport)
          {
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

  var image_element  = document.createElement("img");
  image_element.src  = prepend_with_image_path + "/images/calendar_date_select/calendar.gif";
  image_element.className    = "joining_date_image";
  image_element.style.cursor = "pointer";
  Event.observe(image_element, "click",
    function(image_element)
    {
      new CalendarDateSelect( $(this).previous(), {year_range:[2018, 2020]} );
    }
  );
  div_element.appendChild(image_element);
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
  Event.observe(txtElement, "focus",
    function(txtElement)
    {
      textBoxContentsOnFocus(this.id, 'Enter employee name');
    }
  );

  // Change color on Onblur of autocomplete input box
  Event.observe(txtElement, "blur",
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
  var elements = createRow();
  
  // Close box link
  closeBoxLink(elements[0]);

  // Creating text area element
  createTextAreaElement(elements[0], "Set Status");

  // Creating an image inside the tr
  var element   = imageForGoIcon(-22, 70);

  // Onclick ajax request to add status to req_matches
  Event.observe(element, "click",
    function(element)
    {
      new Ajax.Request(prepend_with_image_path + "/resumes/add_interview_status_to_req_matches?resume_id=" + resume_id + "&" + req_match_id_or_req_id + "=" + req_match_id,
        { asynchronous:true, evalScripts:true,
          parameters: 'resume[comment]=' + $F('comment_textarea'),
          onSuccess: function(transport)
          {
            value = "Status";
            value = findProperValueToBeDisplayed(value);
            deleteAndCreateTDAfterAction(elements[2], value);
            changeCurrentRowColor(elements[3]);
          },
          onFailure: function(transport)
          {
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
  // Finding element where mouse(which td/tr) is clicked
  cur_element = Event.element(event);

  // Create "ajax_request_tr" row
  var elements = createRow();

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
  Event.observe(element, "click",
    function(element)
    {
      new Ajax.Request(prepend_with_image_path + "/resumes/update_joining?resume_id=" + resume_id + "&req_match_id=" + req_match_id,
        { asynchronous:true, evalScripts:true,
          parameters: 'resume[comment]=' + encodeURIComponent($F('comment_textarea')) + '&resume[joining_date]=' + $F('joining_date') + '&resume[status]=' + $F('resume_status'),
          onSuccess: function(transport)
          {
            value = "Action Taken"
            value = findProperValueToBeDisplayed(value);
            deleteAndCreateTDAfterAction(elements[2], value);
            changeCurrentRowColor(elements[3]);
          },
          onFailure: function(transport)
          {
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
  cur_element = Event.element(event);
  
  // Create "ajax_request_tr" row
  var elements = createRow();

  // Close box link
  closeBoxLink(elements[0]);

  // Creating text area element
  createTextAreaElement(elements[0], "decline interview");

  // Creating an image inside the tr
  var element   = imageForGoIcon(-22, 70);

  // Onclick ajax request to add status to req_matches
  Event.observe(element, "click",
    function(element)
    {
      new Ajax.Request(prepend_with_image_path + "/resumes/decline_interview?interview_id=" + interview_id,
        { asynchronous:true, evalScripts:true,
          parameters: 'resume[comment]=' + $F('comment_textarea'),
          onSuccess: function(transport)
          {
            value = "Declined";
            value = findProperValueToBeDisplayed(value);
            deleteAndCreateTDAfterAction(elements[2], value);
            changeCurrentRowColor(elements[3]);
          },
          onFailure: function(transport)
          {
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
  cur_element = Event.element(event);
  showMessageBox(cur_element, resume_id);
}

// Function to show add message box
// Will replace the innerHTML of "ajax_request_tr" with the message box
function showMessageBox(cur_element, resume_id)
{
  // Create "ajax_request_tr" row
  var elements = createRow();

  // Close box link
  closeBoxLink(elements[0]);

  // Get autocomplete text box for employee names
  getAutoCompleteTextBox(elements[0]);

  // Creating text area element
  createTextAreaElement(elements[0], "Message");

  // Creating an image inside the tr
  var element   = imageForGoIcon(10, 70);

  // Onclick ajax request to send message
  Event.observe(element, "click",
    function(element)
    {
      new Ajax.Request(prepend_with_image_path + "/resumes/add_message?resume_id=" + resume_id + "&counter_value=0" + "&req_match=0",
        { asynchronous:true, evalScripts:true,
          parameters: 'resume[comment]=' + $F('comment_textarea') + "&employee_id=" + $F('message_emp_name'),
          onSuccess: function(transport)
          {
            value = "Message";
            value = findProperValueToBeDisplayed(value);
            deleteAndCreateTDAfterAction(elements[2], value);
            changeCurrentRowColor(elements[3]);
          },
          onFailure: function(transport)
          {
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
  cur_element = Event.element(event);
  showAddCommentBox(cur_element, resume_id);
}

// Function used to display the reject box under current row
function RejectBox(event, resume_id, action)
{
  event.preventDefault();
  cur_element  = Event.element(event);
  req_match_id = 0;
  createAjaxRequest(cur_element, req_match_id, action, resume_id, "req_match_id", 0);
}

// Function used to display the forward box under current row
function ForwardBox(event, req_names, req_ids, resume_id)
{
  cur_element = Event.element(event);
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
  var elements = createRow();

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
  Event.observe(link_element, "click",
    function(img_element)
    {
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
      new Ajax.Request(prepend_with_image_path + "/resumes/create_multiple_forwards?" + "resume_id=" + resume_id + "&req_names=" + selected_req_array,
        { asynchronous:true, evalScripts:true,
          onSuccess: function(transport)
          {
            value = findProperValueToBeDisplayed(display_value);
            deleteAndCreateTDAfterAction(elements[2], value);
            changeCurrentRowColor(elements[3]);
          },
          onFailure: function(transport)
          {
            alert("Server was down while performing this action. Please contact administrators.");
          }
        });
      return false;
    }
  );
  link_element.appendChild(img_element);
  elements[0].appendChild(link_element);
  containing_tr.insert({'after': elements[1]});
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
  var elements = createRow();

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
  Event.observe(element, "click",
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
        params = '&joining_date=' + $F('joining_date');
        if (!$F('joining_date') )
        {
          alert("Please select joining date first");
          return false;
        }
      }
      else
      {
        params = "";
      }
      jQuery.ajax({url: prepend_with_image_path + "/resumes/resume_action?" + req_match_id_or_req_id + "=" + ids + "&status=" + value + "&resume_id=" + resume_id + url_params, 
      data: 'resume[comment]=' + encodeURIComponent($F('comment_textarea')) + params,
      type: 'POST',
      success: function(result){
        document.getElementById("loader").style.display="none";
            value = findProperValueToBeDisplayed(value);
            deleteAndCreateTDAfterAction(elements[2], value);
            changeCurrentRowColor(elements[3]);
      },
      error: function(err)
      {
        document.getElementById("loader").style.display="none";
        console.log("from jquery");
        alert("Server was down while performing this action. Please contact administrators.");
      }
    });
      return false;
     }
  );
  elements[0].appendChild(element);
  containing_tr.insert({'after': elements[1]});
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
  Event.observe(img_element, "click",
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
  $(element).remove();
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
  Event.observe(textarea, "focus",
    function(textarea)
    {
      textBoxContentsOnFocus(this.id, 'Enter your comment and click on arrow to ' + value.toLowerCase());
    }
  );
  Event.observe(textarea, "blur",
    function(textarea_element)
    {
      textBoxContentsOnBlur(this.id, 'Enter your comment and click on arrow to ' + value.toLowerCase());
    }
  );
  element.appendChild(textarea);
}

function replyToBox(event, message, parent_message, message_id)
{
  // Finding element where mouse(which td/tr) is clicked
  cur_element = Event.element(event);

  // Ajax request to set is_read of message to false
  new Ajax.Request(prepend_with_image_path + "/resumes/set_is_read?" + "message_id=" + message_id,
    { asynchronous:true, evalScripts:true,
      onSuccess: function(transport)
      {
        cur_element.up().style.fontWeight = "normal";
      },
      onFailure: function(transport)
      {
        alert("Server was down while performing this action. Please contact administrators.");
      }
    });

  // Setting form action
  setFormAction("reply_message");

  var elements = createRow();

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
  Event.observe(img_element, "click",
    function(img_element)
    {
      document.form.submit();
    }
  );
  elements[0].appendChild(img_element);

  // Create hidden element to pass message id
  createHiddenElement(elements[0], "message_id", "message_id", message_id);
}

// Function used to create extra row after the current row.
// Wherever the mouse is clicked, the row will be created just after it
function createRow()
{
  old_tr              = $("ajax_request_tr");
  if (old_tr)
  {
    old_tr.remove();
  }
  containing_tr       = cur_element.up('tr');
  num_tds             = containing_tr.childElements().length;
  var trElement       = document.createElement("tr");
  trElement.id        = "ajax_request_tr";
  var tdElement       = document.createElement("td");
  tdElement.colSpan   = num_tds;
  trElement.appendChild(tdElement);
  containing_tr.insert({'after': trElement});

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

// ================Pop Up Brief Descriptions START===============

// Creates and pops up a div for resume with qualification and experience
function popUpDescriptionForResume(resume_id, qualification, experience, company)
{
  popUpDescription(resume_id, qualification, experience, company, "Qualification: ", "Experience: ", "Company: ");
}

// Creates and pops up a div for requirement with skills and description
function popUpDescriptionForRequirements(requirement_id, skills, description)
{
  popUpDescription(requirement_id, skills, description, "", "Skills: ", "Description: ", "");
}

// Function to pop-up box
function popUpDescription(id, qual_skill, exp_desc, company, tag1, tag2, tag3)
{
  // Creating div which will work as a container for both of the tags
  var div   = document.createElement("div");
  div.id    = "resume" + id;
  div.className = "resume_description_div";

  // 1st tag of qualification/skills
  var span_element = document.createElement("span");
  span_element.innerHTML = tag1.bold()  + qual_skill;
  div.appendChild(span_element);
  createLineBreakElement(div, 2);

  // 2nd tag of experience/description
  var span_element1 = document.createElement("span");
  span_element1.innerHTML = tag2.bold() + exp_desc;
  div.appendChild(span_element1);

  if (tag3 != "" && company != "") { 
    createLineBreakElement(div, 2);
    var span_element1 = document.createElement("span");
    span_element1.innerHTML = tag3.bold() + company;
    div.appendChild(span_element1);
  }

  document.body.appendChild(div);

  // Displaying the div over here
  ShowContent("resume" + id);
}

// Function used for updating the cursor position.
// Usually title tag comes at static place but this function
// displays the div near to the cursor position. If the cursor position is changed
// then cordinates of that div will also be changed.
var cX = cY = rX = rY = 0;
function UpdateCursorPosition(e)
{
  cX = e.pageX;
  cY = e.pageY;
}

function UpdateCursorPositionDocAll(e)
{
  cX = event.clientX;
  cY = event.clientY;
}

if ( document.all )
{
  document.onmousemove = UpdateCursorPositionDocAll;
}
else
{
  document.onmousemove = UpdateCursorPosition;
}

function AssignPosition(d)
{
  if ( self.pageYOffset )
  {
    rX = self.pageXOffset;
    rY = self.pageYOffset;
  }
  else if ( document.documentElement && document.documentElement.scrollTop )
  {
    rX = document.documentElement.scrollLeft;
    rY = document.documentElement.scrollTop;
  }
  else if ( document.body )
  {
    rX = document.body.scrollLeft;
    rY = document.body.scrollTop;
  }
  if ( document.all )
  {
    cX += rX;
    cY += rY;
  }
  d.style.left = (cX+10) + "px";
  d.style.top  = (cY+10) + "px";
}

function ShowContent(d)
{
  if(d.length < 1)
  {
    return;
  }
  var dd = document.getElementById(d);
  AssignPosition(dd);
  dd.style.display = "block";
}

// Function to remove the pop-up div from the document itself
function HideContent(d)
{
  if ( d.length < 1 )
  {
    return;
  }
  div_element = $("resume" + d);
  document.body.removeChild(div_element);
}
// ================Pop Up Brief Descriptions END===============


function viewCommentsFeedback(event, resume_id, action, cols)
{
  event.preventDefault();
  // TODO: We can removed this event(line) from this and next function as well as we do not need them anymore.

  // Finding element where mouse(which td/tr) is clicked
  cur_element = Event.element(event);

  // Create "ajax_reuest_tr" Row
  var elements = createRow();

  // Sending ajax request to get interviews
  // The interviews will replace innerHTML of the row created by addRow()
  new Ajax.Request(prepend_with_image_path + "/resumes/" + action + "?resume_id=" + resume_id + "&columns=" + cols,
  { asynchronous:true, evalScripts:true,
    onFailure: function(transport)
    {
      alert("Server was down while performing this action. Please contact administrators.");
    }
  });
}

// Basically we use this function to create/send feedback
function createFeedbackBox(event, resumeId, req_name)
{
  event.preventDefault();
  setFormAction("feedback");

  // Finding element where mouse(which td/tr) is clicked
  cur_element = Event.element(event);

  // Creating row (ajax_request_tr)
  var elements = createRow();

  // Close box link
  closeBoxLink(elements[0]);

  // Create ratings drop down list
  var ratings = [ "Select", "Poor", "Fair", "Good", "Very Good", "Excellent" ];
  var select  = createDropDownList(elements[0], "feedback[rating]", "feedback[rating]", ratings, ratings, "feedback_fields");

  createLineBreakElement(elements[0], 2);

  // Create text area
  createTextAreaElement(elements[0], "Add Feedback");

  // Image for go-icon
  var element   = imageForGoIcon(10, 64);

  // Onclick event for image element
  Event.observe(element, "click",
    function(element)
    {
      document.form.submit();
    }
  );
  elements[0].appendChild(element);

  // Pass resume id as hidden element
  createHiddenElement(elements[0], "feedback[resume_id]", "feedback_resume_id", resumeId);
  createHiddenElement(elements[0], "requirement_name",    "requirement_name",   req_name);
}

function closeShowCommentsBox(elementId)
{ 
  var elem = $(elementId);
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
  emp_id    = $F("interview_employee_name" + index);
  int_time  = $F("time_slot" + index);
  int_date  = $F("interview_date" + index);
  int_focus = encodeURIComponent($F("interview_focus" + index));

  // Creates Ajax request to update interview
  new Ajax.Request( prepend_with_image_path + '/resumes/update_interview?interview_id=' + interview_id + '&interview_employee_name=' + emp_id + '&interview_time=' + int_time + '&interview_date=' + int_date + '&interview_focus=' + int_focus,
  { asynchronous:true, evalScripts:true,
    onFailure: function(transport)
    {
      alert("Server was down while performing this action. Please contact administrators.");
    }
  });
  // To reload the page
  window.location.reload();
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
  cur_element   = Event.element(event);
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
  cur_element = Event.element(event);

  // Create "ajax_request_tr" row
  var elements = createRow();
  
  // Close box link
  closeBoxLink(elements[0]);

  // Creating text area element
  createTextAreaElement(elements[0], "Set manual status");

  // Creating an image inside the tr
  var element   = imageForGoIcon(-22, 70);

  // Onclick ajax request to add status to req_matches
  Event.observe(element, "click",
    function(element)
    {
      new Ajax.Request(prepend_with_image_path + "/resumes/add_manual_status_to_resume?resume_id=" + resume_id,
        { asynchronous:true, evalScripts:true,
          parameters: 'resume[comment]=' + $F('comment_textarea'),
          onSuccess: function(transport)
          {
            value = "Manual Status";
            value = findProperValueToBeDisplayed(value);
            var textbox_value = $F('comment_textarea');
            deleteAndCreateTDAfterAction(elements[2], value);
            changeCurrentRowColor(elements[3]);
            cur_element.innerHTML = textbox_value;
          },
          onFailure: function(transport)
          {
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
  return prepend_with_image_path + '/images/' + img_name + '_Image.png';
}

function get_image_tag(likely_to_join, resume_id) {
  var $img = $jq('<img/>').attr('src', get_image_name(likely_to_join)).click({resume_id : resume_id, likely_to_join: likely_to_join}, update_joining_status);
  return $img;
}

function show_current_joining_status(resume_id, likely_to_join) {
  var $cell = $jq('#likely-to-join-' + resume_id);
  $cell.html("");
  var $img = $jq('<img/>').attr('src', get_image_name(likely_to_join)).click({resume_id : resume_id}, show_all_images_for_likely_to_join);
  $cell.append($img);
}

function update_joining_status(event) {
  var resume_id = event.data.resume_id;
  var likely_to_join = event.data.likely_to_join;
  $jq.ajax({
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
}

// JQuery presents a different interface to callbacks, hence this wrapper.
function show_all_images_for_likely_to_join(event) {
  var resume_id = event.data.resume_id;
  showAllImagesForLikelyToJoin(event, resume_id);
}

function showAllImagesForLikelyToJoin(event, resume_id) {
  var $cell = $jq('#likely-to-join-' + resume_id);
  $cell.html("");

  var imageTags = [ "R", "G", "O" ];

  for (i = 0; i < imageTags.length; i++) {
    var $img = get_image_tag(imageTags[i], resume_id);
    $cell.append($img);
  }
}
