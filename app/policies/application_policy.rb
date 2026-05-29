class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  # 默认拒绝所有动作，避免新接口在没有策略时被意外放开。
  # Default-deny keeps new actions private until a specific policy explicitly opens them.
  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      # 每个具体策略范围都必须自己定义可见性规则。
      # Each concrete policy scope must define its own visibility rules.
      raise NotImplementedError, "#{self.class} must implement #resolve"
    end
  end
end