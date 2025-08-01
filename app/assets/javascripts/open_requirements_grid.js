// This registers the module correctly from the single loaded file
agGrid.ModuleRegistry.registerModules([agGrid.ClientSideRowModelModule]);

document.addEventListener('DOMContentLoaded', () => {
  const gridDiv = document.querySelector('#openRequirementsGrid');
  const loaderDiv = document.querySelector('#gridLoader');
  const errorDiv = document.querySelector('#gridError');
  console.log('Open Requirements Grid script loaded');

  if (gridDiv) {
    if (errorDiv) {
      errorDiv.style.display = 'none';
    }
    if (loaderDiv) {
      loaderDiv.style.display = 'block';
    }
    gridDiv.style.display = 'none';

    fetch('/api/requirements')
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP Error! status: ${response.status}`);
        }
        return response.json();
      })
      .then(rowData => {
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
              return params.value;
            }
          },
          {
            headerName: 'Skills/Desc',
            field: 'skill',
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
            minWidth: 300
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
            minWidth: 50
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
          rowData: rowData,
          defaultColDef: {
            resizable: true,
            sortable: true,
            filter: true,
          },
          pagination: true,
          paginationPageSize: 100,
          domLayout: 'autoHeight',
          getRowClass: function(params) {
            if (params.data.req_type === 'HOT') {
              return 'ag-row-hot';
            }
            return null;
          }
        };

        const gridApi = agGrid.createGrid(gridDiv, gridOptions);
        window.agGridApi = gridApi;

        if (loaderDiv) {
          loaderDiv.style.display = 'none';
        }
        gridDiv.style.display = 'block';

        const quickFilterInput = document.getElementById('quickFilterInput');
        if (quickFilterInput) {
          quickFilterInput.addEventListener('input', (event) => {
            gridApi.setGridOption('quickFilterText', event.target.value);
          });
        }
      })
      .catch(error => {
        console.error('Error fetching requirements data:', error);
        if (loaderDiv) {
          loaderDiv.style.display = 'none';
        }
        if (errorDiv) {
          errorDiv.textContent = `Failed to load data: ${error.message}. Please try again later.`;
          errorDiv.style.display = 'block';
        }
        gridDiv.style.display = 'none';
      });

    window.clearAllFilters = () => {
      if (window.agGridApi) {
        window.agGridApi.setFilterModel(null);
        const quickFilterInput = document.getElementById('quickFilterInput');
        if (quickFilterInput) {
          quickFilterInput.value = '';
        }
        window.agGridApi.setGridOption('quickFilterText', null);
      }
    };
  }
});