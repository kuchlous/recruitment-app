class AddFeedbackSkillKeywordsToRequirements < ActiveRecord::Migration[8.0]
  def change
    add_column :requirements, :feedback_skill_keywords, :text
  end
end
