class G5Authenticatable::BasePolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    super_admin?
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    super_admin?
  end

  def new?
    create?
  end

  def update?
    super_admin?
  end

  def edit?
    update?
  end

  def destroy?
    super_admin?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class BaseScope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.has_role?(:super_admin)
        scope.all
      else
        scope.none
      end
    end
  end

  def super_admin?
    user.present? && user.has_role?(:super_admin)
  end

  def admin?
    user.present? && user.has_role?(:admin)
  end

  def editor?
    user.present? && user.has_role?(:editor)
  end

  def viewer?
    user.present? && user.has_role?(:viewer)
  end

  def has_global_role?
    super_admin? || admin? || editor? || viewer?
  end
end
