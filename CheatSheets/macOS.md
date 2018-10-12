# macOS Cheat Sheet

## Partition an External Drive

To partition a 1 TB external drive with APFS use:

```
diskutil partitionDisk disk2 1 GPT APFS "Drive Name" 1T
```

You can only have one partition.
