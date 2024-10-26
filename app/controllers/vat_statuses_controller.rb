# frozen_string_literal: true

class VatStatusesController < ApplicationController
  before_action :set_vat_status, only: [:show, :update]

  def show
  end

  def edit
    @vat_status = current_user.vat_status
  end

  def create
    @vat_status = current_user.build_vat_status(vat_status_params)
    if @vat_status.save
      redirect_to @vat_status, notice: I18n.t('record.create.success', resource: @vat_status.class.model_name.human)
    else
      render :show, status: :unprocessable_entity
    end
  end

  def update
    @vat_status = current_user.vat_status
    if @vat_status.update(vat_status_params)
      redirect_to @vat_status, notice: I18n.t('record.update.success', resource: @vat_status.class.model_name.human)
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def vat_status_params
    params.require(:vat_status).permit(
      :vat_registered,
      :declaration_period,
      :vat_number,
      :starts_on,
      :kleinunternehmer,
      :tax_exempt_reason,
    )
  end

  def set_vat_status
    @vat_status = current_user.vat_status || current_user.build_vat_status
  end
end
