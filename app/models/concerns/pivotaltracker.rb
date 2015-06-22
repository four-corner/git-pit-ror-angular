module Pivotaltracker
  extend ActiveSupport::Concern

  def pivotaltracker_integration
    pt_project = create_project
    @pt_project_id = pt_project.id
  end

  def create_project
    project_endpoint.create(name: self.project_name)
  end

  def rename_project
    project_endpoint.update(self.pivotaltracker_project_id, name: self.project_name)
  end

  def delete_pivotaltracker_project
    project_endpoint.delete(self.pivotaltracker_project_id)
  end

  private

  def project_endpoint
    TrackerApi::Endpoints::Project.new(PivotaltrackerApiClient)
  end
end