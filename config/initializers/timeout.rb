# When the Rack::Timeout limit is hit, it closes the requests and generates a stacktrace in the logs that can be
# used for future debugging of long running code.
Rack::Timeout.timeout = 15  # seconds
