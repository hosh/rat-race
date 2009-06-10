class AddDefaultValueToOptInNewsletterColumn < ActiveRecord::Migration
  def self.up
    change_column :leads, :opt_in_newsletter, :boolean, :null => false, :default => 0 
  end

  def self.down
    change_column :leads, :opt_in_newsletter, :boolean, :null => false
  end
end