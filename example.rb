$LOAD_PATH.unshift('lib')
require 'treeflat'
require 'yaml'

data = YAML.load <<EOY
---
hierarchy:
- class: Root
  p: r
  subclasses:
    - class: Derived1
      p: d1
    - class: Derived2
      p: d2
EOY

leaves  = TreeFlat::Leaves.new data

leaves.transform(
    LeafTransform.new(['hierarchy',/\d/,'subclasses',/\d/,'class']) do |leaf|
        leaf.path = TreeFlat::Path.new leaf.path[0..3], leaf.path.index_nodes
        leaf.path[2] = 'class'
    end,
    LeafTransform.new(['hierarchy',/\d/,'subclasses',/\d/,'p']) do |leaf|
        leaf.path = TreeFlat::Path.new leaf.path[0..3], leaf.path.index_nodes
        leaf.path[2] = 'p'
    end
)

columns = TreeFlat::Columns.new leaves

# Simple flattening strategy
def indexes_to_key leaf
    leaf.path.index_values.map {|i| sprintf "%02d", i}.join '-' 
end

rows = {}
leaves.each do |leaf|
    key = indexes_to_key leaf
    idx = columns.get_idx_from_path leaf.path
    rows[key] ||= []
    rows[key][idx] = leaf.value
end

def md_table_header *args
    ['| ' + [*args].join(' | ') + ' |', '| :--- ' * [*args].length + '|']
end

def md_row *args
    '| ' + [*args].join(' | ') + ' |'
end

puts md_table_header('rowID',*columns.to_a.map {|c| c.name})
rows.keys.sort.map {|r| puts md_row(r,*rows[r])}
