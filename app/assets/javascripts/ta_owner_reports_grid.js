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

  function requirementCellRenderer(params) {
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

  var taOwnerGridManager = reportGridUtils.createReportGridManager({
    gridSelector: '#taOwnerReportsGrid',
    dataElementId: 'ta-owner-reports-json',
    apiStorageKey: '__taOwnerGridApi',
    exportColumnsStorageKey: '__taOwnerExportColumnDefs',
    clearFiltersButtonId: 'ta-owner-clear-filters',
    exportButtonId: 'ta-owner-export-csv',
    csvFileName: 'ta_owner_reports_filtered.csv',
    columnDefs: [
      { headerName: 'TA Owner', field: 'ta_owner_name', minWidth: 110, flex: 1 },
      { headerName: 'Forward Date', field: 'forward_date', minWidth: 110, flex: 0.8 },
      {
        headerName: 'Candidate Name',
        field: 'candidate_name',
        minWidth: 140,
        flex: 1.2,
        cellRenderer: candidateCellRenderer
      },
      {
        headerName: 'Requirement Name',
        field: 'requirement_name',
        minWidth: 160,
        flex: 1.2,
        cellRenderer: requirementCellRenderer
      },
      { headerName: 'TA Leads', field: 'ta_leads', minWidth: 100, flex: 1 },
      {
        headerName: 'Skills',
        field: 'skills_display',
        tooltipField: 'skills',
        minWidth: 140,
        flex: 1.2
      },
      { headerName: 'Company Name', field: 'company_name', minWidth: 120, flex: 1 },
      { headerName: 'Total Experience', field: 'total_experience', minWidth: 120, flex: 0.9 },
      { headerName: 'Current CTC', field: 'current_ctc', minWidth: 100, flex: 0.8 },
      { headerName: 'Expected CTC', field: 'expected_ctc', minWidth: 100, flex: 0.8 },
      { headerName: 'Notice Period', field: 'notice_period', minWidth: 110, flex: 0.9 },
      {
        headerName: 'Serving Notice Period (Yes/No)',
        field: 'serving_notice',
        minWidth: 140,
        flex: 1
      },
      { headerName: 'LWD', field: 'lwd', minWidth: 100, flex: 0.8 },
      { headerName: 'Current Location', field: 'current_location', minWidth: 120, flex: 1 },
      { headerName: 'Preferred Location', field: 'preferred_location', minWidth: 120, flex: 1 }
    ]
  });

  document.addEventListener('click', function (e) {
    var t = e.target;
    if (!t || !t.id) {
      return;
    }
    if (taOwnerGridManager && taOwnerGridManager.handleActionClick(t.id)) {
      e.preventDefault();
    }
  });

  document.addEventListener('turbolinks:load', function () {
    if (taOwnerGridManager) {
      taOwnerGridManager.initGrid();
    }
  });
  document.addEventListener('turbolinks:before-cache', function () {
    if (taOwnerGridManager) {
      taOwnerGridManager.destroyGrid();
    }
  });
})();
