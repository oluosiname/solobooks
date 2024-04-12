# frozen_string_literal: true

class InvoiceCategoriesController < ApplicationController
  def new
    @category = InvoiceCategory.new
    @modal = params[:modal] == 'true'
  end

  def create
    @category = InvoiceCategory.new(category_params)
    respond_to do |format|
      if @category.save
        @categories = InvoiceCategory.all
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(
            'invoice_invoice_category_id',
            partial: 'invoices/category_options',
            locals: { categories: @categories, selected: @category.id },
          )
        end
        format.html do
          redirect_to category_url(@category),
            notice: i18n.t('record.create.success', resource: @category.class.model_name.human)
        end
      end
    end
  end

  private

  def category_params
    params.require(:invoice_category).permit(:name)
  end
end
