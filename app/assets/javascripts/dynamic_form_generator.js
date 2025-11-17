// Function to create common feedback form elements
function createCommonFeedbackElements(containerId) {
  const container = document.getElementById(containerId);

  // Create Rating Select Group
  const ratingGroup = document.createElement('div');
  ratingGroup.className = 'form-group';

  const ratingLabel = document.createElement('label');
  ratingLabel.htmlFor = 'feedback_rating';
  ratingLabel.className = 'control-label';
  ratingLabel.textContent = 'Overall Rating *';

  const ratingSelect = document.createElement('select');
  ratingSelect.name = 'feedback[rating]';
  ratingSelect.id = 'feedback_rating';
  ratingSelect.className = 'form-control';
  ratingSelect.required = true;
  ratingSelect.style.maxWidth = '300px';

  const placeholderOption = document.createElement('option');
  placeholderOption.value = '';
  placeholderOption.textContent = 'Please select...';
  placeholderOption.disabled = true;
  placeholderOption.selected = true;
  ratingSelect.appendChild(placeholderOption);

  const ratingOptions = [
    { value: 'Poor', label: 'Poor' },
    { value: 'Below Average', label: 'Below Average' },
    { value: 'Average', label: 'Average' },
    { value: 'Good', label: 'Good' },
    { value: 'Very Good', label: 'Very Good' }
  ];

  ratingOptions.forEach(option => {
    const optionElement = document.createElement('option');
    optionElement.value = option.value;
    optionElement.textContent = option.label;
    ratingSelect.appendChild(optionElement);
  });

  // Add validation error container for rating field
  const ratingErrorDiv = document.createElement('span');
  ratingErrorDiv.className = 'help-block text-danger';
  ratingErrorDiv.id = 'feedback_rating-error';

  ratingGroup.appendChild(ratingLabel);
  ratingGroup.appendChild(ratingSelect);
  ratingGroup.appendChild(ratingErrorDiv);

  // Create Comment Textarea Group
  const commentGroup = document.createElement('div');
  commentGroup.className = 'form-group';

  const commentLabel = document.createElement('label');
  commentLabel.htmlFor = 'resume_comment';
  commentLabel.className = 'control-label';
  commentLabel.textContent = 'Overall feedback / observations *';

  const commentTextarea = document.createElement('textarea');
  commentTextarea.name = 'feedback[comment]';
  commentTextarea.id = 'resume_comment';
  commentTextarea.className = 'form-control';
  commentTextarea.rows = 6;
  commentTextarea.placeholder = 'Add Feedback';
  commentTextarea.required = true;

  // Add validation error container for comment field
  const commentErrorDiv = document.createElement('span');
  commentErrorDiv.className = 'help-block text-danger';
  commentErrorDiv.id = 'resume_comment-error';

  commentGroup.appendChild(commentLabel);
  commentGroup.appendChild(commentTextarea);
  commentGroup.appendChild(commentErrorDiv);

  // Append both groups to container
  container.appendChild(ratingGroup);
  container.appendChild(commentGroup);
}

// Helper function to validate rating field
function validateRatingField() {
  const ratingField = document.querySelector('[name="feedback[rating]"]');
  if (!ratingField) return true;

  const ratingValue = ratingField.value ? ratingField.value.trim() : '';
  const ratingGroup = ratingField.closest('.form-group');
  
  if (!ratingValue) {
    if (ratingGroup) {
      ratingGroup.classList.add('has-error');
    }
    let errorElement = document.getElementById('feedback_rating-error');
    if (!errorElement) {
      errorElement = document.createElement('span');
      errorElement.className = 'help-block text-danger';
      errorElement.id = 'feedback_rating-error';
      if (ratingGroup) {
        ratingGroup.appendChild(errorElement);
      }
    }
    errorElement.textContent = 'This field is required';
    return false;
  } else {
    if (ratingGroup) {
      ratingGroup.classList.remove('has-error');
    }
    const errorElement = document.getElementById('feedback_rating-error');
    if (errorElement) {
      errorElement.textContent = '';
    }
    return true;
  }
}

