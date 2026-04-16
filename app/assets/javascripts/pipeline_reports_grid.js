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

  var pipelineReportsGridManager = reportGridUtils.createReportGridManager({
    gridSelector: '#pipelineReportsGrid',
    dataElementId: 'pipeline-reports-json',
    apiStorageKey: '__pipelineReportsGridApi',
    exportColumnsStorageKey: '__pipelineReportsExportColumnDefs',
    clearFiltersButtonId: 'pipeline-reports-clear-filters',
    exportButtonId: 'pipeline-reports-export-csv',
    csvFileName: 'pipeline_reports_filtered.csv',
    columnDefs: [
      { headerName: 'TA Owner', field: 'ta_owner_name', minWidth: 120, flex: 1 },
      { headerName: 'Group Name', field: 'group_name', minWidth: 120, flex: 1 },
      {
        headerName: 'Requirement Name',
        field: 'requirement_name',
        minWidth: 160,
        flex: 1.2,
        cellRenderer: requirementNameCellRenderer
      },
      numberCol('Forwarded', 'total_forwards'),
      {
        headerName: 'Skills',
        field: 'skills_display',
        tooltipField: 'skills',
        minWidth: 140,
        flex: 1.2
      },
      numberCol('Shortlisted', 'total_shortlists'),
      numberCol('No of Candidates Interviewed', 'total_interviews', 120),
      numberCol('Total Rounds of Interviews', 'total_rounds', 120),
      numberCol('Total EHD Sent', 'total_ehd'),
      numberCol('Engineering Select', 'total_eng_select', 120),
      numberCol('HAC', 'total_hac'),
      numberCol('Total YTO', 'total_yto'),
      numberCol('Offered', 'total_offered'),
      numberCol('Not Accepted', 'total_not_accepted'),
      numberCol('Joined', 'total_joined'),
      numberCol('Not Joined', 'total_not_joined'),
      numberCol('Rejected', 'total_rejects')
    ]
  });

  document.addEventListener('click', function (e) {
    var t = e.target;
    if (!t || !t.id) {
      return;
    }
    if (pipelineReportsGridManager && pipelineReportsGridManager.handleActionClick(t.id)) {
      e.preventDefault();
    }
  });

  document.addEventListener('turbolinks:load', function () {
    if (pipelineReportsGridManager) {
      pipelineReportsGridManager.initGrid();
    }
  });
  document.addEventListener('turbolinks:before-cache', function () {
    if (pipelineReportsGridManager) {
      pipelineReportsGridManager.destroyGrid();
    }
  });
})();
