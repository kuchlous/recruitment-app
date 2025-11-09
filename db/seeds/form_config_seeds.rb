data = {
  "title" => "Design Verification Feedback Form",
  "config" => {
    "fields" => [
      {
        "name" => "candidate_bucket",
        "type" => "select",
        "label" => "Which bucket does this candidate fall into? (pick multiple if needed)",
        "options" => [
          {
            "label" => "IP",
            "value" => "ip"
          },
          {
            "label" => "SoC",
            "value" => "soc"
          },
          {
            "label" => "AMS",
            "value" => "ams"
          },
          {
            "label" => "Formal",
            "value" => "formal"
          },
          {
            "label" => "GLS",
            "value" => "gls"
          },
          {
            "label" => "Processor",
            "value" => "processor"
          },
          {
            "label" => "Others",
            "value" => "others"
          }
        ],
        "multiple" => true,
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Please select at least one bucket"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "attitude_sharpness_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Attitude and Sharpness",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "attitude_sharpness_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about attitude and sharpness..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "communication_skills_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Communication Skills",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "communication_skills_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about communication skills..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "expertise_1_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Area of expertise - 1",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "expertise_1_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => true,
        "placeholder" => "Enter comments about area of expertise 1...",
        "validations" => [
          {
            "type" => "required",
            "message" => "Comments are required"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "expertise_2_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Area of expertise - 2",
        "required" => false,
        "validations" => [
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "expertise_2_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about area of expertise 2..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "expertise_n_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Area of expertise - n",
        "required" => false,
        "validations" => [
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "expertise_n_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about area of expertise n..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "project_knowledge_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Past/Current project knowledge",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "project_knowledge_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => true,
        "placeholder" => "Enter comments about project knowledge...",
        "validations" => [
          {
            "type" => "required",
            "message" => "Comments are required"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "project_complexity_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Past/Current project complexity",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "project_complexity_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => true,
        "placeholder" => "Enter comments about project complexity...",
        "validations" => [
          {
            "type" => "required",
            "message" => "Comments are required"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "verilog_rtl_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Verilog / RTL",
        "required" => false,
        "validations" => [
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "verilog_rtl_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about Verilog/RTL skills..."
      },
      {
        "max": 10,
        "min": 0,
        "name": "protocols_checked_rating",
        "step": 1,
        "type": "number",
        "label": "Protocols Checked (Rating)",
        "required": true,
        "validations": [
          {
            "type": "min",
            "value": 0,
            "message": "Rating must be at least 0"
          },
          {
            "type": "max",
            "value": 10,
            "message": "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name": "protocols_checked_comments",
        "type": "textarea",
        "label": "Protocol Names/Details",
        "required": true,
        "placeholder": "Enter names of protocols checked and specific details..."
      },
      {
        "max": 10,
        "min": 0,
        "name": "sv_advanced_rating",
        "step": 1,
        "type": "number",
        "label": "SV (Advanced)",
        "required": true,
        "validations": [
          {
            "type": "min",
            "value": 0,
            "message": "Rating must be at least 0"
          },
          {
            "type": "max",
            "value": 10,
            "message": "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name": "sv_advanced_comments",
        "type": "textarea",
        "label": "Comments",
        "required": false,
        "placeholder": "Enter comments about SV (Advanced) skills..."
      },
      {
        "max": 10,
        "min": 0,
        "name": "uvm_rating",
        "step": 1,
        "type": "number",
        "label": "UVM",
        "required": false,
        "validations": [
          {
            "type": "min",
            "value": 0,
            "message": "Rating must be at least 0"
          },
          {
            "type": "max",
            "value": 10,
            "message": "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name": "uvm_comments",
        "type": "textarea",
        "label": "Comments",
        "required": false,
        "placeholder": "Enter comments about UVM skills (Mandatory if candidate claims knowledge)..."
      },
      {
        "max": 10,
        "min": 0,
        "name": "tb_coding_rating",
        "step": 1,
        "type": "number",
        "label": "TB Coding",
        "required": true,
        "validations": [
          {
            "type": "min",
            "value": 0,
            "message": "Rating must be at least 0"
          },
          {
            "type": "max",
            "value": 10,
            "message": "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name": "tb_coding_comments",
        "type": "textarea",
        "label": "Comments",
        "required": false,
        "placeholder": "Enter comments about TB Coding skills..."
      },
      {
        "max": 10,
        "min": 0,
        "name": "c_programming_rating",
        "step": 1,
        "type": "number",
        "label": "C-programming",
        "required": false,
        "validations": [
          {
            "type": "min",
            "value": 0,
            "message": "Rating must be at least 0"
          },
          {
            "type": "max",
            "value": 10,
            "message": "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name": "c_programming_comments",
        "type": "textarea",
        "label": "Comments",
        "required": false,
        "placeholder": "Enter comments about C-programming skills (if applicable)..."
      },
      {
        "max": 10,
        "min": 0,
        "name": "gls_knowledge_rating",
        "step": 1,
        "type": "number",
        "label": "GLS knowledge",
        "required": false,
        "validations": [
          {
            "type": "min",
            "value": 0,
            "message": "Rating must be at least 0"
          },
          {
            "type": "max",
            "value": 10,
            "message": "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name": "gls_knowledge_comments",
        "type": "textarea",
        "label": "Comments",
        "required": false,
        "placeholder": "Enter comments about GLS knowledge (if applicable)..."
      },
      {
        "max": 10,
        "min": 0,
        "name": "power_aware_low_power_rating",
        "step": 1,
        "type": "number",
        "label": "Power Aware/Low-Power",
        "required": false,
        "validations": [
          {
            "type": "min",
            "value": 0,
            "message": "Rating must be at least 0"
          },
          {
            "type": "max",
            "value": 10,
            "message": "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name": "power_aware_low_power_comments",
        "type": "textarea",
        "label": "Comments",
        "required": false,
        "placeholder": "Enter comments about Power Aware/Low-Power skills (if applicable)..."
      },
      {
        "max": 10,
        "min": 0,
        "name": "verification_concepts_rating",
        "step": 1,
        "type": "number",
        "label": "Verification Concepts",
        "required": true,
        "validations": [
          {
            "type": "min",
            "value": 0,
            "message": "Rating must be at least 0"
          },
          {
            "type": "max",
            "value": 10,
            "message": "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name": "verification_concepts_comments",
        "type": "textarea",
        "label": "Comments",
        "required": false,
        "placeholder": "Enter comments about Verification Concepts skills..."
      },
      {
        "max": 10,
        "min": 0,
        "name": "digital_logic_rating",
        "step": 1,
        "type": "number",
        "label": "Digital Logic",
        "required": true,
        "validations": [
          {
            "type": "min",
            "value": 0,
            "message": "Rating must be at least 0"
          },
          {
            "type": "max",
            "value": 10,
            "message": "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name": "digital_logic_comments",
        "type": "textarea",
        "label": "Comments",
        "required": false,
        "placeholder": "Enter comments about Digital Logic skills..."
      },
      {
        "name" => "observations",
        "type" => "textarea",
        "label" => "Observations (Mandatory to be filled)",
        "required" => true,
        "placeholder" => "Enter your observations...",
        "validations" => [
          {
            "type" => "required",
            "message" => "Observations are required"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "overall_rating",
        "type" => "number",
        "label" => "Overall Rating (Mandatory to be filled)",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "decision",
        "type" => "select",
        "label" => "Decision (Mandatory to be filled)",
        "options" => [
          {
            "label" => "Hire",
            "value" => "hire"
          },
          {
            "label" => "No-Hire",
            "value" => "no-hire"
          }
        ],
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Decision is required"
          }
        ]
      }
    ],
    "form_name" => "feedback_form",
    "form_title" => "Design Verification Feedback Form",
    "submit_text" => "Submit Feedback"
  }
}
FormConfig.find_or_initialize_by(title: data['title']).update!(config: data['config'])

data = {
  "title" => "FPGA Interview Feedback Form",
  "config" => {
    "fields" => [
      {
        "name" => "candidate_bucket",
        "type" => "select",
        "label" => "Which bucket does this candidate fall into? (pick multiple if needed)",
        "options" => [
          {
            "label" => "ASIC RTL",
            "value" => "asic_rtl"
          },
          {
            "label" => "CDC",
            "value" => "cdc"
          },
          {
            "label" => "LINT",
            "value" => "lint"
          },
          {
            "label" => "LEC",
            "value" => "lec"
          },
          {
            "label" => "FPGA Design",
            "value" => "fpga_design"
          },
          {
            "label" => "Embedded",
            "value" => "embedded"
          },
          {
            "label" => "Validation",
            "value" => "validation"
          },
          {
            "label" => "Emulation",
            "value" => "emulation"
          },
          {
            "label" => "Prototyping",
            "value" => "prototyping"
          }
        ],
        "multiple" => true,
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Please select at least one bucket"
          }
        ]
      },
      {
        "name" => "candidate_bucket_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false
      },
      {
        "name" => "candidate_domain",
        "type" => "select",
        "label" => "Which domain does the candidate belong to ? (pick multiple if needed)",
        "options" => [
          {
            "label" => "Wireless",
            "value" => "wireless"
          },
          {
            "label" => "Wired",
            "value" => "wired"
          },
          {
            "label" => "Network",
            "value" => "network"
          },
          {
            "label" => "5G",
            "value" => "5g"
          },
          {
            "label" => "LTE",
            "value" => "lte"
          },
          {
            "label" => "Averionics",
            "value" => "averionics"
          },
          {
            "label" => "Defence",
            "value" => "defence"
          },
          {
            "label" => "Processor",
            "value" => "processor"
          },
          {
            "label" => "Multimedia",
            "value" => "multimedia"
          }
        ],
        "multiple" => true,
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Please select at least one domain"
          }
        ]
      },
      {
        "name" => "candidate_domain_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "attitude_sharpness_rating",
        "type" => "number",
        "label" => "Attitude and Sharpness",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "attitude_sharpness_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "communication_skills_rating",
        "type" => "number",
        "label" => "Communication Skills",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "communication_skills_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "digital_logic_rating",
        "type" => "number",
        "label" => "Digital Logic (Basics)",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "digital_logic_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "project_knowledge_rating",
        "type" => "number",
        "label" => "Past/Current project knowledge",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "project_knowledge_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "project_complexity_rating",
        "type" => "number",
        "label" => "Past/Current project complexity",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "project_complexity_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "protocols_checked_rating",
        "type" => "number",
        "label" => "Protocols Checked - Protocol & Explanation (Name of protocol(s) and Rating(s))",
        "required" => false,
        "validations" => [
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "protocols_checked_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "verilog_rtl_rating",
        "type" => "number",
        "label" => "Verilog / RTL",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "verilog_rtl_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "fpga_design_knowledge_rating",
        "type" => "number",
        "label" => "Knowledge FPGA Design (if yes) and Design Concept",
        "required" => false,
        "validations" => [
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "fpga_design_knowledge_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "fpga_validation_prototyping_emulation_rating",
        "type" => "number",
        "label" => "Knowledge FPGA Validation/Prototyping/Emulation (if yes)",
        "required" => false,
        "validations" => [
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "fpga_validation_prototyping_emulation_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "fpga_design_flow_architecture_rating",
        "type" => "number",
        "label" => "FPGA Design Flow and FPGA Architecture",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "fpga_design_flow_architecture_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "basic_verification_concepts_rating",
        "type" => "number",
        "label" => "Basic Verification Concepts (if Applicable)",
        "required" => false,
        "validations" => [
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "basic_verification_concepts_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "sta_timing_annotations_rating",
        "type" => "number",
        "label" => "STA knowledge, Timing Annotations",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "sta_timing_annotations_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "cdc_fifo_concepts_rating",
        "type" => "number",
        "label" => "CDC and FIFO concepts",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "cdc_fifo_concepts_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "asic_rtl_concepts_rating",
        "type" => "number",
        "label" => "ASIC RTL -- > CDC concepts Lint concepts, LEC, Power",
        "required" => false,
        "validations" => [
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "asic_rtl_concepts_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "memory_interface_rating",
        "type" => "number",
        "label" => "Memory Interface",
        "required" => false,
        "validations" => [
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "memory_interface_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false
      },
      {
        "name" => "overall_observations",
        "type" => "textarea",
        "label" => "Overall Observations (Mandatory to be filled)",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall observations are required"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "overall_rating",
        "type" => "number",
        "label" => "Overall Rating (Mandatory to be filled)",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "decision",
        "type" => "select",
        "label" => "Decision (Mandatory to be filled)",
        "options" => [
          {
            "label" => "Hire",
            "value" => "hire"
          },
          {
            "label" => "No-Hire",
            "value" => "no-hire"
          }
        ],
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Decision is required"
          }
        ]
      }
    ],
    "form_name" => "fpga_interview_feedback",
    "form_title" => "FPGA Interview Feedback Form",
    "submit_text" => "Submit Feedback"
  }
}
FormConfig.find_or_initialize_by(title: data['title']).update!(config: data['config'])

data = {
  "title" => "Backend Feedback Form",
  "config" => {
    "fields" => [
      {
        "name" => "description",
        "type" => "label",
        "label" => "Description: In the interview process, you need to evaluate candidates on the following factors.",
        "required" => false
      },
      {
        "name" => "prior_work_experience",
        "type" => "textarea",
        "label" => "Prior Work Experience: Has the candidate been able to explain prior work and worked on reasonably complex projects as per his/her experience?",
        "required" => false
      },
      {
        "name" => "prior_work_experience_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false
      },
      {
        "name" => "technical_qualifications_description",
        "type" => "label",
        "label" => "Technical Qualifications/Experience: Evaluate relevant domains like given below",
        "required" => false
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "sta_rating",
        "type" => "number",
        "label" => "STA",
        "required" => false,
        "validations" => [
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "sta_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "synthesis_rating",
        "type" => "number",
        "label" => "Synthesis",
        "required" => false,
        "validations" => [
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "synthesis_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "top_level_soc_rating",
        "type" => "number",
        "label" => "Top-level SOC",
        "required" => false,
        "validations" => [
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "top_level_soc_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "physical_design_rating",
        "type" => "number",
        "label" => "Physical Design- ICC/Innovus",
        "required" => false,
        "validations" => [
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "physical_design_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "ir_drop_rating",
        "type" => "number",
        "label" => "IR Drop",
        "required" => false,
        "validations" => [
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "ir_drop_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "physical_verification_rating",
        "type" => "number",
        "label" => "Physical Verification",
        "required" => false,
        "validations" => [
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "physical_verification_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "lec_clp_rating",
        "type" => "number",
        "label" => "LEC/CLP",
        "required" => false,
        "validations" => [
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "lec_clp_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "pdcad_rating",
        "type" => "number",
        "label" => "PDCAD",
        "required" => false,
        "validations" => [
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "pdcad_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "any_other_skill_rating",
        "type" => "number",
        "label" => "Any Other skill",
        "required" => false,
        "validations" => [
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "any_other_skill_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false
      },
      {
        "name" => "verbal_communication",
        "type" => "textarea",
        "label" => "Verbal Communication: Did the candidate demonstrate effective communication skills during the interview?",
        "required" => false
      },
      {
        "name" => "verbal_communication_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "attitude_rating",
        "type" => "number",
        "label" => "Attitude: Evaluate the candidate on Enthusiasm / Teamwork/Time management / Proactiveness to learn, Initiative etc.",
        "required" => false,
        "validations" => [
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "overall_rating",
        "type" => "number",
        "label" => "Overall rating",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "overall_impression",
        "type" => "textarea",
        "label" => "Overall Impression and Recommendation: Final comments and recommendations for proceeding with the candidate.",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall impression is required"
          }
        ]
      },
      {
        "name" => "decision",
        "type" => "select",
        "label" => "Decision (Mandatory to be filled)",
        "options" => [
          {
            "label" => "Hire",
            "value" => "hire"
          },
          {
            "label" => "No-Hire",
            "value" => "no-hire"
          }
        ],
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Decision is required"
          }
        ]
      }
    ],
    "form_name" => "backend_feedback",
    "form_title" => "Backend Feedback Form",
    "submit_text" => "Submit Feedback"
  }
}
FormConfig.find_or_initialize_by(title: data['title']).update!(config: data['config'])

data = {
  "title" => "DFT Feedback Form",
  "config" => {
    "fields" => [
      {
        "name" => "prior_work_experience_label",
        "type" => "label",
        "label" => "Prior Work Experience: Has the candidate been able to explain prior work and worked on reasonably complex projects as per his/her experience?",
        "required" => false
      },
      {
        "name" => "prior_work_experience_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about prior work experience..."
      },
      {
        "name" => "technical_qualifications_label",
        "type" => "label",
        "label" => "Technical Qualifications/Experience: Evaluate relevant domains like given below",
        "required" => false
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "scan_insertion_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Scan insertion",
        "required" => false,
        "validations" => [
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "scan_insertion_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about scan insertion..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "mbist_insertion_rating",
        "step" => 1,
        "type" => "number",
        "label" => "MBIST insertion",
        "required" => false,
        "validations" => [
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "mbist_insertion_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about MBIST insertion..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "atpg_rating",
        "step" => 1,
        "type" => "number",
        "label" => "ATPG",
        "required" => false,
        "validations" => [
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "atpg_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about ATPG..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "simulations_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Simulations",
        "required" => false,
        "validations" => [
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "simulations_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about simulations..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "mbist_simulations_rating",
        "step" => 1,
        "type" => "number",
        "label" => "MBIST Simulations",
        "required" => false,
        "validations" => [
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "mbist_simulations_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about MBIST simulations..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "postsi_debug_rating",
        "step" => 1,
        "type" => "number",
        "label" => "postSi Debug",
        "required" => false,
        "validations" => [
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "postsi_debug_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about postSi debug..."
      },
      {
        "name" => "verbal_communication",
        "type" => "textarea",
        "label" => "Verbal Communication: Did the candidate demonstrate effective communication skills during the interview?",
        "required" => false,
        "placeholder" => "Evaluate verbal communication skills..."
      },
      {
        "name" => "verbal_communication_comments",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about verbal communication..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "attitude_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Attitude: Evaluate the candidate on Enthusiasm / Teamwork/Time management / Proactiveness to learn, Initiative etc.",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "overall_impression",
        "type" => "textarea",
        "label" => "Overall Impression and Recommendation: Final comments and recommendations for proceeding with the candidate.",
        "required" => true,
        "placeholder" => "Enter your overall impression and recommendation...",
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall impression is required"
          }
        ]
      },
      {
        "name" => "proceed_recommendation",
        "type" => "select",
        "label" => "Recommendation",
        "options" => [
          {
            "label" => "Yes",
            "value" => "yes"
          },
          {
            "label" => "No",
            "value" => "no"
          }
        ],
        "multiple" => false,
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Recommendation is required"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "overall_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Overall Rating",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "decision",
        "type" => "select",
        "label" => "Decision (Mandatory to be filled)",
        "options" => [
          {
            "label" => "Hire",
            "value" => "hire"
          },
          {
            "label" => "No-Hire",
            "value" => "no-hire"
          }
        ],
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Decision is required"
          }
        ]
      }
    ],
    "form_name" => "dft_feedback_form",
    "form_title" => "DFT Feedback Form",
    "submit_text" => "Submit Feedback"
  }
}
FormConfig.find_or_initialize_by(title: data['title']).update!(config: data['config'])

data = {
  "title" => "RTL Design Feedback Form",
  "config" => {
    "fields" => [
      {
        "name" => "candidate_bucket",
        "type" => "select",
        "label" => "Which bucket does this candidate fall into? (pick multiple if needed)",
        "options" => [
          {
            "label" => "ASIC RTL",
            "value" => "asic_rtl"
          },
          {
            "label" => "CDC",
            "value" => "cdc"
          },
          {
            "label" => "LINT",
            "value" => "lint"
          },
          {
            "label" => "LEC",
            "value" => "lec"
          },
          {
            "label" => "FPGA Design",
            "value" => "fpga_design"
          },
          {
            "label" => "Embedded",
            "value" => "embedded"
          },
          {
            "label" => "Validation",
            "value" => "validation"
          },
          {
            "label" => "Emulation",
            "value" => "emulation"
          },
          {
            "label" => "Prototyping",
            "value" => "prototyping"
          }
        ],
        "multiple" => true,
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Please select at least one bucket"
          }
        ]
      },
      {
        "name" => "candidate_bucket_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about candidate's bucket..."
      },
      {
        "name" => "candidate_domain",
        "type" => "select",
        "label" => "Which domain does the candidate belong to? (pick multiple if needed)",
        "options" => [
          {
            "label" => "Wireless",
            "value" => "wireless"
          },
          {
            "label" => "Wired",
            "value" => "wired"
          },
          {
            "label" => "Network",
            "value" => "network"
          },
          {
            "label" => "5G",
            "value" => "5g"
          },
          {
            "label" => "LTE",
            "value" => "lte"
          },
          {
            "label" => "Aerionics",
            "value" => "aerionics"
          },
          {
            "label" => "Defence",
            "value" => "defence"
          },
          {
            "label" => "Processor",
            "value" => "processor"
          },
          {
            "label" => "Multimedia",
            "value" => "multimedia"
          }
        ],
        "multiple" => true,
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Please select at least one domain"
          }
        ]
      },
      {
        "name" => "candidate_domain_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about candidate's domain..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "project_knowledge_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Past/Current Project Knowledge",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "project_knowledge_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => true,
        "placeholder" => "Enter comments about project knowledge...",
        "validations" => [
          {
            "type" => "required",
            "message" => "Comments are required"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "project_complexity_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Past/Current project complexity",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "project_complexity_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => true,
        "placeholder" => "Enter comments about project complexity...",
        "validations" => [
          {
            "type" => "required",
            "message" => "Comments are required"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "digital_logic_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Digital Logic (Basics)",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "digital_logic_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => true,
        "placeholder" => "Enter comments about digital logic...",
        "validations" => [
          {
            "type" => "required",
            "message" => "Comments are required"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "verilog_rtl_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Verilog / RTL",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "verilog_rtl_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => true,
        "placeholder" => "Enter comments about Verilog/RTL...",
        "validations" => [
          {
            "type" => "required",
            "message" => "Comments are required"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "asic_rtl_cdc_rating",
        "step" => 1,
        "type" => "number",
        "label" => "ASIC RTL-LINT/CDC/RDC",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "asic_rtl_cdc_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => true,
        "placeholder" => "Enter comments about ASIC RTL-LINT/CDC/RDC...",
        "validations" => [
          {
            "type" => "required",
            "message" => "Comments are required"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "asic_integration_rating",
        "step" => 1,
        "type" => "number",
        "label" => "ASIC Integration",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "asic_integration_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => true,
        "placeholder" => "Enter comments about ASIC integration...",
        "validations" => [
          {
            "type" => "required",
            "message" => "Comments are required"
          }
        ]
      },
      {
        "name" => "vclp_upf_lec_yn",
        "type" => "select",
        "label" => "VCLP/UPF/LEC",
        "options" => [
          {
            "label" => "Yes",
            "value" => "yes"
          },
          {
            "label" => "No",
            "value" => "no"
          }
        ],
        "multiple" => false,
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Selection is required"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "vclp_upf_lec_rating",
        "step" => 1,
        "type" => "number",
        "label" => "VCLP/UPF/LEC Rating (if yes)",
        "required" => false,
        "validations" => [
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "vclp_upf_lec_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about VCLP/UPF/LEC..."
      },
      {
        "name" => "synthesis_yn",
        "type" => "select",
        "label" => "Synthesis",
        "options" => [
          {
            "label" => "Yes",
            "value" => "yes"
          },
          {
            "label" => "No",
            "value" => "no"
          }
        ],
        "multiple" => false,
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Selection is required"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "synthesis_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Synthesis Rating (if yes)",
        "required" => false,
        "validations" => [
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "synthesis_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about synthesis..."
      },
      {
        "name" => "sta_fifo_yn",
        "type" => "select",
        "label" => "STA & FIFO Concepts",
        "options" => [
          {
            "label" => "Yes",
            "value" => "yes"
          },
          {
            "label" => "No",
            "value" => "no"
          }
        ],
        "multiple" => false,
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Selection is required"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "sta_fifo_rating",
        "step" => 1,
        "type" => "number",
        "label" => "STA & FIFO Concepts Rating (if yes)",
        "required" => false,
        "validations" => [
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "sta_fifo_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about STA & FIFO concepts..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "communication_attitude_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Communication Skills, Attitude and Sharpness",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "communication_attitude_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => true,
        "placeholder" => "Enter comments about communication, attitude and sharpness...",
        "validations" => [
          {
            "type" => "required",
            "message" => "Comments are required"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "memory_interface_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Memory Interface & Protocols",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "memory_interface_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => true,
        "placeholder" => "Enter comments about memory interface & protocols...",
        "validations" => [
          {
            "type" => "required",
            "message" => "Comments are required"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "overall_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Overall Rating",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "overall_observations",
        "type" => "textarea",
        "label" => "Overall Observations",
        "required" => true,
        "placeholder" => "Enter your overall observations...",
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall observations are required"
          }
        ]
      },
      {
        "name" => "decision",
        "type" => "select",
        "label" => "Decision (Mandatory to be filled)",
        "options" => [
          {
            "label" => "Hire",
            "value" => "hire"
          },
          {
            "label" => "No-Hire",
            "value" => "no-hire"
          }
        ],
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Decision is required"
          }
        ]
      }
    ],
    "form_name" => "rtl_design_feedback_form",
    "form_title" => "RTL Design Feedback Form",
    "submit_text" => "Submit Feedback"
  }
}
FormConfig.find_or_initialize_by(title: data['title']).update!(config: data['config'])

data = {
  "title" => "Analog Layout Feedback Form",
  "config" => {
    "fields" => [
      {
        "max" => 10,
        "min" => 0,
        "name" => "foundry_tech_nodes_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Foundry & Technology Nodes Handled (tsmc3, samsung4, intel7, etc)",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "foundry_tech_nodes_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about foundry and technology nodes experience..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "blocks_handled_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Blocks Handled (LDO/PLL/ADC/SerDes/DDR etc)",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "blocks_handled_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about blocks handled..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "basic_concepts_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Basic concepts & Methodology",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "basic_concepts_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about basic concepts and methodology..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "tech_understanding_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Technology understanding",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "tech_understanding_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about technology understanding..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "tool_knowledge_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Tool knowledge",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "tool_knowledge_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about tool knowledge..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "project_knowledge_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Project Knowledge",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "project_knowledge_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about project knowledge..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "communication_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Communication",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "overall_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Overall rating",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "overall_observation",
        "type" => "textarea",
        "label" => "Overall observation (Comments)",
        "required" => true,
        "placeholder" => "Enter your overall observations and comments...",
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall observation is required"
          }
        ]
      },
      {
        "name" => "decision",
        "type" => "select",
        "label" => "Decision (Mandatory to be filled)",
        "options" => [
          {
            "label" => "Hire",
            "value" => "hire"
          },
          {
            "label" => "No-Hire",
            "value" => "no-hire"
          }
        ],
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Decision is required"
          }
        ]
      }
    ],
    "form_name" => "analog_layout_feedback_form",
    "form_title" => "Analog Layout Feedback Form",
    "submit_text" => "Submit Feedback"
  }
}
FormConfig.find_or_initialize_by(title: data['title']).update!(config: data['config'])

data = {
  "title" => "Analog Design & Char Feedback Form",
  "config" => {
    "fields" => [
      {
        "max" => 10,
        "min" => 0,
        "name" => "foundry_tech_nodes_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Foundry & Technology Nodes Handled (tsmc3, samsung4, intel7, etc)",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "foundry_tech_nodes_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about foundry and technology nodes experience..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "blocks_handled_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Blocks Handled (LDO/PLL/ADC/SerDes/DDR etc)",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "blocks_handled_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about blocks handled..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "basic_concepts_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Basic concepts & Methodology",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "basic_concepts_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about basic concepts and methodology..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "tech_understanding_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Technology understanding",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "tech_understanding_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about technology understanding..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "tool_knowledge_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Tool knowledge",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "tool_knowledge_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about tool knowledge..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "project_knowledge_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Project Knowledge",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "project_knowledge_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about project knowledge..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "communication_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Communication",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "communication_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about communication skills..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "overall_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Overall rating",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "overall_observation",
        "type" => "textarea",
        "label" => "Overall observation (Comments)",
        "required" => true,
        "placeholder" => "Enter your overall observations and comments...",
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall observation is required"
          }
        ]
      },
      {
        "name" => "decision",
        "type" => "select",
        "label" => "Decision (Mandatory to be filled)",
        "options" => [
          {
            "label" => "Hire",
            "value" => "hire"
          },
          {
            "label" => "No-Hire",
            "value" => "no-hire"
          }
        ],
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Decision is required"
          }
        ]
      }
    ],
    "form_name" => "analog_design_char_feedback_form",
    "form_title" => "Analog Design & Char Feedback Form",
    "submit_text" => "Submit Feedback"
  }
}
FormConfig.find_or_initialize_by(title: data['title']).update!(config: data['config'])

data = {
  "title" => "Memory Layout Feedback Form",
  "config" => {
    "fields" => [
      {
        "max" => 10,
        "min" => 0,
        "name" => "foundry_tech_nodes_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Foundry & Technology Nodes Handled (tsmc3, samsung4, intel7, etc)",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "foundry_tech_nodes_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about foundry and technology nodes experience..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "memory_types_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Memory Types Handled (SRAM/ROM/TCAM/RegFiles)",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "memory_types_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about memory types handled..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "basic_concepts_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Basic concepts & Methodology",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "basic_concepts_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about basic concepts and methodology..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "tech_understanding_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Technology understanding",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "tech_understanding_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about technology understanding..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "tool_knowledge_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Tool knowledge",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "tool_knowledge_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about tool knowledge..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "project_knowledge_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Project Knowledge",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "project_knowledge_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about project knowledge..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "communication_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Communication",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "overall_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Overall rating",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "overall_observation",
        "type" => "textarea",
        "label" => "Overall observation (Comments)",
        "required" => true,
        "placeholder" => "Enter your overall observations and comments...",
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall observation is required"
          }
        ]
      },
      {
        "name" => "decision",
        "type" => "select",
        "label" => "Decision (Mandatory to be filled)",
        "options" => [
          {
            "label" => "Hire",
            "value" => "hire"
          },
          {
            "label" => "No-Hire",
            "value" => "no-hire"
          }
        ],
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Decision is required"
          }
        ]
      }
    ],
    "form_name" => "memory_layout_feedback_form",
    "form_title" => "Memory Layout Feedback Form",
    "submit_text" => "Submit Feedback"
  }
}
FormConfig.find_or_initialize_by(title: data['title']).update!(config: data['config'])

data = {
  "title" => "Memory Design/Char Feedback Form",
  "config" => {
    "fields" => [
      {
        "max" => 10,
        "min" => 0,
        "name" => "foundry_tech_nodes_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Foundry & Technology Nodes Handled (tsmc3, samsung4, intel7, etc)",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "foundry_tech_nodes_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about foundry and technology nodes experience..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "memory_types_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Memory Types Handled (SRAM/ROM/TCAM/RegFiles)",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "memory_types_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about memory types handled..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "basic_concepts_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Basic concepts & Methodology",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "basic_concepts_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about basic concepts and methodology..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "tech_understanding_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Technology understanding",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "tech_understanding_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about technology understanding..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "tool_knowledge_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Tool knowledge",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "tool_knowledge_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about tool knowledge..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "project_knowledge_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Project Knowledge",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "project_knowledge_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about project knowledge..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "communication_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Communication",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "overall_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Overall rating",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "overall_observation",
        "type" => "textarea",
        "label" => "Overall observation (Comments)",
        "required" => true,
        "placeholder" => "Enter your overall observations and comments...",
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall observation is required"
          }
        ]
      },
      {
        "name" => "decision",
        "type" => "select",
        "label" => "Decision (Mandatory to be filled)",
        "options" => [
          {
            "label" => "Hire",
            "value" => "hire"
          },
          {
            "label" => "No-Hire",
            "value" => "no-hire"
          }
        ],
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Decision is required"
          }
        ]
      }
    ],
    "form_name" => "memory_design_char_feedback_form",
    "form_title" => "Memory Design/Char Feedback Form",
    "submit_text" => "Submit Feedback"
  }
}
FormConfig.find_or_initialize_by(title: data['title']).update!(config: data['config'])

data = {
  "title" => "StdCell Layout Feedback Form",
  "config" => {
    "fields" => [
      {
        "max" => 10,
        "min" => 0,
        "name" => "foundry_tech_nodes_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Foundry & Technology Nodes Handled (tsmc3, samsung4, intel7, etc)",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "foundry_tech_nodes_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about foundry and technology nodes experience..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "libraries_cells_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Libraries and Cells Handled",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "libraries_cells_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about libraries and cells handled..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "basic_concepts_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Basic concepts & Methodology",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "basic_concepts_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about basic concepts and methodology..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "tech_understanding_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Technology understanding",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "tech_understanding_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about technology understanding..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "tool_knowledge_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Tool knowledge",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "tool_knowledge_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about tool knowledge..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "project_knowledge_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Project Knowledge",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "project_knowledge_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about project knowledge..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "communication_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Communication",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "overall_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Overall rating",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "overall_observation",
        "type" => "textarea",
        "label" => "Overall observation (Comments)",
        "required" => true,
        "placeholder" => "Enter your overall observations and comments...",
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall observation is required"
          }
        ]
      },
      {
        "name" => "decision",
        "type" => "select",
        "label" => "Decision (Mandatory to be filled)",
        "options" => [
          {
            "label" => "Hire",
            "value" => "hire"
          },
          {
            "label" => "No-Hire",
            "value" => "no-hire"
          }
        ],
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Decision is required"
          }
        ]
      }
    ],
    "form_name" => "stdcell_layout_feedback_form",
    "form_title" => "StdCell Layout Feedback Form",
    "submit_text" => "Submit Feedback"
  }
}
FormConfig.find_or_initialize_by(title: data['title']).update!(config: data['config'])

data = {
  "title" => "StdCell Design/Char Feedback Form",
  "config" => {
    "fields" => [
      {
        "max" => 10,
        "min" => 0,
        "name" => "foundry_tech_nodes_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Foundry & Technology Nodes Handled (tsmc3, samsung4, intel7, etc)",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "foundry_tech_nodes_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about foundry and technology nodes experience..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "libraries_cells_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Libraries and Cells Handled",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "libraries_cells_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about libraries and cells handled..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "basic_concepts_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Basic concepts & Methodology",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "basic_concepts_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about basic concepts and methodology..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "tech_understanding_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Technology understanding",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "tech_understanding_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about technology understanding..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "tool_knowledge_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Tool knowledge",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "tool_knowledge_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about tool knowledge..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "project_knowledge_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Project Knowledge",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "project_knowledge_comments",
        "label" => "Comments",
        "极type" => "textarea",
        "required" => false,
        "placeholder" => "Enter comments about project knowledge..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "communication_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Communication",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "overall_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Overall rating",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "overall_observation",
        "type" => "textarea",
        "label" => "Overall observation (Comments)",
        "required" => true,
        "placeholder" => "Enter your overall observations and comments...",
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall observation is required"
          }
        ]
      },
      {
        "name" => "decision",
        "type" => "select",
        "label" => "Decision (Mandatory to be filled)",
        "options" => [
          {
            "label" => "Hire",
            "value" => "hire"
          },
          {
            "label" => "No-Hire",
            "value" => "no-hire"
          }
        ],
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Decision is required"
          }
        ]
      }
    ],
    "form_name" => "stdcell_design_char_feedback_form",
    "form_title" => "StdCell Design/Char Feedback Form",
    "submit_text" => "Submit Feedback"
  }
}
FormConfig.find_or_initialize_by(title: data['title']).update!(config: data['config'])

data = {
  "title" => "Hardware Board Design Feedback Form",
  "config" => {
    "fields" => [
      {
        "max" => 10,
        "min" => 0,
        "name" => "basic_knowledge_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Basic Knowledge",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "component_selection_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Component selection",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "schematic_capture_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Schematic Capture",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "programming_knowledge_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Programming Knowledge",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "serial_interface_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Serial Interface",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "high_speed_skill_rating",
        "step" => 1,
        "type" => "number",
        "label" => "High speed skill",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "display_camera_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Display Module/Camera",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "ddr_rating",
        "step" => 1,
        "type" => "number",
        "label" => "DDR",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "simulation_experience_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Simulation experience",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "power_supply_design_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Power supply design Skill set",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "board_testing_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Board testing",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "si_pi_rating",
        "step" => 1,
        "type" => "number",
        "label" => "SI and PI",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "layout_experience_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Layout experience",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "team_handling_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Team Handling skill set",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "tool_exposure_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Tool exposure",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "lt_spice_rating",
        "step" => 1,
        "type" => "number",
        "label" => "LT Spice",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "communication_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Communication",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "overall_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Overall rating",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "overall_observation",
        "type" => "textarea",
        "label" => "Overall observation (Comments)",
        "required" => true,
        "placeholder" => "Enter your overall observations and comments...",
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall observation is required"
          }
        ]
      },
      {
        "name" => "decision",
        "type" => "select",
        "label" => "Decision (Mandatory to be filled)",
        "options" => [
          {
            "label" => "Hire",
            "value" => "hire"
          },
          {
            "label" => "No-Hire",
            "value" => "no-hire"
          }
        ],
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Decision is required"
          }
        ]
      }
    ],
    "form_name" => "hardware_board_design_feedback_form",
    "form_title" => "Hardware Board Design Feedback Form",
    "submit_text" => "Submit Feedback"
  }
}
FormConfig.find_or_initialize_by(title: data['title']).update!(config: data['config'])

data = {
  "title" => "Functional Validation Feedback Form",
  "config" => {
    "fields" => [
      {
        "max" => 10,
        "min" => 0,
        "name" => "communication_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Communication",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "attitude_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Attitude",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "energy_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Energy",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "project_knowledge_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Project Knowledge",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "c_program_development_rating",
        "step" => 1,
        "type" => "number",
        "label" => "C Program Development Experience",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "soc_architecture_rating",
        "step" => 1,
        "type" => "number",
        "label" => "SoC Architecture",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "ip_knowledge_rating",
        "step" => 1,
        "type" => "number",
        "label" => "IP Knowledge",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "test_environment_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Test Environment",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "interview_mode",
        "type" => "select",
        "label" => "Mode of Interview (TCON/VCON/F2F)",
        "options" => [
          {
            "label" => "TCON",
            "value" => "tcon"
          },
          {
            "label" => "VCON",
            "value" => "vcon"
          },
          {
            "label" => "F2F",
            "value" => "f2f"
          }
        ],
        "multiple" => false,
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Interview mode is required"
          }
        ]
      },
      {
        "name" => "comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter additional comments..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "overall_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Overall Rating",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "overall_observation",
        "type" => "textarea",
        "label" => "Overall Observation(Comments)",
        "required" => true,
        "placeholder" => "Enter your overall observations and comments...",
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall observation is required"
          }
        ]
      },
      {
        "name" => "decision",
        "type" => "select",
        "label" => "Decision (Mandatory to be filled)",
        "options" => [
          {
            "label" => "Hire",
            "value" => "hire"
          },
          {
            "label" => "No-Hire",
            "value" => "no-hire"
          }
        ],
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Decision is required"
          }
        ]
      }
    ],
    "form_name" => "functional_validation_feedback_form",
    "form_title" => "Functional Validation Feedback Form",
    "submit_text" => "Submit Feedback"
  }
}
FormConfig.find_or_initialize_by(title: data['title']).update!(config: data['config'])

data = {
  "title" => "Electrical Validation Feedback Form",
  "config" => {
    "fields" => [
      {
        "max" => 10,
        "min" => 0,
        "name" => "communication_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Communication",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "attitude_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Attitude",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "energy_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Energy",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "project_knowledge_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Project Knowledge",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "automation_experience_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Automation Experience",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "pvt_validation_rating",
        "step" => 1,
        "type" => "number",
        "label" => "PVT Validation",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "ip_knowledge_rating",
        "step" => 1,
        "type" => "number",
        "label" => "IP Knowledge",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "test_environment_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Test Environment",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "interview_mode",
        "type" => "select",
        "label" => "Mode of Interview (TCON/VCON/F2F)",
        "options" => [
          {
            "label" => "TCON",
            "value" => "tcon"
          },
          {
            "label" => "VCON",
            "value" => "vcon"
          },
          {
            "label" => "F2F",
            "value" => "f2f"
          }
        ],
        "multiple" => false,
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Interview mode is required"
          }
        ]
      },
      {
        "name" => "comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter additional comments..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "overall_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Overall Ratings",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "overall_observation",
        "type" => "textarea",
        "label" => "Overall Observation(Comments)",
        "required" => true,
        "placeholder" => "Enter your overall observations and comments...",
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall observation is required"
          }
        ]
      },
      {
        "name" => "decision",
        "type" => "select",
        "label" => "Decision (Mandatory to be filled)",
        "options" => [
          {
            "label" => "Hire",
            "value" => "hire"
          },
          {
            "label" => "No-Hire",
            "value" => "no-hire"
          }
        ],
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Decision is required"
          }
        ]
      }
    ],
    "form_name" => "electrical_validation_feedback_form",
    "form_title" => "Electrical Validation Feedback Form",
    "submit_text" => "Submit Feedback"
  }
}
FormConfig.find_or_initialize_by(title: data['title']).update!(config: data['config'])

data = {
  "title" => "Power, Thermal, Performance Feedback Form",
  "config" => {
    "fields" => [
      {
        "max" => 10,
        "min" => 0,
        "name" => "communication_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Communication",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "attitude_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Attitude",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "energy_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Energy",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "project_knowledge_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Project Knowledge",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "automation_experience_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Automation Experience",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "power_thermal_performance_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Power/Thermal/Performance",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "test_environment_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Test Environment",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "interview_mode",
        "type" => "select",
        "label" => "Mode of Interview (TCON/VCON/F2F)",
        "options" => [
          {
            "label" => "TCON",
            "value" => "tcon"
          },
          {
            "label" => "VCON",
            "value" => "vcon"
          },
          {
            "label" => "F2F",
            "value" => "f2f"
          }
        ],
        "multiple" => false,
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Interview mode is required"
          }
        ]
      },
      {
        "name" => "comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter additional comments..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "overall_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Overall ratings",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "overall_observation",
        "type" => "textarea",
        "label" => "Overall Observation(Comments)",
        "required" => true,
        "placeholder" => "Enter your overall observations and comments...",
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall observation is required"
          }
        ]
      },
      {
        "name" => "decision",
        "type" => "select",
        "label" => "Decision (Mandatory to be filled)",
        "options" => [
          {
            "label" => "Hire",
            "value" => "hire"
          },
          {
            "label" => "No-Hire",
            "value" => "no-hire"
          }
        ],
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Decision is required"
          }
        ]
      }
    ],
    "form_name" => "power_thermal_performance_feedback_form",
    "form_title" => "Power, Thermal, Performance Feedback Form",
    "submit_text" => "Submit Feedback"
  }
}
FormConfig.find_or_initialize_by(title: data['title']).update!(config: data['config'])

