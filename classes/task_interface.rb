require 'singleton'
require_relative '../modules/savable'
require_relative '../modules/printable'

class TaskInterface
  include Singleton
  include Savable
  include Printable

  DATABASE_PATH = '../database.json'

  attr_accessor :tasks

  def initialize
    self.tasks = load_data(DATABASE_PATH) || {}
  end

  def max_id
    tasks.map { |key, task| key.to_s.to_i }.max || 0
  end

  def add(description)
    raise ArgumentError, 'please provide a description' if description.nil? || description.empty?

    id = max_id + 1
    tasks[id] = {
      id:,
      description:,
      status: 'todo',
      created_at: Time.now,
      updated_at: Time.now
    }

    save_to_database

    puts "Task added successfully (ID: #{id})"
  end

  def edit(id, description)
    find_by_id!(id)
    raise ArgumentError, 'please provide a description' if description.nil? || description.empty?

    symbol_id = id.to_s.to_sym
    tasks[symbol_id] = {
      id: tasks[symbol_id][:id],
      description:,
      status: tasks[symbol_id][:status],
      created_at: tasks[symbol_id][:created_at],
      updated_at: Time.now
    }

    save_to_database

    puts 'Task updated successfully'
  end

  def delete(id)
    tasks.delete(id.to_s.to_sym)

    save_to_database

    puts 'Task deleted successfully'
  end

  def find_by_id!(id)
    task = find_by_id(id)
    raise(StandardError, 'Task ID not found') if task.nil?

    task
  end

  def list(status = nil)
    return tasks.values.filter { |task| task[:status] == status } unless status.nil?

    tasks.values
  end

  def print_list(status = nil)
    print_to_table(list(status))
  end

  def mark_in_progress(id)
    find_by_id!(id)

    symbol_id = id.to_s.to_sym
    tasks[symbol_id] = {
      id: tasks[symbol_id][:id],
      description: tasks[symbol_id][:description],
      status: 'in_progress',
      created_at: tasks[symbol_id][:created_at],
      updated_at: Time.now
    }

    save_to_database
  end

  def mark_done(id)
    find_by_id!(id)

    symbol_id = id.to_s.to_sym
    tasks[symbol_id] = {
      id: tasks[symbol_id][:id],
      description: tasks[symbol_id][:description],
      status: 'done',
      created_at: tasks[symbol_id][:created_at],
      updated_at: Time.now
    }

    save_to_database
  end

  def find_by_id(id)
    tasks[id.to_s.to_sym]
  end

  def save_to_database
    save_data(DATABASE_PATH, tasks)
  end
end
