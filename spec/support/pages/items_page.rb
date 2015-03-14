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
