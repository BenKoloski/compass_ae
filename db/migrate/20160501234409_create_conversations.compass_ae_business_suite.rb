# This migration comes from compass_ae_business_suite (originally 20150929224719)
class CreateConversations < ActiveRecord::Migration
  def up

    unless table_exists? :conversations
      create_table :conversations do |t|
        t.string :chat_id
        t.boolean :active

        t.timestamps
      end
    end

    unless table_exists? :conversations_parties
      create_table :conversations_parties do |t|
        t.references :party
        t.references :conversation

        t.timestamps
      end

      add_index :conversations_parties, :party_id
      add_index :conversations_parties, :conversation_id
    end

  end

  def down
    [:conversations, :conversations_parties].each do |table|
      if table_exists? table
        drop_table table
      end
    end

  end

end
