class AddColumnsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :repo_name, :string
    add_column :projects, :git_repo_url, :string
  end
end