// Helper function to clear rating field validation
function clearRatingFieldValidation() {
  const ratingField = document.querySelector('[name="feedback[rating]"]');
  if (!ratingField) return;
  
  const ratingGroup = ratingField.closest('.form-group');
  if (ratingGroup) {
    ratingGroup.classList.remove('has-error');
  }
  const errorElement = document.getElementById('feedback_rating-error');
  if (errorElement) {
    errorElement.textContent = '';
  }
}

// Helper function to validate comment field
function validateCommentField() {
  const commentField = document.querySelector('[name="feedback[comment]"]');
  if (!commentField) return true;

  const commentValue = commentField.value ? commentField.value.trim() : '';
  const commentGroup = commentField.closest('.form-group');
  
  if (!commentValue) {
    if (commentGroup) {
      commentGroup.classList.add('has-error');
    }
    let errorElement = document.getElementById('resume_comment-error');
    if (!errorElement) {
      errorElement = document.createElement('span');
      errorElement.className = 'help-block text-danger';
      errorElement.id = 'resume_comment-error';
      if (commentGroup) {
        commentGroup.appendChild(errorElement);
      }
    }
    errorElement.textContent = 'This field is required';
    return false;
  } else {
    if (commentGroup) {
      commentGroup.classList.remove('has-error');
    }
    const errorElement = document.getElementById('resume_comment-error');
    if (errorElement) {
      errorElement.textContent = '';
    }
    return true;
  }
}

// Helper function to clear comment field validation
function clearCommentFieldValidation() {
  const commentField = document.querySelector('[name="feedback[comment]"]');
  if (!commentField) return;
  
  const commentGroup = commentField.closest('.form-group');
  if (commentGroup) {
    commentGroup.classList.remove('has-error');
  }
  const errorElement = document.getElementById('resume_comment-error');
  if (errorElement) {
    errorElement.textContent = '';
  }
}

