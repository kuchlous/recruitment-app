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

  function destroyGridIfPresent(gridDiv, storageKey) {
    if (gridDiv && gridDiv[storageKey]) {
      gridDiv[storageKey].destroy();
      gridDiv[storageKey] = null;
    }
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

  function exportFilteredCsvManual(api, columnDefs, csvFileName) {
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
    a.download = csvFileName;
    a.click();
    URL.revokeObjectURL(url);
  }

  function createReportGridManager(config) {
    function getGridDiv() {
      return document.querySelector(config.gridSelector);
    }

    function getDataEl() {
      return document.getElementById(config.dataElementId);
    }

    function initGrid() {
      var gridDiv = getGridDiv();
      var dataEl = getDataEl();
      if (!gridDiv || !dataEl) {
        return;
      }
      destroyGridIfPresent(gridDiv, config.apiStorageKey);

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

      var gridOptions = {
        columnDefs: config.columnDefs,
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

      gridDiv[config.exportColumnsStorageKey] = config.columnDefs;
      gridDiv[config.apiStorageKey] = agGrid.createGrid(gridDiv, gridOptions);
    }

    function clearFilters() {
      var gridDiv = getGridDiv();
      var api = gridDiv && gridDiv[config.apiStorageKey];
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

    function exportCsv() {
      var gridDiv = getGridDiv();
      var api = gridDiv && gridDiv[config.apiStorageKey];
      var columnDefs = gridDiv && gridDiv[config.exportColumnsStorageKey];
      if (!api || !columnDefs) {
        return;
      }
      if (typeof api.exportDataAsCsv === 'function') {
        api.exportDataAsCsv({
          fileName: config.csvFileName,
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
      exportFilteredCsvManual(api, columnDefs, config.csvFileName);
    }

    function handleActionClick(targetId) {
      if (targetId === config.exportButtonId) {
        exportCsv();
        return true;
      }
      if (targetId === config.clearFiltersButtonId) {
        clearFilters();
        return true;
      }
      return false;
    }

    return {
      initGrid: initGrid,
      destroyGrid: function () {
        var gridDiv = getGridDiv();
        destroyGridIfPresent(gridDiv, config.apiStorageKey);
      },
      handleActionClick: handleActionClick
    };
  }

  window.ReportGridUtils = {
    escapeHtml: escapeHtml,
    createReportGridManager: createReportGridManager
  };
})();
