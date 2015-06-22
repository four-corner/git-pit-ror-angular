class Role < ActiveRecord::Base
  has_many :users
  validates :name, :description, :presence => true
  validates :name, :uniqueness => true
end
