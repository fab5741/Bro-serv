local self = BF.modules['boot']

BF.items = {}
BF.jobs  = {}

BF.doesJobExist = function(job, grade)

  grade = tostring(grade)

  if job and grade and BF.Jobs[job] and BF.Jobs[job].grades[grade] then
    return true
  end

  return false

end