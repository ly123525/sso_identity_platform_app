module HandlesApiErrors
  extend ActiveSupport::Concern

  included do
    # API 异常统一收口成同一种 JSON 结构，调用方不需要针对不同控制器分支处理。
    # Keep API failures in one JSON shape so clients do not branch on controller-specific errors.
    rescue_from ActionController::ParameterMissing, with: :render_parameter_missing
    rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid
    rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found
    rescue_from Pundit::NotAuthorizedError, with: :render_not_authorized
  end

  private

  def render_parameter_missing(error)
    render_api_error(
      code: 'bad_request',
      message: error.message,
      status: :bad_request
    )
  end

  def render_record_invalid(error)
    render_api_error(
      code: 'validation_failed',
      message: error.record.errors.full_messages.to_sentence,
      status: :unprocessable_entity
    )
  end

  def render_record_not_found(error)
    render_api_error(
      code: 'not_found',
      message: error.message,
      status: :not_found
    )
  end

  def render_not_authorized
    render_api_error(
      code: 'forbidden',
      message: 'You are not authorized to perform this action.',
      status: :forbidden
    )
  end

  def render_api_error(code:, message:, status:)
    # 错误响应格式对齐项目 API 草案，保证各接口输出稳定一致。
    # Error payload matches the project API draft and stays stable across endpoints.
    render json: {
      error: {
        code: code,
        message: message
      }
    }, status: status
  end
end