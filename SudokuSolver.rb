class SudokuSolver
  FIELD_SIZE = 9
  GRID_SIZE = 3
  ALL_NUMBER = (1..9).to_a

  def initialize
    @field = DATA.read.delete("\n").split("").map(&:to_i)
  end

  def display(str=@field.join)
    field = str.delete("\n").split("").map(&:to_i)
    puts "-" * 30
    field.each_slice(FIELD_SIZE) do |ar|
      puts ar.join
    end
  end

  def scan_and_fix
    @field.size.times do |i|
      next if @field[i] != 0
      c = list_candidates(i)
      @field[i] = c[0] if c.size == 1
    end
  end

  def basic_solve
    old_field = []
    until @field == old_field do
      old_field = @field
      scan_and_fix
    end
  end

  def list_candidates(idx)
    indexes = []
    indexes << row_indexes(idx)
    indexes << col_indexes(idx)
    indexes << grid_indexes(idx)
    indexes.flatten!.uniq!
    values = @field.values_at(*indexes)
    values.select!{|v|v!=0}.uniq!
    list = ALL_NUMBER - values
    return list
  end

  def row_indexes(idx)
    y = idx / FIELD_SIZE
    min = y*FIELD_SIZE
    max = min + (FIELD_SIZE-1)
    return (min..max).to_a
  end
 
  def col_indexes(idx)
    x = idx % FIELD_SIZE
    list = []
    max = FIELD_SIZE * FIELD_SIZE - 1
    x.step(max, FIELD_SIZE) do |i|
      list << i
    end
    return list
  end

  def grid_indexes(idx)
    x = idx % FIELD_SIZE
    y = idx / FIELD_SIZE

    grid_x = x / GRID_SIZE
    grid_y = y / GRID_SIZE
    start_idx = (grid_y * GRID_SIZE * FIELD_SIZE) +
                (grid_x * GRID_SIZE)
    list = []
    start_idx.step(start_idx+2) do |n|
      list << [n, n+FIELD_SIZE, n+FIELD_SIZE*2]
    end
    return list.flatten.sort
  end

end

if __FILE__ == $0 then
  masao = SudokuSolver.new
  masao.display

  masao.basic_solve
  masao.display
end

__END__
123456789
456789123
789123456
312645978
645978312
978312645
231564897
564897000
000000000