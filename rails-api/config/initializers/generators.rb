Rails.application.config.generators do |g|
  g.test_framework :rspec, fixture: false
  g.helper false
  g.stylesheets false
  g.scaffold_stylesheet false
  g.template_engine :erb

  # Don't generate system test files.
  g.view_specs false
  g.helper_specs false

  # Uncomment to configure generators to use ULID primary keys
  # g.orm :active_record, primary_key_type: :string
end
