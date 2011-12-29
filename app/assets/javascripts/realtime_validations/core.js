$(document).ready(rt_validations_bind_fields);

function rt_validations_bind_fields()
{
  $('form[validation="true"] :input').each(function(i, field) {
    rt_validations_bind_field(field);
  });
}

function rt_validations_bind_field(field)
{
  var field_to_validate = $('#' + field.id);
  field_to_validate.blur(rt_validations_bind_field_on_blur);
}

function rt_validations_bind_field_on_blur()
{
  var field = $(this);
  var form_to_validate = $('form[validation="true"]');
  var validation_path = rt_validations_path(form_to_validate);
  var model = form_to_validate.attr('model');
  var field_name = field.attr('name');
  var matched = field_name.match(/(\w+)\[(\w+)_confirmation\]/);
  var data_to_send = null;
  var current_value = field.val();
  var token = $('meta[name=session_token]').attr('content');

  if (matched) {
    var field_canonical_namespace = matched[1];
    var field_canonical_name = matched[2];
    var validation_value = $('#' + field_canonical_namespace + '_' + field_canonical_name).val();
    data_to_send = { field: field_name.replace("_confirmation", ""), value: current_value,
                     validates: validation_value, token: token, model: model };
  } else {
    data_to_send = { field: field_name, value: current_value, token: token, model: model };
  }

  $.post(validation_path, data_to_send, function(data) {
    if ($.isEmptyObject(data.errors)) {
      rt_validations_hide_warning_message(field);
    } else {
      rt_validations_show_warning_message(field, data.errors);
    }
  });
}

function rt_validations_path(form)
{
  return '/validations' + form.attr('action');
}

function rt_validations_show_warning_message(field, errors)
{
  var validation_errors = field.attr('validation-errors');
  if (!$.isEmptyObject(validation_errors) && (validation_errors.toString() == errors.toString())) {
    return;
  }
  field.attr('valid', false);
  field.attr('validation-errors', errors);
  if ($('#' + field.attr('id') + '_error').length) {
    $('#' + field.attr('id') + '_error').remove();
  }
  field.parent().append('<div style="display: none;" id="' + field.attr('id') + '_error" class="field-error">'
                          + errors.join(', ') +
                          '<div class="field-error-arrow-border"></div> \
                           <div class="field-error-arrow"></div>        \
                         </div>');
  $('#' + field.attr('id') + '_error').fadeIn('slow');
}

function rt_validations_hide_warning_message(field)
{
  field.attr('valid', true);
  field.attr('validation-errors', null);
  $('#' + field.attr('id') + '_error').fadeOut('slow', function() {
    $(this).remove();
  });
}