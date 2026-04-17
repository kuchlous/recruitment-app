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
    gridSelector: '#hiringDecisionReportsGrid',
    dataElementId: 'hiring-decision-reports-json',
    apiStorageKey: '__hiringDecisionGridApi',
    exportColumnsStorageKey: '__hiringDecisionExportColumnDefs',
    clearFiltersButtonId: 'hiring-decision-clear-filters',
    exportButtonId: 'hiring-decision-export-csv',
    csvFileName: 'hiring_decision_report_filtered.csv',
    columnDefs: [
      { headerName: 'TA Owner', field: 'ta_owner_name', minWidth: 110, flex: 1 },
      {
        headerName: 'Candidate Name',
        field: 'candidate_name',
        minWidth: 140,
        flex: 1.1,
        cellRenderer: candidateCellRenderer
      },
      { headerName: 'Exp', field: 'exp', minWidth: 80, flex: 0.6 },
      {
        headerName: 'Requirement Name',
        field: 'requirement_name',
        minWidth: 160,
        flex: 1.2,
        cellRenderer: requirementNameCellRenderer
      },
      {
        headerName: 'Skill',
        field: 'skill_display',
        tooltipField: 'skill',
        minWidth: 140,
        flex: 1.2
      },
      { headerName: 'Current Company', field: 'current_company', minWidth: 120, flex: 1 },
      {
        headerName: 'Link',
        field: 'uniqid_name',
        minWidth: 90,
        flex: 0.6,
        cellRenderer: resumeLinkCellRenderer
      },
      { headerName: 'EHD Sent Date', field: 'ehd_sent_date', minWidth: 110, flex: 0.9 },
      { headerName: 'Notice Period', field: 'notice_period', minWidth: 100, flex: 0.8 },
      {
        headerName: 'Serving Notice (Yes/No)',
        field: 'serving_notice',
        minWidth: 120,
        flex: 0.9
      },
      { headerName: 'LWD', field: 'lwd', minWidth: 100, flex: 0.8 }
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
