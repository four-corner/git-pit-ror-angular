class Project < ActiveRecord::Base
  include Github
  include Pivotaltracker

  before_save :set_repo_name
  after_create :create_github_repo, :update_git_repo_url, :create_pivotaltracker_project, :update_pivotaltracker_project_id
  after_update :rename_git_repo, :update_git_repo_url, :rename_pivotaltracker_project

  belongs_to :user
  validates :customer, :product, :platform, :presence => true
  validates :product, :uniqueness => true

  alias_attribute :project_name, :repo_name

  def as_json(options={})
    super(:include => [:user])
  end

  private

  def set_repo_name
    self.repo_name = build_repo_name
  end

  def create_github_repo
    github_integration
  end

  def rename_git_repo
    rename_repo(@old_repo_name)
  end

  def update_git_repo_url
    self.update_column(:git_repo_url, @repo_url)
  end

  def build_repo_name
    format_name("#{self.customer}-#{self.product}-#{self.platform}")
  end

  def format_name(str)
    # doing this to avoid "JuneJuly 2015" becoming "junejuly-2015"
    # rather need "june-july-2015"
    str.parameterize
  end

  def create_pivotaltracker_project
    pivotaltracker_integration
  end

  def update_pivotaltracker_project_id
    self.update_column(:pivotaltracker_project_id, @pt_project_id)
  end

  def rename_pivotaltracker_project
    rename_project
  end

end
