class AddPivotaltrackerProjectIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :pivotaltracker_project_id, :integer
  end
end
