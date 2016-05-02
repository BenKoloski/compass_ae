# This migration comes from compass_ae_business_suite (originally 20141111112257)
class CreateSurveyQuestionAnswerTypes < ActiveRecord::Migration
  def up
    unless table_exists?(:survey_types)
      create_table :survey_types do |t|
        t.string :description
        t.string :internal_identifier
        
        t.timestamps
      end
      add_index :survey_types, :internal_identifier

      add_column :surveys, :survey_type_id, :integer
      add_index :surveys, :survey_type_id

    end

    unless table_exists?(:question_types)
      create_table :question_types do |t|
        t.string :description
        t.string :internal_identifier
        
        t.timestamps
      end
      add_index :question_types, :internal_identifier

      add_column :questions, :question_type_id, :integer
      add_index :questions, :question_type_id
    end

    unless table_exists?(:answer_types)
      create_table :answer_types do |t|
        t.string :description
        t.string :internal_identifier
        
        t.timestamps
      end
      add_index :answer_types, :internal_identifier

      add_column :answers, :answer_type_id, :integer
      add_index :answers, :answer_type_id
    end

  end

  def down
    [:survey_types, :question_types, :answer_types].each do |tbl|
      drop_table tbl if table_exists?(tbl)
    end
  end
end
