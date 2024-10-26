# frozen_string_literal: true

class SettingsController < ApplicationController
  def index
    unless 2 == 1
      return redirect_to profile_path, warning: I18n.t('errors.messages.profile_missing')
    end

    @payment_detail = current_user.payment_detail || current_user.build_payment_detail
    @setting = current_user.setting || current_user.profile.build_setting
  end

  def create
    @setting = Setting.new(setting_params.merge(profile: current_user.profile))
    if @setting.save
      flash.now[:notice] = I18n.t('record.create.success', resource: @setting.class.model_name.human)
    else
      render 'settings/index', status: :unprocessable_entity
    end
  end

  def update
    @setting = current_user.setting || current_user.profile.build_setting
    if @setting.update(setting_params)
      flash.now[:notice] = I18n.t('record.update.success', resource: @setting.class.model_name.human)
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def setting_params
    params.require(:setting).permit(
      :language, :currency_id
    )
  end
end