window.generateDynamicForm = function generateDynamicForm(containerId, formConfig) {
  console.log('Generating form in container:', containerId);

  const container = document.getElementById(containerId);
  if (!container) {
    console.error('Container not found:', containerId);
    return;
  }

  // Clear container first
  container.innerHTML = '';
  createCommonFeedbackElements(containerId);
  // if (!formConfig || !formConfig.fields || !Array.isArray(formConfig.fields)) {

  //   return;
  // }

  // Create form element with Bootstrap 3 classes
  const form = document.createElement('form');
  form.id = formConfig?.form_name || 'dynamic-form';
  form.className = 'container bg-light rounded shadow candidate-evaluation-form';
  form.noValidate = true; // Disable native HTML5 validation

  // Add form title if exists
  if (formConfig?.form_title) {
    const titleRow = document.createElement('div');
    titleRow.className = 'row';

    const titleCol = document.createElement('div');
    titleCol.className = '';

    const title = document.createElement('h4');
    title.textContent = formConfig.form_title;
    title.className = 'text-center text-primary';
    title.style.fontSize = '1.3em';
    title.style.fontWeight = 'bold';
    titleCol.appendChild(title);
    titleRow.appendChild(titleCol);
    form.appendChild(titleRow);
  }

  form.appendChild(document.createElement('hr'));

  // Generate fields
  formConfig?.fields.forEach(field => {
    const fieldRow = document.createElement('div');
    fieldRow.className = 'row';

    const fieldCol = document.createElement('div');
    fieldCol.className = '';

    const fieldWrapper = document.createElement('div');
    fieldWrapper.className = `form-group ${field.type}-field ${field.required ? 'required' : ''}`;

    // Create label (skip for label-only fields)
    if (field.type !== 'hidden' && field.type !== 'label') {
      const label = document.createElement('label');
      label.htmlFor = field.name;
      label.className = 'control-label';
      label.textContent = field.label;
      if (field.required) {
        const requiredSpan = document.createElement('span');
        requiredSpan.className = 'text-danger';
        requiredSpan.textContent = ' *';
        label.appendChild(requiredSpan);
      }
      fieldWrapper.appendChild(label);
    }

    // Create input based on field type
    let inputElement;
    switch (field.type) {
      case 'label':
        // Render a label/heading only, no input, styled as a header
        inputElement = document.createElement('div');
        inputElement.className = 'form-label-only';
        const labelOnly = document.createElement('h4');
        labelOnly.className = 'form-label-header';
        labelOnly.style.fontWeight = 'bold';
        labelOnly.style.fontSize = '1.3em';
        labelOnly.textContent = field.label;
        inputElement.appendChild(labelOnly);
        fieldWrapper.appendChild(inputElement);
        fieldCol.appendChild(fieldWrapper);
        fieldRow.appendChild(fieldCol);
        form.appendChild(fieldRow);
        return; // Skip the rest of the loop for label type
      case 'radio':
        // Render a group of radio buttons
        inputElement = document.createElement('div');
        inputElement.className = 'radio-group';
        if (field.options && Array.isArray(field.options)) {
          field.options.forEach((option, idx) => {
            const radioWrapper = document.createElement('div');
            radioWrapper.className = 'radio';

            const radioInput = document.createElement('input');
            radioInput.type = 'radio';
            radioInput.name = field.name;
            radioInput.id = `${field.name}_${idx}`;
            radioInput.value = option.value;
            if (field.required) radioInput.required = true;

            const radioLabel = document.createElement('label');
            radioLabel.htmlFor = radioInput.id;
            radioLabel.textContent = option.label;

            radioWrapper.appendChild(radioInput);
            radioWrapper.appendChild(radioLabel);
            inputElement.appendChild(radioWrapper);
          });
        }
        break;
      case 'select':
        inputElement = document.createElement('select');
        inputElement.name = field.name;
        inputElement.id = field.name;
        inputElement.className = 'form-control';
        inputElement.multiple = field.multiple || false;

        // Set dynamic height based on number of options
        const optionCount = field.options ? field.options.length : 0;
        // Add a placeholder option
        const placeholderOption = document.createElement('option');
        placeholderOption.value = '';
        placeholderOption.textContent = 'Please select...';
        placeholderOption.disabled = true;
        if (!field.multiple) {
          placeholderOption.selected = true;
        }
        inputElement.appendChild(placeholderOption);

        if (field.multiple) {
          // For multiple select, add scrollbar if more than 3 options
          if (optionCount > 3) {
            inputElement.size = 4; // Show 4 options with scrollbar
            inputElement.style.overflowY = 'auto';
          } else {
            inputElement.size = Math.max(2, optionCount + 1); // Show all options + placeholder
          }
        } else {
          // For single select, use native dropdown but ensure it fits
          inputElement.style.maxHeight = '200px'; // Limit height for dropdown list
          inputElement.style.overflowY = 'auto';
          inputElement.className = 'form-control';
        }

        if (field.options && Array.isArray(field.options)) {
          field.options.forEach(option => {
            const optionElement = document.createElement('option');
            optionElement.value = option.value;
            optionElement.textContent = option.label;
            inputElement.appendChild(optionElement);
          });
        }
        break;

      case 'textarea':
        inputElement = document.createElement('textarea');
        inputElement.name = field.name;
        inputElement.id = field.name;
        inputElement.className = 'form-control';
        inputElement.placeholder = field.placeholder || '';
        inputElement.rows = 4;
        break;

      case 'number':
        inputElement = document.createElement('input');
        inputElement.style.maxWidth = '75px';
        inputElement.type = 'number';
        inputElement.name = field.name;
        inputElement.id = field.name;
        inputElement.className = 'form-control';
        inputElement.min = (typeof field.min !== 'undefined') ? field.min : 0;
        inputElement.max = (typeof field.max !== 'undefined') ? field.max : 10;
        inputElement.step = (typeof field.step !== 'undefined') ? field.step : 1;
        inputElement.placeholder = field.placeholder || ((typeof field.min !== 'undefined' && typeof field.max !== 'undefined') ? `${field.min}-${field.max}` : '0-10');
        break;

      case 'checkbox':
        inputElement = document.createElement('input');
        inputElement.type = 'checkbox';
        inputElement.name = field.name;
        inputElement.id = field.name;
        inputElement.className = '';

        // For checkboxes, we need a different structure
        const checkWrapper = document.createElement('div');
        checkWrapper.className = 'checkbox';

        const checkLabel = document.createElement('label');
        checkLabel.htmlFor = field.name;
        checkLabel.textContent = field.label;

        checkLabel.insertBefore(inputElement, checkLabel.firstChild);
        checkWrapper.appendChild(checkLabel);
        fieldWrapper.innerHTML = ''; // Clear previous label
        fieldWrapper.appendChild(checkWrapper);
        break;

      default:
        inputElement = document.createElement('input');
        inputElement.type = field.type || 'text';
        inputElement.name = field.name;
        inputElement.id = field.name;
        inputElement.className = 'form-control';
        inputElement.placeholder = field.placeholder || '';
    }

    // Set required attribute
    if (field.required && field.type !== 'checkbox') {
      inputElement.required = true;
    }

    // Add data attributes for validation
    if (field.validations) {
      inputElement.dataset.validations = JSON.stringify(field.validations);
    }

    // Append input if not checkbox (already handled)
    if (field.type !== 'checkbox') {
      fieldWrapper.appendChild(inputElement);
    }

    // Add help text if available
    if (field.help_text) {
      const helpText = document.createElement('span');
      helpText.className = 'help-block';
      helpText.textContent = field.help_text;
      fieldWrapper.appendChild(helpText);
    }

    // Add validation error container
    const errorDiv = document.createElement('span');
    errorDiv.className = 'help-block text-danger';
    errorDiv.id = `${field.name}-error`;
    fieldWrapper.appendChild(errorDiv);

    fieldCol.appendChild(fieldWrapper);
    fieldRow.appendChild(fieldCol);
    form.appendChild(fieldRow);
  });

  // Add submit button
  const submitRow = document.createElement('div');
  submitRow.className = 'row';

  const submitCol = document.createElement('div');
  submitCol.className = 'text-center';

  const submitButton = document.createElement('button');
  submitButton.type = 'submit';
  submitButton.textContent = formConfig?.submit_text || 'Submit';
  submitButton.className = 'btn btn-primary btn-lg';

  submitCol.appendChild(submitButton);
  submitRow.appendChild(submitCol);
  form.appendChild(submitRow);

  // Add form to container
  container.appendChild(form);

  // Add form submission handler
  form.addEventListener('submit', function (e) {
    console.log('Submit handler called', e);
    e.preventDefault();
    // Remove previous validation styles
    form.querySelectorAll('.has-error').forEach(el => {
      el.classList.remove('has-error');
    });

    // Validate rating and comment fields (created separately, not in formConfig)
    const isRatingValid = validateRatingField();
    const isCommentValid = validateCommentField();

    if (validateForm(form, formConfig?.fields) && isRatingValid && isCommentValid) {
      handleFormSubmission(form, formConfig);
    }
  });

  // Add input validation on change and blur
  form.querySelectorAll('.form-control, [type="checkbox"]').forEach(input => {
    input.addEventListener('blur', function () {
      validateField(this, formConfig.fields.find(f => f.name === this.name));
    });

    input.addEventListener('input', function () {
      // Clear validation on input
      const formGroup = this.closest('.form-group');
      if (formGroup) {
        formGroup.classList.remove('has-error');
      }
      const errorElement = document.getElementById(`${this.name}-error`);
      if (errorElement) {
        errorElement.textContent = '';
      }
    });
  });

  // Add validation for rating field (created separately, not in form config)
  const ratingField = document.querySelector('[name="feedback[rating]"]');
  if (ratingField) {
    ratingField.addEventListener('blur', validateRatingField);
    ratingField.addEventListener('change', validateRatingField);
  }

  // Add validation for comment field (created separately, not in form config)
  const commentField = document.querySelector('[name="feedback[comment]"]');
  if (commentField) {
    commentField.addEventListener('blur', validateCommentField);
    commentField.addEventListener('input', clearCommentFieldValidation);
  }

  console.log('Form generated successfully.');
};

