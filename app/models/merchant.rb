class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices
  has_many :invoice_items, through: :invoices

  def self.top_merchants_by_revenue(limit)
    joins(invoices: [:transactions, :invoice_items])
    .where(invoices: {status: 'shipped'}, transactions: {result: 'success'})
    .group(:id)
    .select("SUM(invoice_items.unit_price * invoice_items.quantity) as total_revenue, merchants.*")
    .order("total_revenue DESC")
    .limit(limit)
  end

  def self.most_items(quantity)
    joins(invoices: [:transactions, :invoice_items])
    .where(invoices: {status: 'shipped'}, transactions: {result: 'success'})
    .group(:id)
    .select("COUNT(invoice_items.quantity) as count, merchants.*")
    .order("count DESC")
    .limit(quantity)
  end
end