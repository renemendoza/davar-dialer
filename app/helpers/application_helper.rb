module ApplicationHelper
  def content_for_visitors(&block)
    yield if current_user.nil?
    return ''
  end 

  def content_for_users(&block)
    if current_user
      yield unless current_user.admin?
      return ''
    end
  end 

  def content_for_users_or_admin(&block)
    yield if current_user 
    return ''
  end 

  def content_for_admin(&block)
    if current_user
      yield if current_user.admin?
      return ''
    end
  end 
end
