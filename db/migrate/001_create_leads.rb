class CreateLeads < ActiveRecord::Migration
  def self.up
    create_table :leads, :force => true do |t|
      t.boolean :opt_in_brochure
      t.boolean :opt_in_newsletter, :null => false

      # Provided via hidden fields
      t.integer :lead_type_id, :null => false
      t.string  :listing_id
      t.string  :session_id, :null => false
      t.string :endeca_id
      t.string :entity_id, :null => false   
      t.string :entity_type_id, :null => false
      
      # Provided by the leads server
      t.string :website, :null => false

      # User input 
      # NOTE: (in case you are wondering, yes, these are NOT required according to Blane Davis.)
      t.string :address
      t.string :city
      t.string :phone
      t.string :email
      t.string :first_name
      t.string :last_name
      t.date   :move_date
      t.string :state
      t.string :status
      t.string :zip
      t.text   :message
      t.string :market_code
      t.string :datasource
   
      t.timestamps
    end
  end

  def self.down
    drop_table :leads
  end
end
