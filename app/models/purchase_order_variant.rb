class PurchaseOrderVariant < ActiveRecord::Base
  belongs_to :purchase_order
  belongs_to :variant

  validates :cost,      :presence => true
  validates :quantity,      :presence => true
  #validates :variant_id,      :presence => true
  #validates :purchase_order_id,      :presence => true


  ## This method will need a rescue method i assume.
  def receive!
    PurchaseOrderVariant.transaction do
      ###  Add to variant stock level
      self.variant.inventory.count_on_hand = self.variant.inventory.count_on_hand + quantity
      if self.variant.inventory.save!
        ### change is_received to true
        self.is_received = true
        self.save!
      end
      if 0 == PurchaseOrderVariant.where({ :purchase_order_variants =>
                                                { :purchase_order_id => purchase_order_id,
                                                  :is_received       => false
                                                } }).count
        self.purchase_order.mark_as_complete
      end
    end
  end

  # in the admin form this is the method called when the form is submitted,
  #   The method receives the PO and handles the inventory
  #
  # @param [String] value for set_keywords in a products form
  # @return [none]
  def receive_po=(answer)
    if (answer == 'true' || answer == '1') && !is_received?
      receive!
    end
  end

  # method used by forms to set if the PO is received or not
  #
  # @param [none]
  # @return [Boolean]
  def receive_po
    is_received?
  end
end
