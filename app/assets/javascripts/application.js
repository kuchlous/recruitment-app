// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//= require jquery
//= require jquery-ui
//= require rails-ujs
//= require turbolinks
//= require moment 
//= require fullcalendar
//= require fullcalendar/gcal
//= require_tree .
// for employees available in our database
function fillInputBoxWithContents()
{
  $jq = jQuery.noConflict();
  element = jQuery("#message_emp_name");
  element.autocomplete({source: empNames["listedEmployees"]});
}

function fillRequirementSearchBoxWithContents() {
  $jq = jQuery.noConflict();
  search_emp = jQuery("#search");
  search_emp.autocomplete({source: empNames["listedEmployees"]});
} 


function showEventDetails(event)
{
  $jq = jQuery.noConflict();
  $jq('#event_desc').html(event.description);
  $jq('#desc_dialog').dialog({
      title: event.title,
//      modal: true,
      width: 400,
      close: function(event, ui) { $jq('#desc_dialog').dialog('destroy') }
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

$(document).ready(() => { $('.hidden_by_default').hide() });