data = {
  "title" => "Validation Board Design Feedback Form",
  "config" => {
    "fields" => [
      {
        "max" => 10,
        "min" => 0,
        "name" => "functional_validation_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Functional Validation",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "communication_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Communication",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "attitude_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Attitude",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "energy_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Energy",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "project_technical_knowledge_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Project Technical Knowledge",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "analog_digital_basics_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Basic's of Analog and Digital",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "architecture_knowledge_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Basic knowledge on Uc/uP/ARM Architecture/any SOC/Embedded system/based on JD",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "design_tools_knowledge_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Knowledge on Different types of Design tools-- Orcad capture, Altium, Allegro-X, Mentor Graphic's etc..",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "test_environment_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Test Environment- EDVT, board Interfaces validation, Chip validation(optional)",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "interview_mode",
        "type" => "select",
        "label" => "Mode of Interview (TCON/VCON/F2F)",
        "options" => [
          {
            "label" => "TCON",
            "value" => "tcon"
          },
          {
            "label" => "VCON",
            "value" => "vcon"
          },
          {
            "label" => "F2F",
            "value" => "f2f"
          }
        ],
        "multiple" => false,
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Interview mode is required"
          }
        ]
      },
      {
        "name" => "comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter additional comments..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "overall_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Overall rating",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "overall_observation",
        "type" => "textarea",
        "label" => "Overall Observation(Comments)",
        "required" => true,
        "placeholder" => "Enter your overall observations and comments...",
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall observation is required"
          }
        ]
      },
      {
        "name" => "decision",
        "type" => "select",
        "label" => "Decision (Mandatory to be filled)",
        "options" => [
          {
            "label" => "Hire",
            "value" => "hire"
          },
          {
            "label" => "No-Hire",
            "value" => "no-hire"
          }
        ],
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Decision is required"
          }
        ]
      }
    ],
    "form_name" => "validation_board_design_feedback_form",
    "form_title" => "Validation Board Design Feedback Form",
    "submit_text" => "Submit Feedback"
  }
}
FormConfig.find_or_initialize_by(title: data['title']).update!(config: data['config'])

