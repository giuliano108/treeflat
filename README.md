# TreeFlat

TreeFlat attempts to generate a compact table representation of a tree.

A tree is a more or less complex data structure made of (nested) hashes/arrays.

* Flatten the tree into an array of leaves.
* Each `Leaf` has a `Path` and a value.
* A `Path` contains an array of nodes (like directory names in a filesystem path).
* Trees may contain lists of similar subtrees (siblings - like objects of the same class). Within a path, a node name may actually represent a sibling's *index*. A `Path` also contains a list of offsets within the nodes list, pointing to the nodes that actually are indexes.
* *Index nodes* are identified automatically when the flatten method bumps into an array.
* Otherwise, a `LeafTransform` allows to modify a path and/or its `index nodes`.
* In order to create a table out of a tree, we need some header columns. The `Columns` class computes the right column number for each of the given `Leaves`.
* A row number can be computed from the *Index nodes*' values.

## Example

An input tree that describes a root class with two derived subclasses. Each class has a property called "p".

```ruby
# ap data
{
    "hierarchy" => [
        [0] {
                 "class" => "Root",
                     "p" => "r",
            "subclasses" => [
                [0] {
                    "class" => "Derived1",
                        "p" => "d1"
                },
                [1] {
                    "class" => "Derived2",
                        "p" => "d2"
                }
            ]
        }
    ]
}
```

* Get leaves and columns:

```ruby
leaves  = TreeFlat::Leaves.new data
columns = TreeFlat::Columns.new leaves
```

* Use the index nodes values to generate a sortable row identifier. A simple way to do it is by concatenating them.

```ruby
def indexes_to_key leaf
    leaf.path.index_values.map {|i| sprintf "%02d", i}.join '-' 
end
```

* The table will be a hash (keyed by row ID) of arrays.

```ruby
rows = {}
leaves.each do |leaf|
    key = indexes_to_key leaf
    idx = columns.get_idx_from_path leaf.path
    rows[key] ||= []
    rows[key][idx] = leaf.value
end
```

* Finally, print it as a Markdown formatted table.

```ruby
puts md_table_header('rowID',*columns.to_a.map {|c| c.name})
rows.keys.sort.map {|r| puts md_row(r,*rows[r])}
```

The resulting table is:

| rowID | class | p | class | p |
| :--- | :--- | :--- | :--- | :--- |
| 00 | Root | r |
| 00-00 |  |  | Derived1 | d1 |
| 00-01 |  |  | Derived2 | d2 |

TreeFlat captured "class" and "p" in different columns, depending on how
deep they are nested in the tree. What if we don't care about the dept
information and would rather avoid having multiple columns with the same
name? `LeafTransform` can fix that:

```ruby
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
```

The transforms above match the subclasses' "class" and "p" leaves, and modify
the path to achieve what we want (actually, a single LeafTransform with
a `/class|p/` Regexp would've worked just as well).

| rowID | class | p |
| :--- | :--- | :--- |
| 00 | Root | r |
| 00-00 | Derived1 | d1 |
| 00-01 | Derived2 | d2 |

## Installation

Add this line to your application's Gemfile:

    gem 'treeflat', :git => 'https://github.com/giuliano108/treeflat.git', :branch => 'master'

And then execute:

    $ bundle
