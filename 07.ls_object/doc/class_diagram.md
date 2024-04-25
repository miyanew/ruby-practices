```mermaid
---
title: my_ls
---

classDiagram
    direction LR
    LsCommand -- FileDirEntryList
    LsCommand -- LongFormat
    FileDirEntryList -- MyFile
    LongFormat -- MyFile

    class FileDirEntryList{
      +show(List files)
      -collect_files(String filepath)
      -build(List files)
      -format_single_column(List items)
      -format_multi_column(List items, Integer col_size)
    }
    class LongFormat{
      +show(List files)
      -collect_files(String filepath)
      -build(List files)
    }
    class MyFile{
      +String argpath
      +String basename
      +Integer blocks
      +String ftype
      +String permission
      +Integer nlink
      +String uname
      +String gname
      +Integer size
      +Time mtime
    }

```

```mermaid
---
title: my_ls 継承ver
---
classDiagram
    direction LR
    LsCommand -- FileDirEntryList
    LsCommand -- FileList
    LsCommand -- LongFormat
    FileDirEntryList --> FileList
    LongFormat --> FileList
    FileList -- MyFile

    class FileList{
      +show(List files)
      -collect_files(String filepath)
      -build(List files)
    }
    class FileDirEntryList{
      +show(List files)
      -collect_files(String filepath)
      -build(List files)
      -format_single_column(List items)
      -format_multi_column(List items, Integer col_size) 
    }
    class LongFormat{
      +show(List files)
      -collect_files(String filepath)
      -build(List files)
    }
    class MyFile{
      +String argpath
      +String basename
      +Integer blocks
      +String ftype
      +String permission
      +Integer nlink
      +String uname
      +String gname
      +Integer size
      +Time mtime
    }
```
