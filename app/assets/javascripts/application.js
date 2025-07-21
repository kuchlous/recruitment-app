// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//= require jquery
//= require jquery-ui
//= require rails-ujs
//= require turbolinks
//= require moment 
//= require fullcalendar
//= require fullcalendar/gcal
//= require twitter/bootstrap/modal
//= require_tree .
// for employees available in our database
function fillInputBoxWithContents()
{
  $jq = jQuery.noConflict();
  element = jQuery("#message_emp_name");
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
          response(data);
        }
      });
    },
    minLength: 1,
    delay: 300,
    autoFocus: true,
    position: { my: "left top", at: "left bottom", collision: "flip" }
  });

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

console.log('Application.js loaded');


