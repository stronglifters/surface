require_relative "../page_model.rb"

class ItemsPage < PageModel
  def initialize
    super dashboard_path
  end

  def add_item(item_name)
    within "#new_item" do
      fill_in I18n.translate("items.index.item_name"), with: item_name
      click_button I18n.translate("items.index.new_item_button")
    end
  end
end

class NewItemPage < PageModel
  def initialize
    super new_item_path
  end

  def create_item(name:, 
                  description: '',
                  serial_number: '',
                  purchase_price: '',
                  purchased_at: ''
                 )
    within "#new_item" do
      fill_in I18n.translate("items.form.name"), with: name
      fill_in I18n.translate("items.form.description"), with: description
      fill_in I18n.translate("items.form.serial_number"), with: serial_number
      fill_in I18n.translate("items.form.purchase_price"), with: purchase_price
      fill_in I18n.translate("items.form.purchased_at"), with: purchased_at
      click_button I18n.translate("items.form.create_button")
    end
  end
end