data = {
  "title" => "IC Package Feedback Form",
  "config" => {
    "fields" => [
      {
        "max" => 10,
        "min" => 0,
        "name" => "basic_knowledge_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Basic Knowledge",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "basic_knowledge_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about basic knowledge..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "tool_exposure_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Tool exposure",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "tool_exposure_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about tool exposure..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "design_flow_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Design Flow",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "design_flow_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about design flow..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "package_technologies_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Package Technologies Exposure",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "package_technologies_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about package technologies exposure..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "high_speed_interface_rating",
        "step" => 1,
        "type" => "number",
        "label" => "High speed interface experience",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "high_speed_interface_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about high speed interface experience..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "si_pi_knowledge_rating",
        "step" => 1,
        "type" => "number",
        "label" => "SI/PI knowledge/exposure",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "si_pi_knowledge_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about SI/PI knowledge/exposure..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "library_management_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Library Management",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "library_management_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about library management..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "team_handling_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Team Handing skill set",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "team_handling_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about team handling skills..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "communication_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Communication",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "communication_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about communication skills..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "overall_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Over all rating",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "overall_observation",
        "type" => "textarea",
        "label" => "Overall Observation(Comments)",
        "required" => true,
        "placeholder" => "Enter your overall observations and comments...",
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall observation is required"
          }
        ]
      },
      {
        "name" => "decision",
        "type" => "select",
        "label" => "Decision (Mandatory to be filled)",
        "options" => [
          {
            "label" => "Hire",
            "value" => "hire"
          },
          {
            "label" => "No-Hire",
            "value" => "no-hire"
          }
        ],
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Decision is required"
          }
        ]
      }
    ],
    "form_name" => "ic_package_feedback_form",
    "form_title" => "IC Package Feedback Form",
    "submit_text" => "Submit Feedback"
  }
}
FormConfig.find_or_initialize_by(title: data['title']).update!(config: data['config'])

