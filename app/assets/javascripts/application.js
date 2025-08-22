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
//= require twitter/bootstrap/tooltip
//= require open_requirements_grid

//= require_tree .

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
          // Filter out already selected names
          var filteredData = data.filter(function(name) {
            return selectedNames.indexOf(name) === -1;
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
      return false; // Prevent default behavior
    }
  });
}

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

  // Initialize comma-separated autocomplete fields using the helper function
  createCommaSeparatedAutocomplete('.eng-leads-autocomplete');
  createCommaSeparatedAutocomplete('.ta-leads-autocomplete');
  createCommaSeparatedAutocomplete('.requirements-autocomplete');

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


