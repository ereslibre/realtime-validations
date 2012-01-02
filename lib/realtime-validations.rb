# == Introduction
#
# RealtimeValidations is a Rails 3.1 gem that allows you to easily validate your forms. It is very
# easy to use, clean and yet powerful.
#
# == Why
#
# It is smart in the sense that is able to fulfill any kind of validation.
#
# Also, it allows to add some information based on the current session, user, client... so the model
# has all the required information to perform a complete validation test.
#
# It is very generic and is not tied to any specific case of use.
#
# == Remember
#
# This gem is simple. Very simple. It is developed with some things in mind:
#
# * Forget about validations at client side.
#   * All this logic is placed at the model, and is how it should be.
# * Do not replicate logic in javascript.
#   * Never, ever replicate logic.
#   * Someone updates some validation on some model, and javascript is forgotten to be updated.
#   * You need to replicate the same logic in two different languages with their implementation
#     differences.
# * Highly configurable.
#   * There are three hooks to configure the behaviour as you want.
#     1. Server: when the Controller module is included into the ValidationsController class.
#        * Here you can remove or add filters.
#     2. Server: before asking for the model validity.
#        * You can add extra information to the model here based on the knowledge of the current
#          situation of the ApplicationController, such as the current client id or user id.
#     3. Client: before sending the request to the ValidationsController.
#        * Here you are able to add more information to the request, for instance retrieving it
#          from a meta tag on the page or wherever you want, is up to you.
#
# == Dependencies
#
# RealtimeValidations gem does not have too many dependencies:
#
# * Rails 3.1.
# * jquery-rails.
#
# == Installation
#
# Installation is very easy on your own project:
#
# === Gemfile
#
#   gem 'realtime-validations'
#
# === Running generators
#
#   rails g realtime_validations:install
#
# === Assets pipeline
#
# Include the core javascript of the application:
#
#   # app/assets/javascripts/application.js
#   //= require realtime_validations
#
# If you want to use the default error messages, you need to include the stylesheet too:
#
#   # app/assets/stylesheets/application.css
#   *= require realtime_validations
#
# == Usage
#
# Usage is very transparent from your project:
#
# === Views
#
# You should use +form_validated_for+ instead of +form_for+ on your forms in order for them to
# automatically validate.
#
# === Error messages
#
# You can write your own error messages handlers. There are two hooks in JQuery that will be executed
# in order to show and hide errors, and that can be found commented out on the JS file installed by
# the generator.
#
#   RealtimeValidations.showErrors = function(field, errors) {
#   }
#
#   RealtimeValidations.hideErrors = function(field) {
#   }
#
# There is a default implementation for both, and you can use that one if you want. If you need a more
# personalized error reporting or more sophisticated you will have to code your own. :)
module RealtimeValidations

  # @private
  # :nodoc:
  class RealtimeValidations < Rails::Engine
  end

end