data = {
  "title" => "ATE Feedback Form",
  "config" => {
    "fields" => [
      {
        "max" => 10,
        "min" => 0,
        "name" => "test_plan_generation_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Test plan generation",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "test_plan_generation_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about test plan generation..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "cpp_java_knowledge_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Basic C++/Java knowledge",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "cpp_java_knowledge_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about C++/Java knowledge..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "test_flow_debugging_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Test flow creation/Debugging",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "test_flow_debugging_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about test flow creation/debugging..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "performance_analysis_tools_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Performance analysis tools(TP360, STDF analyser)",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "performance_analysis_tools_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about performance analysis tools..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "ate_loadboard_design_rating",
        "step" => 1,
        "type" => "number",
        "label" => "ATE Loadboard design as per the test requirements(Site config/Max power/SI analysis/layout review)",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "ate_loadboard_design_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter comments about ATE loadboard design..."
      },
      {
        "name" => "interview_mode",
        "type" => "select",
        "label" => "Mode of Interview (TCON/VCON/F2F)",
        "options" => [
          {
            "label" => "TCON",
            "value" => "tcon"
          },
          {
            "label" => "VCON",
            "value" => "vcon"
          },
          {
            "label" => "F2F",
            "value" => "f2f"
          }
        ],
        "multiple" => false,
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Interview mode is required"
          }
        ]
      },
      {
        "name" => "general_comment",
        "type" => "textarea",
        "label" => "Comment",
        "required" => false,
        "placeholder" => "Enter additional comments..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "overall_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Overall Rating",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "overall_observation",
        "type" => "textarea",
        "label" => "Overall Observation(Comments)",
        "required" => true,
        "placeholder" => "Enter your overall observations and comments...",
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall observation is required"
          }
        ]
      },
      {
        "name" => "decision",
        "type" => "select",
        "label" => "Decision (Mandatory to be filled)",
        "options" => [
          {
            "label" => "Hire",
            "value" => "hire"
          },
          {
            "label" => "No-Hire",
            "value" => "no-hire"
          }
        ],
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Decision is required"
          }
        ]
      }
    ],
    "form_name" => "ate_feedback_form",
    "form_title" => "ATE Feedback Form",
    "submit_text" => "Submit Feedback"
  }
}
FormConfig.find_or_initialize_by(title: data['title']).update!(config: data['config'])

