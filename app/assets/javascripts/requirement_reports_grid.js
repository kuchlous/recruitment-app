(function () {
  'use strict';

  var reportGridUtils = window.ReportGridUtils;
  if (!reportGridUtils) {
    return;
  }

  function requirementNameCellRenderer(params) {
    var name = params.data.requirement_name;
    var id = params.data.requirement_id;
    if (!name) {
      return '';
    }
    if (id !== null && id !== undefined && id !== '') {
      return (
        '<a class="action-link" target="_blank" rel="noopener" href="' +
        prepend_with_image_path +
        '/requirements/' +
        encodeURIComponent(id) +
        '">' +
        reportGridUtils.escapeHtml(name) +
        '</a>'
      );
    }
    return reportGridUtils.escapeHtml(name);
  }

  var numberCol = function (headerName, field, minWidth) {
    return {
      headerName: headerName,
      field: field,
      minWidth: minWidth || 100,
      flex: 0.7,
      filter: 'agNumberColumnFilter'
    };
  };

  var requirementReportsGridManager = reportGridUtils.createReportGridManager({
    gridSelector: '#requirementReportsGrid',
    dataElementId: 'requirement-reports-json',
    apiStorageKey: '__requirementReportsGridApi',
    exportColumnsStorageKey: '__requirementReportsExportColumnDefs',
    clearFiltersButtonId: 'requirement-reports-clear-filters',
    exportButtonId: 'requirement-reports-export-csv',
    csvFileName: 'requirement_reports_filtered.csv',
    columnDefs: [
      { headerName: 'Group Name', field: 'group_name', minWidth: 120, flex: 1 },
      {
        headerName: 'Requirement Name',
        field: 'requirement_name',
        minWidth: 160,
        flex: 1.2,
        cellRenderer: requirementNameCellRenderer
      },
      numberCol('Total Forward', 'total_forwards'),
      numberCol('Total Shortlists', 'total_shortlists'),
      numberCol('Total Interviews (Candidates)', 'total_interviews', 120),
      numberCol('Total L1 Completed', 'total_l1_completed'),
      numberCol('Total L2 Completed', 'total_l2_completed'),
      numberCol('Total L3 Completed', 'total_l3_completed'),
      numberCol('Total YTO', 'total_yto'),
      numberCol('Total HAC', 'total_hac'),
      numberCol('Total Hold', 'total_hold'),
      numberCol('Total Offered', 'total_offered'),
      numberCol('Total Not Accepted', 'total_not_accepted', 120),
      numberCol('Total Joined', 'total_joined'),
      numberCol('Total Not Joined', 'total_not_joined', 120),
      numberCol('Total Rejects', 'total_rejects'),
      { headerName: 'TA Manager', field: 'ta_manager_name', minWidth: 120, flex: 1 }
    ]
  });

  document.addEventListener('click', function (e) {
    var t = e.target;
    if (!t || !t.id) {
      return;
    }
    if (requirementReportsGridManager && requirementReportsGridManager.handleActionClick(t.id)) {
      e.preventDefault();
    }
  });

  document.addEventListener('turbolinks:load', function () {
    if (requirementReportsGridManager) {
      requirementReportsGridManager.initGrid();
    }
  });
  document.addEventListener('turbolinks:before-cache', function () {
    if (requirementReportsGridManager) {
      requirementReportsGridManager.destroyGrid();
    }
  });
})();
