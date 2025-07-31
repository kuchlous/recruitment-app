# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2025_05_15_053717) do

  create_table "agencies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "comment"
    t.integer "resume_id", null: false
    t.integer "employee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ctype"
  end

  create_table "designations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employees", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.integer "eid"
    t.string "login"
    t.string "email"
    t.integer "manager_id"
    t.string "employee_type"
    t.string "employee_status", default: "ACTIVE"
    t.integer "account_id"
    t.boolean "is_admin", default: false
    t.date "joining_date"
    t.date "leaving_date"
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "n_interviews_per_week", default: 0
    t.text "preferred_day_and_time"
  end

  create_table "employees_interview_skills", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "interview_skill_id"
    t.index ["employee_id"], name: "index_employees_interview_skills_on_employee_id"
    t.index ["interview_skill_id"], name: "index_employees_interview_skills_on_interview_skill_id"
  end

  create_table "feedbacks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "resume_id", null: false
    t.integer "employee_id", null: false
    t.string "rating", limit: 20, null: false
    t.text "feedback"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "forwards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "forwarded_to", null: false
    t.integer "resume_id", null: false
    t.string "status", limit: 15, default: "NEW"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "forwarded_by"
  end

  create_table "groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.integer "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "interview_skills", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "interviews", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "employee_id", null: false
    t.date "interview_date"
    t.time "interview_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "req_match_id", null: false
    t.string "stage"
    t.string "itype"
    t.text "focus"
    t.integer "interview_level"
  end

  create_table "messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "message"
    t.integer "resume_id"
    t.integer "sent_to", null: false
    t.integer "sent_by", null: false
    t.integer "reply_to"
    t.boolean "is_deleted"
    t.boolean "is_read"
    t.boolean "is_replied"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "portals", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "req_matches", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "forwarded_to", null: false
    t.integer "resume_id", null: false
    t.integer "requirement_id", null: false
    t.string "status", limit: 15, default: "NEW"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "interview_status", default: ""
  end

  create_table "requirements", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.integer "posting_emp_id"
    t.integer "employee_id"
    t.integer "uniqid_id"
    t.text "skill"
    t.text "description"
    t.string "exp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "OPEN"
    t.integer "group_id"
    t.date "sdate"
    t.date "edate"
    t.integer "nop", default: 1
    t.string "req_type", default: "ORDINARY"
    t.integer "source_owner"
    t.integer "schedule_owner"
    t.text "mgt_comment"
    t.integer "designation_id"
    t.integer "scheduling_employee_id"
    t.integer "ta_lead_id"
    t.integer "eng_lead_id"
    t.date "last_forward_recieved"
  end

  create_table "resumes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "file_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "employee_id", null: false
    t.text "summary", null: false
    t.text "resume_text_content"
    t.integer "uniqid_id"
    t.string "referral_type", limit: 15, null: false
    t.integer "referral_id", null: false
    t.string "email"
    t.string "phone"
    t.date "joining_date"
    t.string "experience"
    t.text "qualification"
    t.float "ctc"
    t.float "expected_ctc"
    t.integer "notice"
    t.string "status", limit: 10, default: ""
    t.string "current_company"
    t.string "location"
    t.integer "nreq_matches", default: 0
    t.integer "nforwards", default: 0
    t.string "manual_status"
    t.integer "exp_in_months"
    t.string "overall_status"
    t.string "related_requirements"
    t.string "likely_to_join", limit: 1, default: "R"
    t.string "skype_id"
    t.string "practice_head_rating"
    t.integer "ta_owner_id"
    t.string "preferred_location"
    t.string "git_id"
    t.string "linkedin_id"
    t.text "skills"
    t.index ["email"], name: "index_resumes_on_email"
    t.index ["overall_status"], name: "index_resumes_on_overall_status"
    t.index ["phone"], name: "index_resumes_on_phone"
    t.index ["referral_id"], name: "index_resumes_on_referral_id"
    t.index ["referral_type"], name: "index_resumes_on_referral_type"
    t.index ["status"], name: "index_resumes_on_status"
  end

  create_table "uniqids", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