data = {
  "title" => "PCB Layout Feedback Form",
  "config" => {
    "fields" => [
      {
        "max" => 10,
        "min" => 0,
        "name" => "basic_knowledge_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Basic Knowledge",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "basic_knowledge_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about basic knowledge..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "tool_exposure_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Tool exposure",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "tool_exposure_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about tool exposure..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "design_flow_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Design Flow",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "design_flow_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about design flow..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "hdi_exposure_rating",
        "step" => 1,
        "type" => "number",
        "label" => "HDI exposure",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "hdi_exposure_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about HDI exposure..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "high_speed_interface_rating",
        "step" => 1,
        "type" => "number",
        "label" => "High speed interface experience",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "high_speed_interface_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about high speed interface experience..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "si_pi_knowledge_rating",
        "step" => 1,
        "type" => "number",
        "label" => "SI/PI knowledge/exposure",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "si_pi_knowledge_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about SI/PI knowledge/exposure..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "library_management_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Library Management",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "library_management_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about library management..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "team_handling_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Team Handing skill set",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "team_handling_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about team handling skills..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "communication_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Communication",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "communication_comments",
        "type" => "textarea",
        "label" => "Comments",
        "required" => false,
        "placeholder" => "Enter comments about communication skills..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "overall_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Overall rating",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "overall_observation",
        "type" => "textarea",
        "label" => "Overall Observation(Comments)",
        "required" => true,
        "placeholder" => "Enter your overall observations and comments...",
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall observation is required"
          }
        ]
      },
      {
        "name" => "decision",
        "type" => "select",
        "label" => "Decision (Mandatory to be filled)",
        "options" => [
          {
            "label" => "Hire",
            "value" => "hire"
          },
          {
            "label" => "No-Hire",
            "value" => "no-hire"
          }
        ],
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Decision is required"
          }
        ]
      }
    ],
    "form_name" => "pcb_layout_feedback_form",
    "form_title" => "PCB Layout Feedback Form",
    "submit_text" => "Submit Feedback"
  }
}
FormConfig.find_or_initialize_by(title: data['title']).update!(config: data['config'])

