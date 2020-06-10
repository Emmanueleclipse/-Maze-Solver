#!/usr/local/bin/ruby

# ########################################
# CMSC 330 - Project 1
# ########################################

#-----------------------------------------------------------
# FUNCTION DECLARATIONS
#-----------------------------------------------------------

def parse(file, command_name)
  if command_name == 'open'
    open_cells = 0
    line = file.gets
    if line == nil then return end
    while line = file.gets do
      # begins with "path", must be path specification
      if line[0...4] != "path"
        x, y, ds, w = line.split(/\s/,4)
        open_cells = open_cells + 1 if ds == ''
      end
    end
    puts open_cells
  elsif command_name == 'bridge'
    bridges = 0
    original_file = file
    line = file.gets
    if line == nil then return end
    
    while line = file.gets do
      if line[0...4] != "path"
        x, y, ds, w = line.split(/\s/,4)
        if ds != ''
          bridges = bridges + is_bridge(original_file, x, y)
        end
      end
    end

    puts bridges
  elsif command_name == "sortcells"
    data = []
    data[0] = ""
    data[1] = ""
    data[2] = ""
    data[3] = ""
    data[4] = ""
    line = file.gets
    if line == nil then return end
    while line = file.gets do

      # begins with "path", must be path specification
      if line[0...4] != "path"
        x, y, ds, w = line.split(/\s/,4)
        if ds == ''
          data[0].concat("(#{x},#{y})")
        else
          count = ds.split('').count
          if count == 1
            data[1].concat("(#{x},#{y})")
          elsif count == 2
            data[2].concat("(#{x},#{y})")
          elsif count == 3
            data[3].concat("(#{x},#{y})")
          else
            data[4].concat("(#{x},#{y})")
          end
        end
      end
    end
    
    data.each_with_index do |d, index|
      puts "#{index},#{d}"
    end
  end
end

def getline(file, x_axis, y_axis)
  
  line = file.gets
  if line == nil then return end
  while line = file.gets do

    # begins with "path", must be path specification
    if line[0...4] != "path"
      x, y, ds, w = line.split(/\s/,4)
      if x_axis.to_s == x && y_axis.to_s == y
        return line
      end
    end
  end

end

def is_bridge(file, x_start, y_start)
  original_file = file
  results = 0
  line = file.gets
  if line == nil then return false end
  while line = file.gets do

    # begins with "path", must be path specification
    if line[0...4] != "path"
      x, y, ds, w = line.split(/\s/,4)
      if x_start.to_s == x && y_start.to_s == y
        chars = ds.split('')
        chars.each do |char|
          if open?(original_file, x_start, y_start, char, 1)
            results = results + 1
          end
        end
      end
    end
  end
  return results
end

def open?(file, xc, yc, direction, count)
  original_file = file
  result = false
  line = getline(original_file, xc, yc)
  x , y, ds, w = line.split(/\s/,4)
  chars = ds.split('')
  chars.each do |char|
    if char == direction
      if count == 2
        result = true
      else
        open?(original_file, xc, yc, direction, count + 1)
      end
    end
  end
  return result
end

#-----------------------------------------------------------
# the following is a parser that reads in a simpler version
# of the maze files.  Use it to get started writing the rest
# of the assignment.  You can feel free to move or modify 
# this function however you like in working on your assignment.

def read_and_print_simple_file(file)
  line = file.gets
  if line == nil then return end

  # read 1st line, must be maze header
  sz, sx, sy, ex, ey = line.split(/\s/)
  puts "header spec: size=#{sz}, start=(#{sx},#{sy}), end=(#{ex},#{ey})"

  # read additional lines
  while line = file.gets do

    # begins with "path", must be path specification
    if line[0...4] == "path"
      p, name, x, y, ds = line.split(/\s/)
      puts "path spec: #{name} starts at (#{x},#{y}) with dirs #{ds}"

    # otherwise must be cell specification (since maze spec must be valid)
    else
      x, y, ds, w = line.split(/\s/,4)
      puts "cell spec: coordinates (#{x},#{y}) with dirs #{ds}"
      ws = w.split(/\s/)
      ws.each {|w| puts "  weight #{w}"}
    end
  end
end

#----------------------------------
def main(command_name, file_name)
  maze_file = open(file_name)

  # perform command
  case command_name
  when "parse"
    parse(maze_file)
  when "print"
    read_and_print_simple_file(maze_file)
  when "open"
    parse(maze_file, command_name)
  when "bridge"
    parse(maze_file, command_name)
  when "sortcells"
    parse(maze_file, command_name)
  else
    fail "Invalid command"
  end
end

