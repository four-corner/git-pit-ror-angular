SETTINGS = YAML.load_file("#{Rails.root}/config/settings.yml")[Rails.env].symbolize_keys

#GithubApiClient = Octokit::Client.new(:access_token => SETTINGS[:github_oauth_token])
	
GithubApiClient = Octokit::Client.new(:login => SETTINGS[:github_login], :password => SETTINGS[:github_password])

PivotaltrackerApiClient = TrackerApi::Client.new(token: SETTINGS[:pivotaltracker_token])
	