data = {
  "title" => "Campus Feedback Form",
  "config" => {
    "fields" => [
      {
        "name" => "candidate_name",
        "type" => "text",
        "label" => "Candidate Name",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Candidate name is required"
          }
        ]
      },
      {
        "name" => "college_name",
        "type" => "text",
        "label" => "College Name",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "College name is required"
          }
        ]
      },
      {
        "name" => "engineering_branch",
        "type" => "select",
        "label" => "Which branch of Engineering",
        "options" => [
          {
            "label" => "E&C",
            "value" => "ec"
          },
          {
            "label" => "EE",
            "value" => "ee"
          }
        ],
        "multiple" => false,
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Engineering branch is required"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "attitude_sharpness_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Attitude and Sharpness",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "communication_skills_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Communication Skills",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "project_knowledge_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Project knowledge",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "project_complexity_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Past/Current project complexity",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "protocols_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Protocols Checked (Name of protocol(s) and Rating(s))",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "protocols_details",
        "type" => "textarea",
        "label" => "Protocol Details",
        "required" => false,
        "placeholder" => "Enter protocol names and details..."
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "digital_logic_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Digital Logic (Basics)",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "digital_logic_online_score",
        "type" => "number",
        "label" => "Online Score",
        "required" => false,
        "placeholder" => "Enter online score for Digital Logic"
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "verilog_rtl_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Verilog / RTL",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "verilog_rtl_online_score",
        "type" => "number",
        "label" => "Online Score",
        "required" => false,
        "placeholder" => "Enter online score for Verilog/RTL"
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "linux_analytics_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Linux Basics / Analytics",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "linux_analytics_online_score",
        "type" => "number",
        "label" => "Online Score",
        "required" => false,
        "placeholder" => "Enter online score for Linux/Analytics"
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "c_programming_rating",
        "step" => 1,
        "type" => "number",
        "label" => "C-programming",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "c_programming_online_score",
        "type" => "number",
        "label" => "Online Score",
        "required" => false,
        "placeholder" => "Enter online score for C-programming"
      },
      {
        "name" => "observations",
        "type" => "textarea",
        "label" => "Observations (Mandatory to be filled)",
        "required" => true,
        "placeholder" => "Enter your observations...",
        "validations" => [
          {
            "type" => "required",
            "message" => "Observations are required"
          }
        ]
      },
      {
        "max" => 10,
        "min" => 0,
        "name" => "overall_rating",
        "step" => 1,
        "type" => "number",
        "label" => "Overall Rating (Mandatory to be filled)",
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Overall rating is required"
          },
          {
            "type" => "min",
            "value" => 0,
            "message" => "Rating must be at least 0"
          },
          {
            "type" => "max",
            "value" => 10,
            "message" => "Rating cannot exceed 10"
          }
        ]
      },
      {
        "name" => "decision",
        "type" => "select",
        "label" => "Decision (Mandatory to be filled)",
        "options" => [
          {
            "label" => "REJECTED",
            "value" => "rejected"
          },
          {
            "label" => "ON HOLD",
            "value" => "on_hold"
          },
          {
            "label" => "HIRE",
            "value" => "hire"
          },
          {
            "label" => "HIRE +",
            "value" => "hire_plus"
          }
        ],
        "multiple" => false,
        "required" => true,
        "validations" => [
          {
            "type" => "required",
            "message" => "Decision is required"
          }
        ]
      },
      {
        "name" => "additional_comments",
        "type" => "textarea",
        "label" => "Additional Comments",
        "required" => false,
        "placeholder" => "Enter any additional comments..."
      }
    ],
    "form_name" => "campus_feedback_form",
    "form_title" => "Campus Feedback Form",
    "submit_text" => "Submit Feedback"
  }
}
FormConfig.find_or_initialize_by(title: data['title']).update!(config: data['config'])

