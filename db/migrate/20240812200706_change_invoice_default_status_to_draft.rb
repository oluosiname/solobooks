class ChangeInvoiceDefaultStatusToDraft < ActiveRecord::Migration[7.1]
  def change
    change_column_default :invoices, :status, 'draft'
  end
end
