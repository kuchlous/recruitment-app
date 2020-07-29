ThinkingSphinx::Index.define :resume, :with => :active_record do
    indexes :name 
    indexes :email
    indexes :phone
    indexes :qualification
    indexes :location
    indexes :summary
    indexes :search_data
    indexes :overall_status
    indexes :related_requirements
    has     :ctc
    has     :expected_ctc
    has     :exp_in_months
end


