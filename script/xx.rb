require 'ruby-prof'
RubyProf.start
  def get_all_req_matches_of_status(status)
    matches = nil
    if (status == "JOINING")
      matches = ReqMatch.find_by_sql("SELECT * FROM req_matches INNER JOIN resumes ON resumes.id = req_matches.resume_id WHERE req_matches.status = \"JOINING\" AND resumes.status != \"JOINED\" ")
    else
      matches = ReqMatch.find_all_by_status(status);
      if (status != "SCHEDULED" && status != "OFFERED" && status != "JOINED")
        matches = matches.find_all { |m|
           m.requirement.isOPEN?
        }
      end
    end
    matches
  end

  def find_joining_resumes
    matches = ReqMatch.find_by_sql("SELECT * FROM req_matches INNER JOIN resumes ON resumes.id = req_matches.resume_id WHERE req_matches.status = \"JOINING\" AND resumes.status != \"JOINED\" AND resumes.joining_date >= \"#{Date.today - 365}.to_s\" ORDER BY resumes.joining_date")
    matches = matches.find_all { |m|
                m.resume.resume_overall_status == "Joining Date Given"
              }
    joined_resumes   = Resume.find_by_sql("SELECT * FROM resumes WHERE resumes.status = \"JOINED\" ORDER BY joining_date")
    not_joined_resumes = Resume.find_all_by_status("SELECT * FROM resumes WHERE resumes.status = \"NOT JOINED\" ORDER BY joining_date")
    [matches, joined_resumes, not_joined_resumes]
  end

  def fill_months_table(months_table, full_table, type)
    month_index = 0
    full_table.each do |r|
      r_date = r.joining_date 
      r_year = r_date.year
      r_month = r_date.month
      while (r_year != months_table[month_index][:year] ||
             r_month != months_table[month_index][:month])
        month_index += 1
      end
      months_table[month_index][type] += 1
    end
  end

  def start_of_month(date)
    Date.new(date.year, date.month, 1)
  end

  def end_of_month(date)
    Date.new(date.year, date.month, Time::days_in_month(date.month, date.year))
  end

  def filter_by_joining_date(resumes, start_date, end_date)
    resumes.find_all { |r| 
      r.joining_date && r.joining_date >= start_date && r.joining_date <= end_date
    }
  end

  def create_months_table(joining_matches, joined, not_joined)
    start_date = start_of_month(Date.today - 360)
    end_date = end_of_month(Date.today + 90)

    # Normalize to 0 .. 11
    start_month = start_date.month - 1
    year = start_date.year
    months_table = []
    0.upto 15 do |i|
      months_table[i] = {}
      # Add '1' to get back 1 .. 12
      month = ((start_month + i) % 12) + 1
      months_table[i][:month] = month
      months_table[i][:year] = year
      months_table[i][:joining] = 0
      months_table[i][:joined] = 0
      months_table[i][:not_joined] = 0
      if (month == 12)
        year = year + 1
      end
    end

    joining = []
    joining_matches.each do |m|
      joining << m.resume
    end

    fill_months_table(months_table, filter_by_joining_date(joining, start_date, end_date), :joining)
    fill_months_table(months_table, filter_by_joining_date(joined, start_date, end_date), :joined)
    fill_months_table(months_table, filter_by_joining_date(not_joined, start_date, end_date), :not_joined)

    months_table
  end

  def get_current_quarter_resumes(status)
    resumes = Resume.find_by_sql("select * FROM resumes WHERE resumes.status = \"#{status}\" AND resumes.joining_date >= \"#{Date.today.beginning_of_quarter.to_s}\"")
    resumes  = resumes.sort_by { |r| [!r.joining_date.nil? ?  r.joining_date : Date.today ] }
  end

  def get_current_quarter_resumes_for_offered
    offered_comments = Comment.find_by_sql("select * FROM comments WHERE comments.comment LIKE \"OFFERED%\" AND comments.created_at >= \"#{Date.today.beginning_of_quarter.to_s}\"") 
    offered_comments.uniq_by { |c| c.resume }
  end

  def get_quarterly_comments_not_accepted_new(date)
    resumes  = Resume.find_all_by_status("N_ACCEPTED")

    start_date = date ? date.beginning_of_quarter : nil
    end_date = date ? date.end_of_quarter : nil
    start_date_s = date ? date.beginning_of_quarter.to_s : nil
    end_date_s = date ? date.end_of_quarter.to_s : nil

    resumes = resumes.find_all { |r| r.comments.last.created_at > start_date } if (date) 

    not_accepted_comments = []
    resumes.each do |r|
      comments = []

      if date
      	comments = Comment.find_by_sql("select * FROM comments WHERE comments.resume_id = #{r.id} AND (comments.comment LIKE \"OFFERED%\" OR comments.comment LIKE \"%NOT ACCEPTED%\") AND (comments.created_at >= \"#{start_date_s}\" AND comments.created_at <= \"#{end_date_s}\") ORDER BY created_at DESC") 
      else
      	comments = Comment.find_by_sql("select * FROM comments WHERE comments.resume_id = #{r.id} AND (comments.comment LIKE \"OFFERED%\" OR comments.comment LIKE \"%NOT ACCEPTED%\") ORDER BY created_at DESC") 
      end

      not_accepted_comment = nil
      offered_comment = nil
      comments.each do |c|
        # only interested in last not_accepted 
        if not_accepted_comment == nil && c.comment.include?("NOT ACCEPTED")
          not_accepted_comment = c
          next
        end
        if not_accepted_comment && c.comment.include?("OFFERED")
          offered_comment = c
          break
        end
      end
      if not_accepted_comment
        n_accepted = {}
        n_accepted[:not_accepted] = not_accepted_comment
        n_accepted[:offered] = offered_comment
        not_accepted_comments << n_accepted
      end
    end
    not_accepted_comments.sort_by { |c| c[:not_accepted].created_at }
  end

  def joined
    @status             = "JOINING"
    @join_on_req_page   = @offer_on_req_page = 0
    @matches, joined_resumes, not_joined_resumes = find_joining_resumes
    @months_table       = create_months_table(@matches, joined_resumes, not_joined_resumes)
    @joined_resumes     = get_current_quarter_resumes("JOINED")
    @not_joined_resumes = get_current_quarter_resumes("NOT JOINED")
    @offered_comments   = get_current_quarter_resumes_for_offered
    @not_accepted_comments = get_quarterly_comments_not_accepted_new(Date.today)
  end

  joined

  result = RubyProf.stop
# Print a graph profile to text
  printer = RubyProf::GraphPrinter.new(result)
  printer.print(STDOUT, {})
