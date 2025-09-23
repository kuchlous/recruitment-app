class Requirement < ActiveRecord::Base
  searchkick word_start: [:name, :description, :skills, :location],
            suggest: [:name, :description, :skills, :location],
            filterable: [:id, :status, :experience, :notice_period, :employee_id, :designation_id, :group_id],
            searchable: [:name, :description, :skills, :location, :experience, :notice_period],
            knn: {embedding: {dimensions: 1536, distance_type: "cosine"}},
            mappings: {
              properties: {
                id: { type: 'integer' },
                experience: { type: 'integer' },
                notice_period: { type: 'integer' },
                created_at: { type: 'date' },
                updated_at: { type: 'date' },
                embedding: { type: 'dense_vector', dims: 1536 } # OpenAI text-embedding-3-small embedding dimensions
              }
            },
            merge_mappings: true

  belongs_to              :employee
  belongs_to              :designation
  has_many                :interviews
  has_many                :req_matches
  has_and_belongs_to_many :forwards
  has_and_belongs_to_many :eng_leads, class_name: "Employee", join_table: "employees_requirements"
  has_and_belongs_to_many :ta_leads, class_name: "Employee", join_table: "requirements_ta_leads"
  belongs_to              :group,
                          :class_name  => "Group",
                          :foreign_key => "group_id"
  belongs_to              :posted_by,
                          :class_name  => "Employee",
                          :foreign_key => "posting_emp_id"

  belongs_to              :scheduling_emp,
                          :optional => true,
                          :class_name => "Employee",
                          :foreign_key => "scheduling_employee_id"


  # Presence stuff
  validates_presence_of :name
  validates_presence_of :employee_id
  validates_presence_of :designation_id
  validates_presence_of :group_id

  # Uniqueness stuff
  validates_uniqueness_of :name, :case_sensitive => false

  def Requirement.get_experience_array
    exp_array = []
    for i in 1..20
      exp_array << i
    end

    exp_array
  end

  def Requirement.get_requirement_array_for_select
    req_array = []
    all_ordered_requirements = Requirement.all.order(:name)
    all_open_requirements = all_ordered_requirements.find_all {
      |req| req.status == "OPEN"
    }
    all_open_requirements.each do |req|
      req_array.push([req.name, req.id])
    end
    req_array
  end

  def Requirement.get_all_requirement_array_for_select
    req_array = []
    req_array.push(["Select Req", 0])
    all_ordered_requirements = Requirement.all.order(:name)
    all_ordered_requirements.each do |req|
      req_array.push([req.name, req.id])
    end
    req_array
  end

  def Requirement.get_employee_requirement_array(employee)
    emp_req_array = []
    employee.requirements.each do |req|
      emp_req_array.push([req.name, req.id])
    end
    emp_req_array
  end

  def open_forwards
    self.forwards.where(status: "FORWARDED")
  end

  def shortlists
    self.req_matches.where(status: "SHORTLISTED")
  end

  def scheduled
    self.req_matches.joins(:resume).where(status: "SCHEDULED").where.not(resumes: {overall_status: "FUTURE"})
  end

  def scheduled_l1
    # Get req_matches with L1 interviews that don't have feedback and don't have L2 interviews
    l1_req_match_ids = self.req_matches.joins(:resume, :interviews)
                                    .where(status: "SCHEDULED")
                                    .where(interviews: {interview_level: 1})
                                    .left_joins(interviews: :feedbacks)
                                    .where(feedbacks: {id: nil})
                                    .pluck(:id)
    
    l2_req_match_ids = self.req_matches.joins(:interviews)
                                    .where(interviews: {interview_level: 2})
                                    .pluck(:id)
    
    # Return L1 req_matches that don't have L2 interviews
    self.req_matches.where(id: l1_req_match_ids - l2_req_match_ids)
  end

  def scheduled_l2
    l2_req_match_ids = self.req_matches.joins(:resume, :interviews)
                                    .where(status: "SCHEDULED")
                                    .where(interviews: {interview_level: 2})
                                    .left_joins(interviews: :feedbacks)
                                    .where(feedbacks: {id: nil})
                                    .pluck(:id)
    
    self.req_matches.where(id: l2_req_match_ids)
  end

  def completed_l1
    # Get req_matches with L1 interviews that have feedback and don't have L2 interviews
    l1_req_match_ids = self.req_matches.joins(:resume, :interviews)
                                    .where(status: "SCHEDULED")
                                    .where(interviews: {interview_level: 1})
                                    .joins(interviews: :feedbacks)
                                    .pluck(:id)
    
    l2_req_match_ids = self.req_matches.joins(:interviews)
                                    .where(interviews: {interview_level: 2})
                                    .pluck(:id)
    
    # Return L1 req_matches that don't have L2 interviews
    self.req_matches.where(id: l1_req_match_ids - l2_req_match_ids)
  end

  def completed_l2
    l2_req_match_ids = self.req_matches.joins(:resume, :interviews)
                                    .where(status: "SCHEDULED")
                                    .where(interviews: {interview_level: 2})
                                    .joins(interviews: :feedbacks)
                                    .pluck(:id)
    
    self.req_matches.where(id: l2_req_match_ids)
  end

  def rejected
    self.req_matches.where(status: "REJECTED")
  end

  def yto
    self.req_matches.where(status: "YTO")
  end

  def hold
    self.req_matches.where(status: "HOLD")
  end

  def offered
    self.req_matches.where(status: "OFFERED")
  end

  def hac
    self.req_matches.where(status: "HAC")
  end

  def joining
    self.req_matches.joins(:resume).where(status: "JOINING").where(resumes: {overall_status: "JOINING"})
  end

  def not_joined
    self.req_matches.joins(:resume).where(status: "NOT JOINED").where(resumes: {overall_status: "NOT JOINED"})
  end

  def not_accepted
    self.req_matches.joins(:resume).where(status: "N_ACCEPTED").where(resumes: {overall_status: "N_ACCEPTED"})
  end

  def Requirement.open_requirements
    Requirement.all.where(status: "OPEN")
  end

  def isOPEN?
    self.status == "OPEN"
  end

  def name_for_js
    if name
      return name.gsub(/'|"/, '')
    else
      return name
    end
  end

  # Class methods for getting status and type options
  def self.status_options_for_select
    [
      ["Open", "OPEN"],
      ["Hold", "HOLD"],
      ["Closed - Lost", "CLOSED LOST"],
      ["Closed - Won", "CLOSED WON"],
      ["Closed - Cancelled", "CLOSED CANCELLED"],
      ["Closed - Expired", "CLOSED EXPIRED"],
      ["Closed - Offered", "CLOSED OFFERED"],
      ["Closed - Joining", "CLOSED JOINING"],
      ["Closed - Delete", "CLOSED DELETE"]
    ]
  end

  def self.req_type_options_for_select
    [
      ["Ordinary", "ORDINARY"],
      ["Hot", "HOT"]
    ]
  end

  # Prepare text for embedding generation
  def prepare_text_for_embedding
    text_parts = []
    
    text_parts << "Requirement Name: #{name}" if name.present?
    text_parts << "Requirement Description: #{description}" if description.present?
    text_parts << "Requirement Skills: #{skill}" if skill.present?
    text_parts << "Requirement Experience: #{exp.split('-').first} years to #{exp.split('-').last} years" if exp.present?
    
    text_parts.compact.join(" ").strip
  end

  # Generate and save embedding for this requirement
  def generate_and_save_embedding(force:false)
    return false if embedding and not force
    text_to_embed = prepare_text_for_embedding
    return false if text_to_embed.blank?
    
    begin
      embedding = OpenaiUtils.generate_embedding(text_to_embed)
      return false if embedding.nil?
      
      # Save to database
      self.update(embedding: embedding.to_json)
      
      # Reindex in Elasticsearch to include the new embedding
      reindex
      
      true
    rescue => e
      Rails.logger.error "Error generating embedding for requirement #{id}: #{e.message}"
      false
    end
  end

  # Retrieve embedding from database
  def get_embedding
    return nil if embedding.blank?
    
    begin
      JSON.parse(embedding)
    rescue JSON::ParserError
      Rails.logger.error "Error parsing embedding for requirement #{id}"
      nil
    end
  end

  # Searchkick methods
  def search_data
    {
      id: id,
      name: name,
      description: description,
      skill: skill,
      exp: exp,
      status: status,
      req_type: req_type,
      employee_id: employee_id,
      designation_id: designation_id,
      group_id: group_id,
      created_at: created_at,
      updated_at: updated_at,
      embedding: get_embedding
    }
  end

  def should_index?
    # Only index requirements that are not deleted
    !destroyed?
  end

  # Class method for KNN similarity search
  def self.similar_requirements(embedding_vector, limit: 20, distance: "cosine")
    search(
      knn: {
        field: :embedding,
        vector: embedding_vector,
        distance: distance
      },
      limit: limit
    )
  end

end
