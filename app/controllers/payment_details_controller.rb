# frozen_string_literal: true

class PaymentDetailsController < ApplicationController
  def create
    @payment_detail = PaymentDetail.new(payment_detail_params.merge(user: current_user))
    if @payment_detail.save
      flash.now[:notice] = I18n.t('record.create.success', resource: @payment_detail.class.model_name.human)
    else
      render 'settings/index', status: :unprocessable_entity
    end
  end

  def update
    @payment_detail = current_user.payment_detail
    if @payment_detail.update(payment_detail_params)
      flash.now[:notice] = I18n.t('record.update.success', resource: @payment_detail.class.model_name.human)
    else
      render 'settings/index', status: :unprocessable_entity
    end
  end

  private

  def payment_detail_params
    params.require(:payment_detail).permit(
      :iban,
      :bank_name,
      :account_holder,
      :swift,
      :account_number,
      :sort_code,
      :routing_number,
    )
  end
end
