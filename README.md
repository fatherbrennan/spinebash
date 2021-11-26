This is a dependency-free repository and thus there are multiple limitations that could be fixed with added dependencies - notably compression tools such as the popular [Terser](https://github.com/terser/terser) and [UglifyJS](https://github.com/mishoo/UglifyJS).

## Single-page application (SPA) Framework

## File Structure

**Linking Resources**

JS and CSS files within the Resources directory will be automatically linked.

## Limitations

### File Naming

- camelCase
- PascalCase
- snake_case
- kebab-case

### Build

**JavaScript**

- Files are not concatenated
- File names are to be unique even in nested directories

It is recommended to create a single file if possible for performance.

**Compresson**

Written code will not be minified or validated

- Variable names are unchanged
- Semicolons not added