window.validateForm = function validateForm(form, fields) {
  let isValid = true;

  fields?.forEach(fieldConfig => {
    const field = form.elements[fieldConfig.name];
    if (field && !validateField(field, fieldConfig)) {
      isValid = false;
    }
  });

  return isValid;
}

window.validateField = function validateField(field, fieldConfig) {
  const errorElement = document.getElementById(`${field.name}-error`);
  let formGroup = field.closest ? field.closest('.form-group') : null;
  if (!field.closest) {
    console.log('No closest method on field:', field);
  }
  if (errorElement) {
    errorElement.textContent = '';
  }
  if (formGroup) {
    formGroup.classList.remove('has-error');
  }

  let isValid = true;
  let errorMessage = '';

  if (fieldConfig.required) {
    if (field.type === 'checkbox' && !field.checked) {
      isValid = false;
      errorMessage = 'This field is required';
    } else if (field.type === 'select-multiple' && field.selectedOptions && field.selectedOptions.length === 0) {
      isValid = false;
      errorMessage = 'Please select at least one option';
    } else if (field.type === 'number') {
      console.log('validateField required:number', field.name, 'value:', field.value, 'type:', typeof field.value);
      if (field.value === '' || field.value === null) {
        isValid = false;
        errorMessage = 'This field is required';
      }
    } else if ((field.type !== 'checkbox' && field.type !== 'select-multiple') && (!field.value || (typeof field.value === 'string' && !field.value.trim()))) {
      isValid = false;
      errorMessage = 'This field is required';
    }
  }

  if (isValid && fieldConfig.validations) {
    for (const validation of fieldConfig.validations) {
      switch (validation.type) {
        case 'min':
          if (parseFloat(field.value) < validation.value) {
            isValid = false;
            errorMessage = validation.message;
          }
          break;
        case 'max':
          if (parseFloat(field.value) > validation.value) {
            isValid = false;
            errorMessage = validation.message;
          }
          break;
        case 'pattern':
          const regex = new RegExp(validation.pattern);
          if (!regex.test(field.value)) {
            isValid = false;
            errorMessage = validation.message;
          }
          break;
      }
      if (!isValid) break;
    }
  }

  if (!isValid && errorElement && formGroup) {
    errorElement.textContent = errorMessage;
    formGroup.classList.add('has-error');
  }

  return isValid;
}


