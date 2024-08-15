# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application'
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin 'stimulus-rails-nested-form' # @4.1.0
pin 'stimulus-flatpickr' # @3.0.0
pin 'flatpickr' # @4.6.13
pin 'flatpickr/dist/themes/dark.css', to: 'flatpickr--dist--themes--dark.css.js' # @4.6.13
pin 'flatpickr/dist/l10n/de.js', to: 'flatpickr--dist--l10n--de.js.js' # @4.6.13
pin 'flatpickr/dist/l10n/default.js', to: 'flatpickr--dist--l10n--default.js.js' # @4.6.13
pin '@fortawesome/fontawesome-free', to: '@fortawesome--fontawesome-free.js' # @6.5.1
pin '@rails/request.js', to: '@rails--request.js.js' # @0.0.9
pin 'jquery', to: 'https://code.jquery.com/jquery-3.6.0.min.js'
pin 'select2', to: 'https://cdnjs.cloudflare.com/ajax/libs/select2/4.1.0-rc.0/js/select2.min.js'
