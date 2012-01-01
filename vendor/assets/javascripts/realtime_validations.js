var RealTimeValidations = {

  bind_fields : function() {
    $('form[validation="true"] :input').each(function(i, field) {
      RealTimeValidations.bind_field(field);
    });
  },

  bind_field : function(field) {
    var field_to_validate = $('#' + field.id);
    if (RealTimeValidations.should_bind_field(field_to_validate)) {
      field_to_validate.blur(RealTimeValidations.bind_field_on_blur);
    }
  },

  should_bind_field : function(field) {
    var validate = field.attr('validate');
    if ($.isEmptyObject(validate)) {
      return true;
    }
    return validate == 'true';
  },

  bind_field_on_blur : function() {
    var field = $(this);
    var form_to_validate = $('form[validation="true"]');
    var validation_path = RealTimeValidations.path(form_to_validate);
    var model = form_to_validate.attr('model');
    var field_name = field.attr('name');
    var matched = field_name.match(/(\w+)\[(\w+)_confirmation\]/);
    var data_to_send = null;
    var current_value = field.val();

    if (matched) {
      var field_canonical_namespace = matched[1];
      var field_canonical_name = matched[2];
      var validation_value = $('#' + field_canonical_namespace + '_' + field_canonical_name).val();
      data_to_send = { field: field_name.replace("_confirmation", ""), value: current_value,
                       validates: validation_value, model: model };
    } else {
      data_to_send = { field: field_name, value: current_value, model: model };
    }

    var custom_data_to_send = RealTimeValidations.customFields();
    $.extend(data_to_send, custom_data_to_send);

    $.post(validation_path, data_to_send, function(data) {
      if ($.isEmptyObject(data.errors)) {
        RealTimeValidations.hide_warning_message(field);
      } else {
        RealTimeValidations.show_warning_message(field, data.errors);
      }
    });
  },

  path : function(form) {
    return '/validations' + form.attr('action');
  },

  show_warning_message : function(field, errors) {
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
  },

  hide_warning_message : function(field) {
    field.attr('valid', true);
    field.attr('validation-errors', null);
    $('#' + field.attr('id') + '_error').fadeOut('slow', function() {
      $(this).remove();
    });
  },

  customFields : function() {
    return { };
  }

};

$(document).ready(RealTimeValidations.bind_fields);

$(document).ajaxSend(function(e, xhr, options) {
  var token = $("meta[name='csrf-token']").attr("content");
  xhr.setRequestHeader("X-CSRF-Token", token);
});