window.handleFormSubmission = function handleFormSubmission(form, formConfig) {
  let data = {}
  if (formConfig) {
    // Build a map of field configs for easy lookup
    const fieldConfigMap = {};
    formConfig.fields.forEach(f => { fieldConfigMap[f.name] = f; });

    // Track which fields are select-multiple
    const selectMultipleFields = formConfig.fields.filter(f => f.type === 'select' && f.multiple).map(f => f.name);

    // Collect all fields as an ordered array with all info needed to reconstruct the form
    const submittedFields = [];
    formConfig.fields.forEach((fieldCfg, idx) => {
      const name = fieldCfg.name;
      const label = fieldCfg.label;
      const input = form.elements[name];
      if (!input) return;

      let value;
      if (fieldCfg.type === 'select' && fieldCfg.multiple) {
        // select-multiple: collect all selected options, use display text as value
        value = Array.from(input.selectedOptions).map(opt => opt.text);
      } else if (fieldCfg.type === 'checkbox') {
        value = input.checked;
      } else {
        value = input.value;
      }

      submittedFields.push({
        name,
        label,
        value,
        type: fieldCfg.type,
        order: idx,
        required: !!fieldCfg.required,
        help_text: fieldCfg.help_text || '',
        options: fieldCfg.options || undefined,
        multiple: !!fieldCfg.multiple,
        validations: fieldCfg.validations || undefined
      });
    });
    data = { fields: submittedFields };
    console.log('Form submitted with data:', data);
  }

  const previewElementId = 'formPreviewTable';
  if (document.getElementById(previewElementId)) {
    renderTable(data, previewElementId);
    return; // Skip actual submission for preview
  }

  // Get interview_id & resume_id from hidden field
  const interviewIdField = document.querySelector('input[name="feedback[interview_id]"]');
  const interviewId = interviewIdField ? interviewIdField.value : null;
  const resumeIdField = document.querySelector('input[name="feedback[resume_id]"]');
  const resumeId = resumeIdField ? resumeIdField.value : null;
  const commentField = document.querySelector('[name="feedback[comment]"]');
  const comment = commentField ? commentField.value : null;

  // Get selected rating
  const ratingSelect = document.getElementById('feedback_rating');
  const selectedRating = ratingSelect ? ratingSelect.value : null;

  // Send the data to the server
  fetch(`${prepend_with_image_path}/feedback/submit`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      // 'X-CSRF-Token': getCSRFToken()
    },
    body: JSON.stringify({
      form_data: data,
      interview_id: interviewId,
      resume_id: resumeId,
      feedback_rating: selectedRating,
      feedback_common_comment: comment,
    })
  }).then(response => response.json())
    .then(result => {
      if (result.status !== 'success') {
        alert('Error submitting form: ' + result.message);
        console.error('Error submitting form:', result.message);
        return;
      }
      const successAlert = document.createElement('div');
      successAlert.className = 'alert alert-success alert-dismissible';
      successAlert.innerHTML = `
          <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
          <strong>Success!</strong> Form submitted successfully. Redirecting...`;
      form.parentNode.insertBefore(successAlert, form.nextSibling);
      setTimeout(function () {
        window.location.href = `${prepend_with_image_path}/feedback/${result.feedback_id}`;
      }, 3000); // Redirect to root url after 3 seconds
    })
    .catch(error => {
      alert('Error submitting form: ' + error.message);
      console.error('Error submitting form:', error);
    });
}

