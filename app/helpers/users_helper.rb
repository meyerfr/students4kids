module UsersHelper
  def all_admins
    User.select{ |u| u.is_role?('admin') }
  end

  def all_parents
    User.select{ |u| u.is_role?('parent') }
  end

  def all_sitters
    User.select{ |u| u.is_role?('sitter') }
  end
end
