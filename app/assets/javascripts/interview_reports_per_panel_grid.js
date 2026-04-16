(function () {
  'use strict';

  var reportGridUtils = window.ReportGridUtils;
  if (!reportGridUtils) {
    return;
  }

  function candidateCellRenderer(params) {
    var name = params.data.candidate_name;
    var uid = params.data.uniqid_name;
    if (!name) {
      return '';
    }
    if (uid) {
      return (
        '<a class="action-link" target="_blank" rel="noopener" href="' +
        prepend_with_image_path +
        '/resumes/' +
        encodeURIComponent(uid) +
        '">' +
        reportGridUtils.escapeHtml(name) +
        '</a>'
      );
    }
    return reportGridUtils.escapeHtml(name);
  }

  function resumeLinkCellRenderer(params) {
    var uid = params.data.uniqid_name;
    if (uid) {
      return (
        '<a class="action-link" target="_blank" rel="noopener" href="' +
        prepend_with_image_path +
        '/resumes/' +
        encodeURIComponent(uid) +
        '">View</a>'
      );
    }
    return '—';
  }

  var gridManager = reportGridUtils.createReportGridManager({
    gridSelector: '#interviewPerPanelReportsGrid',
    dataElementId: 'interview-per-panel-reports-json',
    apiStorageKey: '__interviewPerPanelGridApi',
    exportColumnsStorageKey: '__interviewPerPanelExportColumnDefs',
    clearFiltersButtonId: 'interview-per-panel-clear-filters',
    exportButtonId: 'interview-per-panel-export-csv',
    csvFileName: 'interview_reports_per_panel_filtered.csv',
    columnDefs: [
      { headerName: 'Panel Name', field: 'panel_name', minWidth: 120, flex: 1 },
      {
        headerName: 'Candidate Name',
        field: 'candidate_name',
        minWidth: 140,
        flex: 1.1,
        cellRenderer: candidateCellRenderer
      },
      { headerName: 'Interview Date', field: 'interview_date', minWidth: 110, flex: 0.9 },
      { headerName: 'Interview Time', field: 'interview_time', minWidth: 100, flex: 0.8 },
      { headerName: 'Interview Mode', field: 'interview_mode', minWidth: 120, flex: 1 },
      { headerName: 'Panel Name', field: 'panel_name', minWidth: 120, flex: 1 },
      {
        headerName: 'Link',
        field: 'uniqid_name',
        minWidth: 90,
        flex: 0.6,
        cellRenderer: resumeLinkCellRenderer
      },
      { headerName: 'Rounds', field: 'round_label', minWidth: 90, flex: 0.7 },
      { headerName: 'Status', field: 'status_label', minWidth: 110, flex: 0.9 },
      {
        headerName: 'Interview Cancelled/Deleted',
        field: 'cancelled_flag',
        minWidth: 120,
        flex: 0.9
      },
      { headerName: 'TA Owner', field: 'ta_owner_name', minWidth: 110, flex: 1 }
    ]
  });

  document.addEventListener('click', function (e) {
    var t = e.target;
    if (!t || !t.id) {
      return;
    }
    if (gridManager && gridManager.handleActionClick(t.id)) {
      e.preventDefault();
    }
  });

  document.addEventListener('turbolinks:load', function () {
    if (gridManager) {
      gridManager.initGrid();
    }
  });
  document.addEventListener('turbolinks:before-cache', function () {
    if (gridManager) {
      gridManager.destroyGrid();
    }
  });
})();
