require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_s = Student.new
    new_s.id = row[0]
    new_s.name = row[1]
    new_s.grade = row[2]
    new_s
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
    SELECT * FROM students
    SQL

    data = DB[:conn].execute(sql)

    data.map do |row|
      Student.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
    SELECT * FROM students WHERE name = ? LIMIT 1
    SQL

    data = DB[:conn].execute(sql, name).flatten
    self.new_from_db(data)
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
    SELECT * FROM students WHERE grade = ?
    SQL

    data = DB[:conn].execute(sql, 9)

    data.map do |row|
      Student.new_from_db(row)
    end
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT * FROM students WHERE grade < ?
    SQL

    data = DB[:conn].execute(sql, 12)

    data.map do |row|
      Student.new_from_db(row)
    end
  end

  def self.first_X_students_in_grade_10(limit_num)
    sql = <<-SQL
    SELECT * FROM students WHERE grade = 10 LIMIT ?
    SQL

    data = DB[:conn].execute(sql, limit_num)

    data.map do |row|
      Student.new_from_db(row)
    end
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT * FROM students WHERE grade = 10 LIMIT 1
    SQL

    data = DB[:conn].execute(sql)

    data.map do |row|
      Student.new_from_db(row)
    end[0]
  end

  def self.all_students_in_grade_X(grade_num)
    sql = <<-SQL
    SELECT * FROM students WHERE grade = ?
    SQL

    data = DB[:conn].execute(sql, grade_num)

    data.map do |row|
      Student.new_from_db(row)
    end
  end

end
