#!/usr/bin/env ruby

require_relative 'classes/task_interface'

def main
  operation = ARGV[0]

  case operation
  when 'add' then TaskInterface.instance.add(ARGV[1])
  when 'update' then TaskInterface.instance.edit(ARGV[1], ARGV[2])
  when 'delete' then TaskInterface.instance.delete(ARGV[1])
  when 'list' then TaskInterface.instance.print_list(ARGV[1])
  when 'mark-in-progress' then TaskInterface.instance.mark_in_progress(ARGV[1])
  when 'mark-done' then TaskInterface.instance.mark_done(ARGV[1])
  else raise ArgumentError, 'Invalid argument'
  end
rescue StandardError => err
  puts err.full_message
end

main if __FILE__ == $PROGRAM_NAME
