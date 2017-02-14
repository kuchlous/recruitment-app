module ResumeHelper

  def print_date(idate)
    r = "N/A"
    if (idate)
      r = idate.strftime('%b %d, %Y')
    end
    return r
  end

  def sort_interviews_in_display_order(matches)
    matches.sort_by { |r| [r.get_display_interview_date ? r.get_display_interview_date : Date.today ] }
  end

  def get_interview_dates_and_times(match)
    interviews = match.interviews
    interviews.sort_by { |i| [i.interview_date, i.interview_time.seconds_since_midnight] }
    times = []
    interviews.each do |i|
      times << print_date(i.interview_date) + '/' + print_time(i.interview_time)
    end
    times.join("\n")
  end

  def get_all_ratings(match)
    feedbacks = match.resume.feedbacks
    ratings = []
    feedbacks.each do |f|
      ratings << f.employee.name + ':' + f.numerical_rating.to_s
    end
    ratings.join("\n")
  end

  def get_interview_row_class(req_match, interview)
    if interview.interview_date
      if interview.status == "DECLINED"
        row_class = "red"
      elsif req_match.is_feedback_given(interview.employee)
        row_class = "green"
      elsif interview.interview_date < Date.today
        row_class = "pink"
      else
        row_class = "yellow"
      end
    else
      row_class = "white"
    end
  end

  def is_display_form
    if params[:action] == "manager_index"       ||
      params[:action]  == "manager_shortlisted" ||
      params[:action]  == "shortlisted"         ||
      params[:action]  == "forwarded"
      return 1
    else
      return 0
    end
  end

  def get_date_when_resume_moved_to_joining(resume)
    comments = resume.comments
    comments.each do |c|
      if /^JOINING/.match(c.comment)
        return c.updated_at
      else
        matches = resume.req_matches
        matches.each do |m|
          if m.status == "JOINING"
            return m.updated_at
          end
        end
      end
    end
  end

  def get_image_name(resume)
    like_to_join = resume.likely_to_join
    if like_to_join == "R"
     return "Red"
    elsif like_to_join == "G"
     return "Green"
    else
     return "Orange"
    end
  end

  def get_rating(feedback)
    return feedback.rating
  end

  def get_feedback_rating_average(feedbacks)
    feedback_avg = 0;
    feedback = Hash.new
    feedback["Poor"] = 1
    feedback["Fair"] = 2
    feedback["Good"] = 3
    feedback["Very Good"] = 4
    feedback["Excellent"] = 5
    feedbacks.each do |f|
      logger.info(f.rating)
      feedback_avg += feedback[f.rating]
      logger.info(feedback[f.rating])
    end
    logger.info(feedback_avg)
    return (feedbacks.size == 0) ? 0 : (feedback_avg.to_f/(feedbacks.size)).round(2)
  end
end
