class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :role_type

  belongs_to :role

  validates :first_name, :last_name, :presence => true

  before_save :assign_role

  def assign_role
    self.role = Role.find_by name: "Regular" if self.role.nil?
  end

  def admin?
    self.role.name == "Admin"
  end

  def regular?
    self.role.name == "Regular"
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def as_json(options={})
    super(:include => [:role])
  end

  def attributes
    @role_type = self.role.name if self.role.present?
    super.merge({ 'role_type' => @role_type })
  end
end