// // Helper function to get CSRF token
// function getCSRFToken() {
//   return document.querySelector('[name="csrf-token"]')?.content ||
//     document.querySelector('meta[name="csrf-token"]')?.content;
// }

// Make feedback/table helpers available globally
window.renderTable = function renderTable(data, elementId) {
  const element = document.getElementById(elementId);
  if (!element) {
    console.error(`Element with id "${elementId}" not found.`);
    return;
  }

  // Create a container for the table
  let containerHtml = `
    <div class="table-container">
      <table class="modern-table">
        <thead>
          <tr class="header_row">
            <th>Criteria</th>
            <th>Response</th>
          </tr>
        </thead>
        <tbody>
  `;

  data?.fields?.forEach(item => {
    let value = item.value;
    let valueClass = '';

    // Handle different types of values
    if (Array.isArray(value)) {
      value = value.join(', ');
      valueClass = 'table-cell-truncated';
    } else if (typeof value === 'boolean') {
      // For checkbox/boolean values
      value = value ?
        '<span class="status-badge success">Yes</span>' :
        '<span class="status-badge danger">No</span>';
    } else if (typeof value === 'number' || (typeof value === 'string' && !isNaN(parseFloat(value)) && isFinite(value))) {
      // For numeric ratings - handles both numbers and numeric strings
      valueClass = 'table-cell-primary';
      // Optionally format the number if needed
      value = parseFloat(value);
    } else if (value === null || value === undefined || value === '') {
      value = '<span class="text-muted"> - </span>';
    } else if (item.type === 'select') {
      // For dropdown selections
      valueClass = 'table-cell-primary';
    }

    // For longer text responses
    if (typeof value === 'string' && value.length > 100) {
      valueClass = 'description-text';
    }

    containerHtml += `
      <tr>
        <th class="table-cell-secondary">${item.label}</th>
        <td class="${valueClass}">${value}</td>
      </tr>
    `;
  });

  containerHtml += `
        </tbody>
      </table>
    </div>
  `;

  element.innerHTML = containerHtml;
}

window.renderTable = renderTable;
window.renderAllFeedbackTables = function () {
  document.querySelectorAll('[id^="form_feedback_"]').forEach(function (div) {
    var json = div.getAttribute('data-feedback-json');
    if (json) {
      try {
        var data = JSON.parse(json);
        window.renderTable(data, div.id);
      } catch (e) {
        console.error('Invalid feedback_form_json:', e);
      }
    }
  });
};


