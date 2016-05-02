# This migration comes from compass_ae_business_suite (originally 20120911130151)
class AddSurveyModels < ActiveRecord::Migration
  def up
    unless table_exists?(:surveys)
      create_table :surveys do |t|
        t.string  :description
        t.string  :internal_identifier
        t.string  :comments
        t.decimal :score, :precision  => 10, :scale => 2
        t.boolean :is_template, :default => false
        t.references :party
        t.boolean :synced

        t.timestamps
      end


      add_index :surveys, :is_template
      add_index :surveys, :party_id
    end

    unless table_exists?(:questions)
      create_table :questions do |t|
        t.string :description
        t.string :internal_identifier
        t.string :img_src
        t.text :details

        t.timestamps
      end
    end

    unless table_exists?(:questions_surveys)
      create_table :questions_surveys, :id => false do |t|
        t.references :question
        t.references :survey
      end

      add_index :questions_surveys, :question_id
      add_index :questions_surveys, :survey_id
    end

    unless table_exists?(:answers)
      create_table :answers do |t|
        t.string :value
        t.string :description
        t.string :internal_identifier
        t.boolean :selected

        t.timestamps
      end

      add_index :answers, :selected
    end

    unless table_exists?(:answers_questions)
      create_table :answers_questions, :id => false do |t|
        t.references :answer
        t.references :question
      end

      add_index :answers_questions, :answer_id
      add_index :answers_questions, :question_id
    end

  end

  def down
    [:surveys, :questions, :questions_surveys, :answers, :answers_questions].each do |t|
      drop_table t
    end
  end
end
