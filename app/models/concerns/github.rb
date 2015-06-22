module Github
  extend ActiveSupport::Concern

  def github_integration
    repo = create_repo
    @repo_url = repo.clone_url
    git_flow(repo)
    subscribe_to_pivotaltracker if SETTINGS[:pivotaltracker_token].present?
    p "GIT flow ends, set develop default branch starts"
    set_default_branch(repo)
    p "default branch flow ends"
    system("git remote set-url origin #{repo.ssh_url}")
  end

  def create_repo
    GithubApiClient.create_repository(self.repo_name)
  end

  def git_flow(repo)
    p "GIT PROCESS STARTS"
    system("mkdir /tmp/#{repo.name}")
    system("git config --global user.email '#{SETTINGS[:github_email]}'")
    system("git config --global user.name '#{SETTINGS[:github_login]}'")
    p "echo global configurations set..."
    Dir.chdir("/tmp/#{repo.name}"){
      system("echo " + '"# ' + "#{repo.name}" + '"' + ">> README.md")
      system("git init")
      p "initialized..."
      system("git add README.md")
      p "readme file added to git console..."
      system("git config user.email '#{SETTINGS[:github_email]}'")
      system("git config user.name '#{SETTINGS[:github_login]}'")
      p "repo configurations set..."
      system("git commit -m " + '"first commit"')
      p "first commit command..."

      system("git remote add origin https://#{SETTINGS[:github_login]}:#{SETTINGS[:github_password]}@github.com/#{SETTINGS[:github_login]}/#{repo.name}.git")
      
      p "remote repo origin ssh add done..."
      system("git push -u origin master")
      p "echo master pushed to remote repo..."
      ["develop", "QA"].each_with_index do |branch, i|
        system("git checkout -b #{branch}")
        p "new feature-branch #{branch} created..."
        system("git checkout #{branch}")
        p "on feature-branch #{branch}..."
        system("git push -u origin #{branch}")
        p "feature-branch #{branch} pushed to remote repo..."
      end
    }
    p "GIT PROCESS ENDS"
  end

  def set_default_branch(repo)
    GithubApiClient.edit_repository("#{SETTINGS[:github_login]}/#{repo.name}", {:default_branch => "develop"})
  end

  def rename_repo(existing_repo_name)
    repo = GithubApiClient.edit_repository("#{SETTINGS[:github_login]}/#{existing_repo_name}", {:name => self.repo_name})
    @repo_url = repo.clone_url
  end

  def delete_github_repository
    GithubApiClient.delete_repository("#{SETTINGS[:github_login]}/#{self.repo_name}")
  end

  def subscribe_to_pivotaltracker
    GithubApiClient.subscribe_service_hook("#{SETTINGS[:github_login]}/#{self.repo_name}", 'pivotaltracker', { :token => SETTINGS[:pivotaltracker_token] })
  end

end
