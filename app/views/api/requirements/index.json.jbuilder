# app/views/api/requirements/index.json.jbuilder

json.array! @requirements do |requirement|
  json.id          requirement.id
  json.name        requirement.name
  json.skill requirement.skill
  json.status      requirement.status
  json.edate       requirement.edate.try(:strftime, '%b %d, %Y')
  json.experience  "#{requirement.exp} (#{requirement.designation.name})"
  json.positions   requirement.nop
  json.owner       requirement.employee.name
  json.req_type    requirement.req_type
  json.created_at  requirement.created_at.try(:strftime, '%b %d, %Y')
  json.group       requirement.group.name
end
