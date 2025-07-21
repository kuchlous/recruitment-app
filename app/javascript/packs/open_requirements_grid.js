import { Grid } from '@ag-grid-community/core';
import { ClientSideRowModelModule } from '@ag-grid-community/client-side-row-model';
import { ModuleRegistry } from '@ag-grid-community/core';

ModuleRegistry.registerModules([ClientSideRowModelModule]);

import 'ag-grid-community/styles/ag-grid.css';
import 'ag-grid-community/dist/styles/ag-theme-alpine.css';

// Import New Override CSS After AG Grid Styles
import 'stylesheets/ag_grid_overrides.css';

document.addEventListener('DOMContentLoaded', () => {
  const gridDiv = document.querySelector('#openRequirementsGrid');
  const loaderDiv = document.querySelector('#gridLoader');
  const errorDiv = document.querySelector('#gridError');

  if (gridDiv) {
    // Hide error message initially
    if (errorDiv) {
      errorDiv.style.display = 'none';
    }

    // Show the loader before fetching data
    if (loaderDiv) {
      loaderDiv.style.display = 'block';
    }
    gridDiv.style.display = 'none'; // Hide the grid initially

    const columnDefs = [
      {
        headerName: 'ID',
        field: 'id',
        width: 90,
        sortable: true,
        filter: 'agNumberColumnFilter',
        flex: 1
      },
      {
        headerName: 'Name',
        field: 'name',
        sortable: true,
        filter: true,
        flex: 2,
        cellRenderer: function(params) {
          if (params.value !== undefined && params.data.id !== undefined) {
            const iconHtml = '<span class="glyphicon glyphicon-new-window" aria-hidden="true" style="font-size: 0.8em; margin-left: 5px;"></span>';

            return `<a href="/requirements/${params.data.id}" target="_blank">${params.value} ${iconHtml}</a>`;
          }
          return params.value; // Fallback if data is missing
        }
      },
      {
        headerName: 'Skills/Desc',
        field: 'description',
        sortable: true,
        filter: true,
        flex: 3,
        minWidth: 200
      },
      {
        headerName: 'Exp',
        field: 'experience',
        sortable: true,
        flex: 1.5,
        minWidth: 150
      },
      {
        headerName: 'End Date',
        field: 'edate',
        sortable: true,
        filter: 'agDateColumnFilter',
        flex: 1.5,
        minWidth: 150
      },
      {
        headerName: 'Positions',
        field: 'positions',
        sortable: true,
        flex: 1.5,
        minWidth: 150
      },
      {
        headerName: 'Owner',
        field: 'owner',
        sortable: true,
        flex: 1.5,
        minWidth: 150
      },
      {
        headerName: 'Status',
        field: 'status',
        sortable: true,
        filter: true,
        width: 100,
        flex: 1,
      }
    ];

    const gridOptions = {
      columnDefs: columnDefs,
      rowData: [],
      defaultColDef: {
        resizable: true,
        sortable: true,
        filter: true,
      },
      pagination: true,
      paginationPageSize: 10,
      domLayout: 'autoHeight',
      getRowClass: function(params) {
        if (params.data.req_type === 'HOT') {
          return 'ag-row-hot';
        }
        return null;
      }
    };

    new Grid(gridDiv, gridOptions);
    const gridApi = gridOptions.api;

    fetch('/api/requirements')
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
      })
      .then(rowData => {
        gridApi.setRowData(rowData);
        // Hide the loader and show the grid once data is loaded
        if (loaderDiv) {
          loaderDiv.style.display = 'none';
        }
        gridDiv.style.display = 'block';
      })
      .catch(error => {
        console.error('Error fetching requirements data:', error);
        // Hide loader and show error message
        if (loaderDiv) {
          loaderDiv.style.display = 'none';
        }
        if (errorDiv) {
          errorDiv.textContent = `Failed to load data: ${error.message}. Please try again later.`;
          errorDiv.style.display = 'block';
        }
        gridDiv.style.display = 'none'; // Keep grid hidden on error
      });

    window.agGridApi = gridApi;

    window.clearAllFilters = () => {
      gridApi.setFilterModel(null);
      document.getElementById('quickFilterInput').value = '';
      gridApi.setQuickFilter(null);
    };
  }
});