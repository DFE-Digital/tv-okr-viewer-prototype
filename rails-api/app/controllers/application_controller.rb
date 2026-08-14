class ApplicationController < ActionController::Base
  include DfE::Analytics::Requests
  default_form_builder(GOVUKDesignSystemFormBuilder::FormBuilder)
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
end
