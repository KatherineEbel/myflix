# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

Rails.application.config.content_security_policy do |policy|
  policy.connect_src :self, 'https://api.stripe.com'
  policy.frame_src :self, :https, :unsafe_inline, 'https://js.stripe.com', 'https://hooks.stripe.com', 'https://www.google.com'
  policy.script_src :self, :https, :unsafe_inline, 'https://js.stripe.com'
  policy.font_src    :self, :http, :data
  policy.img_src     :self, :http, :data
  policy.object_src  :none
  # # If you are using webpack-dev-server then specify webpack-dev-server host
  policy.connect_src :self, :http, "http://localhost:3000", "http://0.0.0.0:3000" if Rails.env.development?
  policy.connect_src :self, :http, "http://localhost:52662", "http://0.0.0.0:52662" if Rails.env.test?
end
#
# #   # Specify URI for violation reports
# #   # policy.report_uri "/csp-violation-report-endpoint"
# end

# If you are using UJS then enable automatic nonce generation
# Rails.application.config.content_security_policy_nonce_generator = -> request { SecureRandom.base64(16) }

# Set the nonce only to specific directives
# Rails.application.config.content_security_policy_nonce_directives = %w(script-src)

# Report CSP violations to a specified URI
# For further information see the following documentation:
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
# Rails.application.config.content_security_policy_report_only = true
