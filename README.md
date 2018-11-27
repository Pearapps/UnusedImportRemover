# UnusedImportRemover

#### Script to help you remove unused import statements from your iOS/macOS projects. 

This is a relatively script that is super slow, but has proven on a couple projects to remove a bunch of unused import statements. It works by removing imports one-by-one and then rebuilding your projects and seeing if it builds - if it does then it keeps the import removed and if not it will add it back. 

### Limitations:

1. It is slow, as mentioned before.
2. You must provide the path to the project and how to compile your project in the actual source.
3. Does not take into account all possible preprocessor `#ifdef`s, etc around your imports.
4. Only really used on 2-3 projects so you might have some edge cases and directories you dont want it to touch. 

Feel free to improve the script by opening up a PR - there is a lot of low hanging fruit to make it more general and better!

### Support the project

I make a fun app for tracking steps for your iPhone you can check out: http://bit.ly/18BLeoh 
