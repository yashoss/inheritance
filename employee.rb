class Employee
  attr_accessor :salary
  def initialize(name, title, salary, boss)
    @name = name
    @title = title
    @salary = salary
    @boss = boss
  end

  def bonus(multiplier)
    bonus = @salary * multiplier
  end
end

class Manager < Employee
  attr_accessor :employees

  def initialize(name, title, salary, boss, employees = [])
    @employees = employees
    super(name, title, salary, boss)
  end

  def bonus(multiplier)
    sum = 0
    @employees.each do |employee|
      if employee.class == Manager
        sum += employee.subsalary + employee.salary
      else
        sum += employee.salary
      end
    end
    sum * multiplier
  end

  def subsalary
    total = 0
    @employees.each do |employee|
      if employee.class == Manager
        total += employee.subsalary + employee.salary
      else
        total += employee.salary
      end
    end
    total
  end

end
