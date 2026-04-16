(function () {
  'use strict';

  function escapeHtml(text) {
    if (text === null || text === undefined) {
      return '';
    }
    return String(text)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;');
  }

  function destroyTaOwnerGridIfPresent() {
    var gridDiv = document.querySelector('#taOwnerReportsGrid');
    if (gridDiv && gridDiv.__taOwnerGridApi) {
      gridDiv.__taOwnerGridApi.destroy();
      gridDiv.__taOwnerGridApi = null;
    }
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
        escapeHtml(name) +
        '</a>'
      );
    }
    return escapeHtml(name);
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
        escapeHtml(name) +
        '</a>'
      );
    }
    return escapeHtml(name);
  }

  function initTaOwnerReportsGrid() {
    var gridDiv = document.querySelector('#taOwnerReportsGrid');
    var dataEl = document.getElementById('ta-owner-reports-json');
    if (!gridDiv || !dataEl) {
      return;
    }

    destroyTaOwnerGridIfPresent();

    var rowData;
    try {
      rowData = JSON.parse(dataEl.textContent);
    } catch (e) {
      return;
    }

    if (typeof agGrid === 'undefined' || !agGrid.ModuleRegistry) {
      return;
    }

    agGrid.ModuleRegistry.registerModules(
      [agGrid.ClientSideRowModelModule, agGrid.CsvExportModule].filter(Boolean)
    );

    var columnDefs = [
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
    ];

    var gridOptions = {
      columnDefs: columnDefs,
      rowData: rowData,
      defaultColDef: {
        resizable: true,
        sortable: true,
        filter: true,
        flex: 1,
        minWidth: 80
      },
      pagination: true,
      paginationPageSize: 100,
      suppressCellFocus: true
    };

    gridDiv.__taOwnerExportColumnDefs = columnDefs;
    var api = agGrid.createGrid(gridDiv, gridOptions);
    gridDiv.__taOwnerGridApi = api;
  }

  function escapeCsvField(value) {
    if (value === null || value === undefined) {
      return '""';
    }
    var s = String(value);
    if (/^[=+\-@]/.test(s) || s.indexOf('\t') !== -1 || s.indexOf('\r') !== -1) {
      s = "'" + s;
    }
    return '"' + s.replace(/"/g, '""') + '"';
  }

  function exportFilteredCsvManual(api, columnDefs) {
    var exportCols = columnDefs.filter(function (c) {
      return c.field;
    });
    var lines = [];
    lines.push(
      exportCols
        .map(function (c) {
          return escapeCsvField(c.headerName || c.field);
        })
        .join(',')
    );
    api.forEachNodeAfterFilterAndSort(function (node) {
      if (!node.data) {
        return;
      }
      lines.push(
        exportCols
          .map(function (c) {
            return escapeCsvField(node.data[c.field]);
          })
          .join(',')
      );
    });
    var blob = new Blob(['\uFEFF' + lines.join('\r\n')], {
      type: 'text/csv;charset=utf-8;'
    });
    var url = URL.createObjectURL(blob);
    var a = document.createElement('a');
    a.href = url;
    a.download = 'ta_owner_reports_filtered.csv';
    a.click();
    URL.revokeObjectURL(url);
  }

  function clearAllTaOwnerFilters() {
    var gridDiv = document.querySelector('#taOwnerReportsGrid');
    var api = gridDiv && gridDiv.__taOwnerGridApi;
    if (!api) {
      return;
    }
    if (typeof api.setFilterModel === 'function') {
      api.setFilterModel(null);
    } else if (typeof api.setGridOption === 'function') {
      api.setGridOption('filterModel', null);
    }
    if (typeof api.setGridOption === 'function') {
      api.setGridOption('quickFilterText', '');
    } else if (typeof api.setQuickFilter === 'function') {
      api.setQuickFilter('');
    }
  }

  function exportFilteredCsv() {
    var gridDiv = document.querySelector('#taOwnerReportsGrid');
    var api = gridDiv && gridDiv.__taOwnerGridApi;
    var columnDefs = gridDiv && gridDiv.__taOwnerExportColumnDefs;
    if (!api || !columnDefs) {
      return;
    }
    if (typeof api.exportDataAsCsv === 'function') {
      api.exportDataAsCsv({
        fileName: 'ta_owner_reports_filtered.csv',
        exportedRows: 'filteredAndSorted',
        processCellCallback: function (cell) {
          var v = cell.value;
          if (v === null || v === undefined) {
            return '';
          }
          var s = String(v);
          if (/^[=+\-@]/.test(s) || s.indexOf('\t') !== -1 || s.indexOf('\r') !== -1) {
            return "'" + s;
          }
          return s;
        }
      });
      return;
    }
    exportFilteredCsvManual(api, columnDefs);
  }

  document.addEventListener('click', function (e) {
    var t = e.target;
    if (!t || !t.id) {
      return;
    }
    if (t.id === 'ta-owner-export-csv') {
      e.preventDefault();
      exportFilteredCsv();
    } else if (t.id === 'ta-owner-clear-filters') {
      e.preventDefault();
      clearAllTaOwnerFilters();
    }
  });

  document.addEventListener('turbolinks:load', initTaOwnerReportsGrid);
  document.addEventListener('turbolinks:before-cache', destroyTaOwnerGridIfPresent);
})();
