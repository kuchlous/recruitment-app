# app/views/api/requirements/index.json.jbuilder

json.array! @requirements do |requirement|
  json.id          requirement.id
  json.name        requirement.name
  json.description requirement.description
  json.status      requirement.status
  json.edate       requirement.edate.try(:strftime, '%b %d, %Y')
  json.experience  requirement.exp
  json.positions   requirement.nop
  json.owner       requirement.employee.name
  json.req_type    requirement.req_type
end