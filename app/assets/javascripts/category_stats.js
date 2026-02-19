/**
 * Initialize AJAX stat loading functionality
 * Both dashboard and requirement show pages use stat cards with data-status attribute
 * @param {Object} options - Configuration options
 * @param {string} options.selector - jQuery selector for stat elements (e.g., '.stat-card[data-action="dashboard_category"]')
 * @param {string|Function} options.url - URL or function that returns URL for AJAX request
 * @param {string} options.contentContainer - jQuery selector for container to load content into
 * @param {string} [options.titleContainer] - Optional jQuery selector for title container
 */
function initializeAjaxStatLoading(options) {
  var selector = options.selector;
  var getUrl = typeof options.url === 'function' ? options.url : function() { return options.url; };
  var contentContainer = options.contentContainer;
  var titleContainer = options.titleContainer;
  // Default getTitle function: status + (count) if available
  var getTitle = function(status, $element) {
    var statNumber = $element ? $element.find('.stat-number').text() : '';
    return status + (statNumber ? ' (' + statNumber + ')' : '');
  };
  
  jQuery(document).ready(function($) {
    // Handle clicks on stat elements
    jQuery(selector).on('click', function(e) {
      e.preventDefault();
      var $this = jQuery(this);
      var status = $this.data('status');
      
      if (!status) {
        // If no status, try to follow parent link
        var $link = $this.closest('a');
        if ($link.length) {
          window.location.href = $link.attr('href');
        }
        return;
      }
      
      var url = getUrl(status);
      
      // Show loading state
      if (titleContainer) {
        var title = getTitle(status, $this);
        jQuery(titleContainer).text(title);
      }
      
      // Show content container if it's hidden
      var $contentContainer = jQuery(contentContainer);
      var $parentContainer = $contentContainer.parent();
      if ($parentContainer.is(':hidden')) {
        $parentContainer.show();
      }
      
      $contentContainer.html('<div class="loading-spinner">Loading...</div>');
      
      // Make AJAX request
      jQuery.ajax({
        url: url,
        method: 'GET',
        data: { status: status },
        dataType: 'html',
        headers: {
          'X-Requested-With': 'XMLHttpRequest'
        },
        success: function(html) {
          $contentContainer.html(html);
          // Initialize sortable on any tables in the loaded content
          var $table = $contentContainer.find('table.sortable');
          if ($table.length && typeof sorttable !== 'undefined' && sorttable.makeSortable) {
            $table.each(function() {
              sorttable.makeSortable(this);
            });
          }
        },
        error: function(xhr, status, error) {
          console.error('Error loading content:', error);
          var errorMsg = '<div class="error-message">Error loading content. Please try again.</div>';
          if (titleContainer) {
            var currentTitle = jQuery(titleContainer).text();
            jQuery(titleContainer).text(currentTitle.replace(' - Error', '') + ' - Error');
          }
          $contentContainer.html(errorMsg);
        }
      });
    });
  });
}

