```mermaid
---
title: my_ls
---

classDiagram
    direction LR
    LsCommand -- MultiColumnFormat
    LsCommand -- LongFormat

    class LsCommand{
      +run(String target_path, List options)
      -collect_dir_entry_paths(String target_path, Boolean dot_match, Boolean reverse)
    }
    class MultiColumnFormat{
      +show(List dir_entry_paths)
      -list_file_dir_names(List dir_entry_paths)
      -format_multi_column(List items, Integer col_size)
    }
    class LongFormat{
      +show(List dir_entry_paths)
      -list_long_format_attrs(List dir_entry_paths)
      -format_long_format(List items, Integer width)
      -total_blocksize()
    }

```
